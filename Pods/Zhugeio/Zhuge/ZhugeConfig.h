//
//  ZhugeConfig.h
//
//  Copyright (c) 2014 37degree. All rights reserved.
//

#import <Foundation/Foundation.h>

/* SDK版本 */
#define ZG_SDK_VERSION @"2.1.1"

/* 默认应用版本 */
#define ZG_APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

/* 渠道 */
#define ZG_CHANNEL @"App Store"

@interface ZhugeConfig : NSObject

#pragma mark - 基本设置
// SDK版本
@property (nonatomic, copy) NSString *sdkVersion;
// 应用版本(默认:info.plist中CFBundleShortVersionString对应的值)
@property (nonatomic, copy) NSString *appVersion;
// 渠道(默认:@"App Store")
@property (nonatomic, copy) NSString *channel;
// 两次会话时间间隔(默认:30秒)
@property (nonatomic) NSUInteger sessionInterval;

#pragma mark - 发送策略
// 上报时间间隔(默认:10秒)
@property  NSUInteger sendInterval;
// 每天最大上报事件数，超出部分缓存到本地(默认:500个)
@property (nonatomic) NSUInteger sendMaxSizePerDay;
// 本地缓存事件数(默认:500个)
@property (nonatomic) NSUInteger cacheMaxSize;

// 是否开启实时调试(默认:关闭)
@property (nonatomic) BOOL debug;


// 是否推送到生产环境，默认YES(推送时指定deviceToken上传到开发环境或生产环境)
@property (nonatomic) BOOL apsProduction;
@end
