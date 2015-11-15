//
//  NSString+Custom.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)

+ (NSString *)toUTF8String:(NSString *)encodeString;

+ (NSString *)toGBKString:(NSString *)encodeString;
@end
