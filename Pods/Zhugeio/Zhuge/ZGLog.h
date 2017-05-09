//
//  ZGLog.h
//  iosapp
//
//  Created by jiaokang on 15/10/23.
//  Copyright © 2015年 oschina. All rights reserved.
//
#import <UIKit/UIKit.h>

#ifndef ZGLog_h
#define ZGLog_h
static inline void ZGLog(NSString *format, ...) {
    __block va_list arg_list;
    va_start (arg_list, format);
    NSString *formattedString = [[NSString alloc] initWithFormat:format arguments:arg_list];
    va_end(arg_list);
    NSLog(@"[Zhuge]: %@", formattedString);
}
#ifdef ZHUGE_LOG
#define ZhugeDebug(...) ZGLog(__VA_ARGS__)
#else
#define ZhugeDebug(...)
#endif

#endif /* ZGLog_h */
