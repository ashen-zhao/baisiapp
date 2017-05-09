//
//  Compres.h
//  HelloZhuge
//
//  Created by jiaokang on 15/7/27.
//  Copyright (c) 2015年 37degree. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface NSData (NSDataExtension)

// ZLIB

- (NSData *) zlibDeflate;

@end