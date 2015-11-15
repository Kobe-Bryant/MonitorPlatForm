//
//  NSString+Custom.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

+ (NSString *)toUTF8String:(NSString *)encodeString 
{
    NSString *preprocessedString = (NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)encodeString, CFSTR(""), kCFStringEncodingUTF8);          
    NSString *resultString = [(NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)preprocessedString, nil, nil, kCFStringEncodingUTF8) autorelease];  
    [preprocessedString release];    
    return resultString;
}

+ (NSString *)toGBKString:(NSString *)encodeString
{
    NSString *resultString = (NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)encodeString, nil, nil, kCFStringEncodingGB_18030_2000);
    
    return [resultString autorelease];
}

@end
