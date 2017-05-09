//
//  Zhuge.h
//
//  Copyright (c) 2014 37degree. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ZhugeConfig.h"
@interface Zhuge : NSObject

#pragma mark - 获取实例

/**
 获取诸葛统计的实例。
 */
+ (nonnull Zhuge*)sharedInstance;

/**
 获得诸葛配置实例。
 */
- (nonnull ZhugeConfig *)config;

/**
 获得诸葛设备ID。
 */
- (nonnull NSString *)getDeviceId;
-(nonnull NSString *)getSessionID;
#pragma mark - 开启统计

/**
 开启诸葛统计。
 
 @param appKey 应用Key，网站上注册应用时自动获得
 */
- (void)startWithAppKey:(nonnull NSString*)appKey launchOptions:(nullable NSDictionary*)launchOptions;

#pragma mark - 追踪用户行为

/**
 标识用户。
 
 @param userId     用户ID
 @param properties 用户属性
 */
- (void)identify:(nonnull NSString*)userId properties:(nullable   NSDictionary *)properties;

/**
 追踪自定义事件。
 
 @param event      事件名称
 @param properties 事件属性
 */
- (void)track:(nonnull NSString *)event;
- (void)track:(nonnull NSString *)event properties:(nullable NSDictionary *)properties;
#pragma mark - 推送
// 支持的第三方推送渠道
typedef enum {
    ZG_PUSH_CHANNEL_GETUI = 1, // 个推
    ZG_PUSH_CHANNEL_JPUSH = 2, // 极光推送
    ZG_PUSH_CHANNEL_BAIDU = 3, // 百度云推送
    ZG_PUSH_CHANNEL_XINGE = 4, // 信鸽
    ZG_PUSH_CHANNEL_UMENG = 5, // 友盟推送
    ZG_PUSH_CHANNEL_XIAOMI  = 6
} ZGPushChannel;

// 处理接收到的消息
- (void)handleRemoteNotification:(nonnull NSDictionary *)userInfo;

// 设置第三方推送用户ID
- (void)setThirdPartyPushUserId:(nonnull NSString *)userId forChannel:(ZGPushChannel) channel;
@end
