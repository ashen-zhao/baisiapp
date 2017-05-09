#if ! __has_feature(objc_arc)
#error This file must be compiled with ARC. Either turn on ARC for the project or use -fobjc-arc flag on this file.
#endif
//
//  Zhuge.m
//
//  Copyright (c) 2014 37degree. All rights reserved.
//

#import <UIKit/UIDevice.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#import "Base64.h"
#import "Compres.h"
#import "Zhuge.h"
#import "ZGLog.h"

@interface Zhuge ()
@property (nonatomic, copy) NSString *apiURL;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *deviceId;
@property (nonatomic, strong) NSNumber *sessionId;
@property (nonatomic, copy) NSString *deviceToken;
@property (nonatomic, copy) NSString *cid;
@property (nonatomic,  ) UIBackgroundTaskIdentifier taskId;
@property (nonatomic, strong) dispatch_queue_t serialQueue;
@property (nonatomic, strong) NSMutableArray *eventsQueue;
@property (nonatomic, strong)ZhugeConfig *config;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic) NSUInteger sendCount;
@property (nonatomic, assign) SCNetworkReachabilityRef reachability;
@property (nonatomic, strong) CTTelephonyNetworkInfo *telephonyInfo;
@property (nonatomic, strong) NSString *net;
@property (nonatomic, strong) NSString *radio;

@end

@implementation Zhuge

static void ZhugeReachabilityCallback(SCNetworkReachabilityRef target, SCNetworkReachabilityFlags flags, void *info) {
    if (info != NULL && [(__bridge NSObject*)info isKindOfClass:[Zhuge class]]) {
        @autoreleasepool {
            Zhuge *zhuge = (__bridge Zhuge *)info;
            [zhuge reachabilityChanged:flags];
        }
    }
}

static Zhuge *sharedInstance = nil;

#pragma mark - 初始化

+ (Zhuge *)sharedInstance {
    if (sharedInstance == nil) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedInstance = [[super alloc] init];
            sharedInstance.apiURL = @"https://apipool.zhugeio.com";
            sharedInstance.config = [[ZhugeConfig alloc] init];
        });
        
        return sharedInstance;
    }
    
    return sharedInstance;
}
- (ZhugeConfig *)config {
    return _config;
}
- (void)startWithAppKey:(NSString *)appKey launchOptions:(NSDictionary *)launchOptions{
    @try {
        if (appKey == nil || [appKey length] == 0) {
            ZhugeDebug(@"appKey不能为空。");
            return;
        }
        self.appKey = appKey;
        self.userId = @"";
        self.deviceId = [self defaultDeviceId];
        self.deviceToken = @"";
        self.cid = @"";
        self.sessionId = 0;
        self.net = @"";
        self.radio = @"";
        self.telephonyInfo = [[CTTelephonyNetworkInfo alloc] init];
        self.taskId = UIBackgroundTaskInvalid;
        NSString *label = [NSString stringWithFormat:@"io.zhuge.%@.%p", appKey, self];
        self.serialQueue = dispatch_queue_create([label UTF8String], DISPATCH_QUEUE_SERIAL);
        self.eventsQueue = [NSMutableArray array];
        // SDK配置
        if(self.config) {
            ZhugeDebug(@"SDK系统配置: %@", self.config);
        }
        if (self.config.debug) {
            [self.config setSendInterval:2];
        }
        
        [self setupListeners];
        [self unarchive];
        if (launchOptions && launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey]) {
            [self trackPush:launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey] type:@"launch"];
        }
        [self sessionStart];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"startWithAppKey exception");
    }
}

#pragma mark - 诸葛配置
- (NSString *)getDeviceId {
    if (!self.deviceId) {
        self.deviceId = [self defaultDeviceId];
    }
    
    return self.deviceId;
}
-(NSString *)getSessionID{

    if (!self.sessionId) {
        self.sessionId = 0;
    }
    return [NSString stringWithFormat:@"%.3f", [self.sessionId doubleValue]];
}
// 监听网络状态和应用生命周期
- (void)setupListeners{
    BOOL reachabilityOk = NO;
    if ((_reachability = SCNetworkReachabilityCreateWithName(NULL, "www.baidu.com")) != NULL) {
        SCNetworkReachabilityContext context = {0, (__bridge void*)self, NULL, NULL, NULL};
        if (SCNetworkReachabilitySetCallback(_reachability, ZhugeReachabilityCallback, &context)) {
            if (SCNetworkReachabilitySetDispatchQueue(_reachability, self.serialQueue)) {
                reachabilityOk = YES;
            } else {
                SCNetworkReachabilitySetCallback(_reachability, NULL, NULL);
            }
        }
    }
    if (!reachabilityOk) {
            ZhugeDebug(@"failed to set up reachability callback: %s", SCErrorString(SCError()));
    }
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    // 网络制式(GRPS,WCDMA,LTE,...),IOS7以上版本才支持
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
    if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_6_1) {
        [self setCurrentRadio];
        [notificationCenter addObserver:self
                               selector:@selector(setCurrentRadio)
                                   name:CTRadioAccessTechnologyDidChangeNotification
                                 object:nil];
    }
#endif
    
    // 应用生命周期通知
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillTerminate:)
                               name:UIApplicationWillTerminateNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationWillResignActive:)
                               name:UIApplicationWillResignActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidBecomeActive:)
                               name:UIApplicationDidBecomeActiveNotification
                             object:nil];
    [notificationCenter addObserver:self
                           selector:@selector(applicationDidEnterBackground:)
                               name:UIApplicationDidEnterBackgroundNotification
                             object:nil];
}

#pragma mark - 推送

- (void)uploadDeviceToken:(NSString *)deviceToken {
    dispatch_async(self.serialQueue, ^{
        NSNumber *ts = @(round([[NSDate date] timeIntervalSince1970]));
        NSError *error = nil;
        NSString *requestData = [NSString stringWithFormat:@"method=setting_srv.upload_token_tmp&dev=%@&appid=%@&did=%@&dtype=2&token=%@&timestamp=%@", self.config.apsProduction? @"0" : @"1", self.appKey, self.deviceId, deviceToken, ts];
        NSData *responseData = [self apiRequest:@"/open/" WithData:requestData andError:nil];
        if (responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
            if (response && response[@"data"]) {
                NSDictionary *zgData = response[@"data"];
                if ([zgData isKindOfClass:[NSDictionary class]] && zgData[@"cid"]) {
                    self.cid = zgData[@"cid"];
                    ZhugeDebug(@"get cid:%@", self.cid);
                }
            }
        }else{
            ZhugeDebug(@"上传设备信息失败");
        }
    });
}

// 处理接收到的消息
- (void)handleRemoteNotification:(NSDictionary *)userInfo {
    [self trackPush:userInfo type:@"rec"];
}
//清楚通知消息
-(void)clearNotification{
    dispatch_async(self.serialQueue, ^{
        NSNumber *ts = @(round([[NSDate date] timeIntervalSince1970]));
        NSString *requestData = [NSString stringWithFormat:@"setting_srv.clear_msg_cnt&cid=%@&timestamp=%@", self.cid, ts];
        NSData *responseData = [self apiRequest:@"/open/" WithData:requestData andError:nil];
        if (responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
            if (response && response[@"return_code"]) {
                NSInteger code = [response[@"return_code"] integerValue];
                if (0!=code) {
                    
                }
            }
        }else{
            ZhugeDebug(@"清除通知消息失败，检查网络连接。");
        }
    });
}
#pragma mark - 应用生命周期
- (void)applicationDidBecomeActive:(NSNotification *)notification {
    @try {
        ZhugeDebug(@"applicationDidBecomeActive");
        [self sessionStart];
        [self uploadDeviceInfo];
        [self startFlushTimer];
       
    
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationDidBecomeActive exception");
    }
}

- (void)applicationWillResignActive:(NSNotification *)notification {
    @try {
        ZhugeDebug(@"applicationWillResignActive");
        [self sessionEnd];
        [self stopFlushTimer];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationWillResignActive exception");
    }
}

- (void)applicationDidEnterBackground:(NSNotification *)notification {
    @try {
        ZhugeDebug(@"applicationDidEnterBackground");
        self.taskId = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
            [[UIApplication sharedApplication] endBackgroundTask:self.taskId];
            self.taskId = UIBackgroundTaskInvalid;
        }];
        
        [self flush];
        
        dispatch_async(_serialQueue, ^{
            [self archive];
            if (self.taskId != UIBackgroundTaskInvalid) {
                [[UIApplication sharedApplication] endBackgroundTask:self.taskId];
                self.taskId = UIBackgroundTaskInvalid;
            }
        });
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationDidEnterBackground exception");
    }
}

- (void)applicationWillTerminate:(NSNotification *)notification {
    @try {
        
        ZhugeDebug(@"applicationWillTerminate");
        dispatch_async(_serialQueue, ^{
            [self archive];
        });
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"applicationWillTerminate exception");
    }
}

#pragma mark - 设备ID

// 设备ID
- (NSString *)defaultDeviceId {
    // IDFA
    NSString *deviceId = [self adid];
    
    // IDFV from KeyChain
    if (!deviceId) {
        deviceId = [self idFromKeyChain];
    }
    
    if (!deviceId) {
        ZhugeDebug(@"error getting device identifier: falling back to uuid");
        deviceId = [[NSUUID UUID] UUIDString];
    }
    return deviceId;
}

// 广告ID
- (NSString *)adid {
    NSString *adid = nil;
#ifndef ZHUGE_NO_ADID
    Class ASIdentifierManagerClass = NSClassFromString(@"ASIdentifierManager");
    if (ASIdentifierManagerClass) {
        SEL sharedManagerSelector = NSSelectorFromString(@"sharedManager");
        id sharedManager = ((id (*)(id, SEL))[ASIdentifierManagerClass methodForSelector:sharedManagerSelector])(ASIdentifierManagerClass, sharedManagerSelector);
        SEL advertisingIdentifierSelector = NSSelectorFromString(@"advertisingIdentifier");
        NSUUID *uuid = ((NSUUID* (*)(id, SEL))[sharedManager methodForSelector:advertisingIdentifierSelector])(sharedManager, advertisingIdentifierSelector);
        adid = [uuid UUIDString];
    }
#endif
    return adid;
}

- (NSString *)newStoredID {
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(query, kSecClass, kSecClassGenericPassword);
    CFDictionarySetValue(query, kSecAttrAccount, CFSTR("zgid_account"));
    CFDictionarySetValue(query, kSecAttrService, CFSTR("zgid_service"));
    
    NSString *uuid = nil;
    if (NSClassFromString(@"UIDevice")) {
        uuid = [[UIDevice currentDevice].identifierForVendor UUIDString];
    } else {
        uuid = [[NSUUID UUID] UUIDString];
    }
    
    CFDataRef dataRef = CFBridgingRetain([uuid dataUsingEncoding:NSUTF8StringEncoding]);
    CFDictionarySetValue(query, kSecValueData, dataRef);
    OSStatus status = SecItemAdd(query, NULL);
    
    if (status != noErr) {
        ZhugeDebug(@"Keychain Save Error: %d", (int)status);
        uuid = nil;
    }
    
    CFRelease(dataRef);
    CFRelease(query);
    
    return uuid;
}

- (NSString *)idFromKeyChain {
    CFMutableDictionaryRef query = CFDictionaryCreateMutable(kCFAllocatorDefault, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CFDictionarySetValue(query, kSecClass, kSecClassGenericPassword);
    CFDictionarySetValue(query, kSecAttrAccount, CFSTR("zgid_account"));
    CFDictionarySetValue(query, kSecAttrService, CFSTR("zgid_service"));
    
    // See if the attribute exists
    CFTypeRef attributeResult = NULL;
    OSStatus status = SecItemCopyMatching(query, (CFTypeRef *)&attributeResult);
    if (attributeResult != NULL)
        CFRelease(attributeResult);
    
    if (status != noErr) {
        CFRelease(query);
        if (status == errSecItemNotFound) {
            return [self newStoredID];
        } else {
            ZhugeDebug(@"Unhandled Keychain Error %d", (int)status);
            return nil;
        }
    }
    
    // Fetch stored attribute
    CFDictionaryRemoveValue(query, kSecReturnAttributes);
    CFDictionarySetValue(query, kSecReturnData, (id)kCFBooleanTrue);
    CFTypeRef resultData = NULL;
    status = SecItemCopyMatching(query, &resultData);
    
    if (status != noErr) {
        CFRelease(query);
        if (status == errSecItemNotFound){
            return [self newStoredID];
        } else {
            ZhugeDebug(@"Unhandled Keychain Error %d", (int)status);
            return nil;
        }
    }
    
    NSString *uuid = nil;
    if (resultData != NULL)  {
        uuid = [[NSString alloc] initWithData:CFBridgingRelease(resultData) encoding:NSUTF8StringEncoding];
    }
    
    CFRelease(query);
    
    return uuid;
}

#pragma mark - 设备状态

// 是否在后台运行
- (BOOL)inBackground {
    return [UIApplication sharedApplication].applicationState == UIApplicationStateBackground;
}

// 系统信息
- (NSString *)getSysInfoByName:(char *)typeSpecifier {
    size_t size;
    sysctlbyname(typeSpecifier, NULL, &size, NULL, 0);
    char *answer = malloc(size);
    sysctlbyname(typeSpecifier, answer, &size, NULL, 0);
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    free(answer);
    return results;
}

// 分辨率
- (NSString *)resolution {
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGFloat scale = [[UIScreen mainScreen] scale];
    return [[NSString alloc] initWithFormat:@"%.fx%.f",rect.size.width*scale,rect.size.height*scale];
}

// 运营商
- (NSString *)carrier {
    CTCarrier *carrier =[self.telephonyInfo subscriberCellularProvider];
    if (carrier != nil) {
        NSString *mcc =[carrier mobileCountryCode];
        NSString *mnc =[carrier mobileNetworkCode];
        return [NSString stringWithFormat:@"%@%@", mcc, mnc];
    }
    
    return @"";
}

// 是否越狱
- (BOOL)isJailBroken {
    static const char * __jb_app = NULL;
    static const char * __jb_apps[] = {
        "/Application/Cydia.app",
        "/Application/limera1n.app",
        "/Application/greenpois0n.app",
        "/Application/blackra1n.app",
        "/Application/blacksn0w.app",
        "/Application/redsn0w.app",
        NULL
    };
    __jb_app = NULL;
    for ( int i = 0; __jb_apps[i]; ++i ) {
        if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithUTF8String:__jb_apps[i]]]) {
            __jb_app = __jb_apps[i];
            return YES;
        }
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:@"/private/var/lib/apt/"]) {
        return YES;
    }

    return NO;
}

// 是否破解
- (BOOL)isPirated {
    NSString *bundlePath = [[NSBundle mainBundle] bundlePath];
    /* SC_Info */
    if (![[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/SC_Info",bundlePath]]) {
        return YES;
    }
    /* iTunesMetadata.plist */
    if ([[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithFormat:@"%@/iTunesMetadata.plist",bundlePath]]) {
        return YES;
    }
    return NO;
}

// 更新网络指示器
- (void)updateNetworkActivityIndicator:(BOOL)on {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = on;
}

- (void)reachabilityChanged:(SCNetworkReachabilityFlags)flags {
    if (flags & kSCNetworkReachabilityFlagsReachable) {
        if (flags & kSCNetworkReachabilityFlagsIsWWAN) {
            self.net = @"1";//2G/3G/4G
        } else {
            self.net = @"4";//WIFI
        }
    } else {
        self.net = @"0";//未知
    }
    ZhugeDebug(@"联网状态: %@", [@"0" isEqualToString:self.net]?@"未知":[@"1" isEqualToString:self.net]?@"移动网络":@"WIFI");
}

// 网络制式(GPRS,WCDMA,LTE,...)
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 70000
- (void)setCurrentRadio {
    dispatch_async(self.serialQueue, ^(){
        self.radio = [self currentRadio];
        ZhugeDebug(@"网络制式: %@", self.radio);
    });
}

- (NSString *)currentRadio {
    NSString *radio = _telephonyInfo.currentRadioAccessTechnology;
    if (!radio) {
        radio = @"None";
    } else if ([radio hasPrefix:@"CTRadioAccessTechnology"]) {
        radio = [radio substringFromIndex:23];
    }
    return radio;
}
#endif

#pragma mark - 事件跟踪

// 会话开始
- (void)sessionStart {
    @try {
        if (!self.sessionId) {
            NSNumber *ts = @([[NSDate date] timeIntervalSince1970]);
            self.sessionId = ts;
            ZhugeDebug(@"会话开始(ID:%@)", @([self.sessionId intValue]));
            
            NSMutableDictionary *e = [NSMutableDictionary dictionary];
            e[@"et"] = @"ss";
            e[@"sid"] = [NSString stringWithFormat:@"%.3f", [self.sessionId doubleValue]];
            e[@"vn"] = self.config.appVersion;
            e[@"net"] = self.net;
            e[@"radio"] = self.radio;
            [self enqueueEvent:e];
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"sessionStart exception");
    }
}

// 会话结束
- (void)sessionEnd {
    @try {
        ZhugeDebug(@"会话结束(ID:%@)", self.sessionId);
    
        if (self.sessionId) {
            NSNumber *ts = @([[NSDate date] timeIntervalSince1970]);
            NSMutableDictionary *e = [NSMutableDictionary dictionary];
            e[@"et"] = @"se";
            e[@"sid"] = [NSString stringWithFormat:@"%.3f", [self.sessionId doubleValue]];
            e[@"dr"] = [NSString stringWithFormat:@"%.3f", [ts doubleValue] - [self.sessionId doubleValue]];
            e[@"ts"] = [NSString stringWithFormat:@"%.3f", [ts doubleValue]];
            [self enqueueEvent:e];
            self.sessionId = nil;
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"sessionEnd exception");
    }
}

// 上报设备信息
- (void)uploadDeviceInfo {
    @try {
        NSNumber *zgInfoUploadTime = [[NSUserDefaults standardUserDefaults] objectForKey:@"zgInfoUploadTime"];
        NSNumber *ts = @(round([[NSDate date] timeIntervalSince1970]));
        if (zgInfoUploadTime == nil ||[ts longValue] > [zgInfoUploadTime longValue] + 7*86400) {
            [self trackDeviceInfo];
            [[NSUserDefaults standardUserDefaults] setObject:ts forKey:@"zgInfoUploadTime"];
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"uploadDeviceInfo exception");
    }
}

// 上报设备信息
- (void)trackDeviceInfo {
    @try {
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"et"] = @"info";

        // 设备ID
        e[@"did"] = self.deviceId;
        // 应用版本
        e[@"vn"] = self.config.appVersion;
        // 应用名称
        NSString *displayName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
        if (displayName != nil) {
            e[@"pn"] = displayName;
        }
        // SDK
        e[@"sdk"] = @"ios";
        // SDK版本
        e[@"sdkv"] = self.config.sdkVersion;
        // 设备
        e[@"dv"] = [self getSysInfoByName:"hw.machine"];
        // 系统
        e[@"os"] = @"ios";
        // 制造商
        e[@"maker"] = @"Apple";
        // 系统版本
        e[@"ov"] = [[UIDevice currentDevice] systemVersion];
        //分辨率
        e[@"rs"] = [self resolution];
        // 运营商
        e[@"cr"] = [self carrier];
        //网络
        e[@"net"] = self.net;
        e[@"radio"] = self.radio;
        // 是否越狱
        e[@"jail"] =[self isJailBroken] ? @YES : @NO;
        // 是否破解
        e[@"pirate"] =[self isPirated] ? @YES : @NO;
        // 语言
        e[@"lang"] = [[NSLocale preferredLanguages] objectAtIndex:0];
        // 时区
        e[@"tz"] = [NSString stringWithFormat:@"%@",[NSTimeZone localTimeZone]];
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"trackDeviceInfo exception");
    }
}

// 识别用户
- (void)identify:(NSString *)userId properties:(NSDictionary *)properties {
    @try {
        if (userId == nil || userId.length == 0) {
            
            ZhugeDebug(@"用户ID不能为空");
            return;
        }
        
        if (!self.sessionId) {
            [self sessionStart];
        }
    
        self.userId = userId;
    
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"et"] = @"idf";
        e[@"cuid"] = userId;
        e[@"sid"] = [NSString stringWithFormat:@"%.3f", [self.sessionId doubleValue]];
        e[@"pr"] =[NSDictionary dictionaryWithDictionary:properties];
    
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"identify exception");
    }
}
// 跟踪自定义事件
- (void)track:(NSString *)event {
    [self track:event properties:nil];
}

// 跟踪自定义事件
- (void)track:(NSString *)event properties:(NSMutableDictionary *)properties {
    @try {
        if (event == nil || [event length] == 0) {
            ZhugeDebug(@"事件名不能为空");
            return;
        }
        
        if (!self.sessionId) {
            [self sessionStart];
        }
    
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"et"] = @"cus";
        e[@"eid"] = event;
        e[@"sid"] = [NSString stringWithFormat:@"%.3f", [self.sessionId doubleValue]];
        e[@"pr"] =[NSDictionary dictionaryWithDictionary:properties];
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"track properties exception");
    }
}

// 上报推送已读
- (void)trackPush:(NSDictionary *)userInfo type:(NSString *) type {
    @try {
        
        ZhugeDebug(@"push payload: %@", userInfo);
        if (userInfo && userInfo[@"mid"]) {
            NSMutableDictionary *e = [NSMutableDictionary dictionary];
            e[@"et"] = @"push";
            e[@"mid"] = userInfo[@"mid"];
            e[@"mtype"] = type;
            [self enqueueEvent:e];
            [self flush];
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"trackPush exception");
    }
}

// 设置第三方推送用户ID
- (void)setThirdPartyPushUserId:(NSString *)userId forChannel:(ZGPushChannel) channel {
    @try {
        if (userId == nil || [userId length] == 0) {
            ZhugeDebug(@"userId不能为空");

            return;
        }
        
        NSMutableDictionary *pr = [NSMutableDictionary dictionary];
        pr[@"channel"] = [self nameForChannel:channel];
        pr[@"user_id"] = userId;
        
        NSMutableDictionary *e = [NSMutableDictionary dictionary];
        e[@"et"] = @"3rdpush";
        e[@"pr"] = pr;
        
        [self enqueueEvent:e];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"track properties exception");
    }
}

-(NSString *)nameForChannel:(ZGPushChannel) channel {
    switch (channel) {
        case ZG_PUSH_CHANNEL_JPUSH:
            return @"jpush";
        case ZG_PUSH_CHANNEL_UMENG:
            return @"umeng";
        case ZG_PUSH_CHANNEL_BAIDU:
            return @"baidu";
        case ZG_PUSH_CHANNEL_XINGE:
            return @"xinge";
        case ZG_PUSH_CHANNEL_GETUI:
            return @"getui";
        case ZG_PUSH_CHANNEL_XIAOMI:
            return @"xiaomi";
        default:
            return @"";
    }
}

// 事件包装
- (NSMutableDictionary *)wrapEvents:(NSArray *) events {
    NSMutableDictionary *batch = [NSMutableDictionary dictionary];
    batch[@"type"] = @"statis";
    batch[@"sdk"] = @"ios";
    batch[@"sdkv"] = self.config.sdkVersion;
    if (self.config.debug) {
        batch[@"debug"] = @1;
    }
    batch[@"ts"] = @(round([[NSDate date] timeIntervalSince1970]));
    batch[@"cn"] = self.config.channel;
    batch[@"ak"] = self.appKey;
    batch[@"did"] = self.deviceId;
    if (self.userId.length > 0) {
        batch[@"cuid"] = self.userId;
    }
    batch[@"net"] = self.net;
    batch[@"radio"] = self.radio;
    batch[@"deviceToken"] = self.deviceToken;
    batch[@"data"] = events;
    return batch;
}

#pragma mark - 编码&解码

// JSON序列化
- (NSData *)JSONSerializeObject:(id)obj {
    id coercedObj = [self JSONSerializableObjectForObject:obj];
    NSError *error = nil;
    NSData *data = nil;
    @try {
        data = [NSJSONSerialization dataWithJSONObject:coercedObj options:0 error:&error];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"%@ exception encoding api data: %@", self, exception);
    }
    if (error) {
            ZhugeDebug(@"%@ error encoding api data: %@", self, error);
        
    }
    return data;
}

// JSON序列化
- (id)JSONSerializableObjectForObject:(id)obj {
    // valid json types
    if ([obj isKindOfClass:[NSString class]] ||
        [obj isKindOfClass:[NSNumber class]] ||
        [obj isKindOfClass:[NSNull class]]) {
        return obj;
    }
    // recurse on containers
    if ([obj isKindOfClass:[NSArray class]]) {
        NSMutableArray *a = [NSMutableArray array];
        for (id i in obj) {
            [a addObject:[self JSONSerializableObjectForObject:i]];
        }
        return [NSArray arrayWithArray:a];
    }
    if ([obj isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        for (id key in obj) {
            NSString *stringKey;
            if (![key isKindOfClass:[NSString class]]) {
                stringKey = [key description];
            } else {
                stringKey = [NSString stringWithString:key];
            }
            id v = [self JSONSerializableObjectForObject:obj[key]];
            d[stringKey] = v;
        }
        return [NSDictionary dictionaryWithDictionary:d];
    }

    // default to sending the object's description
    NSString *s = [obj description];
    return s;
}

// API数据编码
- (NSString *)encodeAPIData:(NSMutableDictionary *) batch {
    NSData *data = [self JSONSerializeObject:batch];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

#pragma mark - 上报策略

// 启动事件发送定时器
- (void)startFlushTimer {
    [self stopFlushTimer];
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.config.sendInterval > 0) {
                self.timer = [NSTimer scheduledTimerWithTimeInterval:self.config.sendInterval
                                                        target:self
                                                        selector:@selector(flush)
                                                        userInfo:nil
                                                        repeats:YES];
            
            ZhugeDebug(@"启动事件发送定时器");
        }
    });
}

// 关闭事件发送定时器
- (void)stopFlushTimer {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.timer) {
            [self.timer invalidate];
            ZhugeDebug(@"关闭事件发送定时器");
        }
        self.timer = nil;
    });
}

#pragma mark - 事件上报

// 事件加入待发队列

- (void)enqueueEvent:(NSMutableDictionary *)event {
    dispatch_async(self.serialQueue, ^{
        [self syncEnqueueEvent:event];
    });
}

- (void)syncEnqueueEvent:(NSMutableDictionary *)event {
    NSNumber *ts = @([[NSDate date] timeIntervalSince1970]);

    if (!event[@"ts"]) {
        event[@"ts"] = [NSString stringWithFormat:@"%.3f", [ts doubleValue]];
    }
    
    ZhugeDebug(@"产生事件: %@", event);
    [self.eventsQueue addObject:event];
    if ([self.eventsQueue count] > self.config.cacheMaxSize) {
        [self.eventsQueue removeObjectAtIndex:0];
    }
}

- (void)flush {
    dispatch_async(self.serialQueue, ^{
        [self flushQueue: _eventsQueue];
    });
}

- (void)flushQueue:(NSMutableArray *)queue {
    @try {
        while ([queue count] > 0) {
            if (self.sendCount >= self.config.sendMaxSizePerDay) {
                
                ZhugeDebug(@"超过每天限额，不发送。(今天已经发送:%lu, 限额:%lu, 队列库存数: %lu)", (unsigned long)self.sendCount, (unsigned long)self.config.sendMaxSizePerDay, (unsigned long)[queue count]);
                return;
            }
            
            NSUInteger sendBatchSize = ([queue count] > 50) ? 50 : [queue count];
            if (self.sendCount + sendBatchSize >= self.config.sendMaxSizePerDay) {
                sendBatchSize = self.config.sendMaxSizePerDay - self.sendCount;
            }
            
            NSArray *events = [queue subarrayWithRange:NSMakeRange(0, sendBatchSize)];
            
            ZhugeDebug(@"开始上报事件(本次上报事件数:%lu, 队列内事件总数:%lu, 今天已经发送:%lu, 限额:%lu)", (unsigned long)[events count], (unsigned long)[queue count], (unsigned long)self.sendCount, (unsigned long)self.config.sendMaxSizePerDay);
            
            NSString *eventData = [self encodeAPIData:[self wrapEvents:events]];
            
            ZhugeDebug(@"上传事件：%@",eventData);
            NSData *eventDataBefore = [eventData dataUsingEncoding:NSUTF8StringEncoding];
            NSData *zlibedData = [eventDataBefore zlibDeflate];
            
            NSString *event = [zlibedData base64EncodedString];
            NSString *result = [[event stringByReplacingOccurrencesOfString:@"\r" withString:@""] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            
            NSString *requestData = [NSString stringWithFormat:@"method=event_statis_srv.upload&compress=1&event=%@", result];


            NSData *response = [self apiRequest:@"/APIPOOL/" WithData:requestData andError:nil];
            if (!response) {
                ZhugeDebug(@"上传事件失败");
                break;
            }
            ZhugeDebug(@"上传事件成功");
            self.sendCount += sendBatchSize;
           [queue removeObjectsInArray:events];
        }
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"flushQueue exception");
    }
}


- (NSData*) apiRequest:(NSString *)endpoint WithData:(NSString *)requestData andError:(NSError *)error {
    BOOL success = NO;
    int  retry = 0;
    NSData *responseData = nil;
    while (!success && retry < 3) {
        NSURL *URL = nil;
        if (retry > 0) {
            URL = [NSURL URLWithString:@"https://apipoolback.zhugeio.com/upload"];
        }else{
            URL = [NSURL URLWithString:[self.apiURL stringByAppendingString:endpoint]];
        }
        ZhugeDebug(@"api request url = %@ , retry = %d",URL,retry);
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
        [request setValue:@"gzip" forHTTPHeaderField:@"Accept-Encoding"];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:[[requestData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding]];
        
        [self updateNetworkActivityIndicator:YES];
        
        NSURLResponse *urlResponse = nil;
        NSError *reqError = nil;
        responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&reqError];
        if (reqError) {
            ZhugeDebug(@"error : %@",reqError);
            retry++;
            continue;
        }
        [self updateNetworkActivityIndicator:NO];
        
        if (responseData != nil) {
            NSString *response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
            ZhugeDebug(@"API响应: %@",response);
            success = YES;
        }
    }
    if (!success) {
        return nil;
    }
    return responseData;
}

#pragma  mark - 持久化

// 文件根路径
- (NSString *)filePathForData:(NSString *)data {
    NSString *filename = [NSString stringWithFormat:@"zhuge-%@-%@.plist", self.appKey, data];
    return [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject]
            stringByAppendingPathComponent:filename];
}

// 事件路径
- (NSString *)eventsFilePath {
    return [self filePathForData:@"events"];
}

// 属性路径
- (NSString *)propertiesFilePath {
    return [self filePathForData:@"properties"];
}
- (void)archive {
    @try {
        [self archiveEvents];
        [self archiveProperties];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"archive exception");
    }
}
- (void)archiveEvents {
    NSString *filePath = [self eventsFilePath];
    NSMutableArray *eventsQueueCopy = [NSMutableArray arrayWithArray:[self.eventsQueue copy]];
    ZhugeDebug(@"保存事件到 %@",filePath);
    if (![NSKeyedArchiver archiveRootObject:eventsQueueCopy toFile:filePath]) {
        ZhugeDebug(@"事件保存失败");
    }
}

- (void)archiveProperties {
    NSString *filePath = [self propertiesFilePath];
    NSMutableDictionary *p = [NSMutableDictionary dictionary];
    [p setValue:self.userId forKey:@"userId"];
    [p setValue:self.deviceId forKey:@"deviceId"];
    [p setValue:self.sessionId forKey:@"sessionId"];
    [p setValue:self.cid forKey:@"cid"];

    NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
    [DateFormatter setDateFormat:@"yyyyMMdd"];
    NSString *today = [DateFormatter stringFromDate:[NSDate date]];
    [p setValue:[NSString stringWithFormat:@"%lu",(unsigned long)self.sendCount] forKey:[NSString stringWithFormat:@"sendCount-%@", today]];

    ZhugeDebug(@"保存属性到 %@: %@",  filePath, p);
    if (![NSKeyedArchiver archiveRootObject:p toFile:filePath]) {
        ZhugeDebug(@"属性保存失败");
    }
}

- (void)unarchive {
    @try {
        [self unarchiveEvents];
        [self unarchiveProperties];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"unarchive exception");
    }
}

- (id)unarchiveFromFile:(NSString *)filePath {
    id unarchivedData = nil;
    @try {
        unarchivedData = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
    }
    @catch (NSException *exception) {
        ZhugeDebug(@"恢复数据失败");
        unarchivedData = nil;
    }
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        NSError *error;
        BOOL removed = [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (!removed) {
            ZhugeDebug(@"删除数据失败 %@", error);
        }
    }
    return unarchivedData;
}

- (void)unarchiveEvents {
    self.eventsQueue = (NSMutableArray *)[self unarchiveFromFile:[self eventsFilePath]];
    if (!self.eventsQueue) {
        self.eventsQueue = [NSMutableArray array];
    }
}

- (void)unarchiveProperties {
    NSDictionary *properties = (NSDictionary *)[self unarchiveFromFile:[self propertiesFilePath]];
    if (properties) {
        self.userId = properties[@"userId"] ? properties[@"userId"] : @"";
        self.deviceId = properties[@"deviceId"] ? properties[@"deviceId"] : [self defaultDeviceId];
        self.sessionId = properties[@"sessionId"] ? properties[@"sessionId"] : nil;
        self.cid = properties[@"cid"] ? properties[@"cid"] : nil;
        
        NSDateFormatter *DateFormatter=[[NSDateFormatter alloc] init];
        [DateFormatter setDateFormat:@"yyyyMMdd"];
        NSString *today = [DateFormatter stringFromDate:[NSDate date]];
        NSString *sendCountKey = [NSString stringWithFormat:@"sendCount-%@", today];
        self.sendCount = properties[sendCountKey] ? [properties[sendCountKey] intValue] : 0;
    }
}
@end
