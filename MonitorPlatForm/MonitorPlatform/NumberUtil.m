//
//  NumberUtil.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-4-12.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "NumberUtil.h"

@implementation NumberUtil
+(NSString*)moneyFmtFromFolat:(CGFloat)value{
    NSString *floatStr = [NSString stringWithFormat:@"%0.2f",value];
    NSInteger length = [floatStr length];
    NSMutableString *result = [[NSMutableString alloc] initWithCapacity:20];
    NSInteger count = (length-3)/3;
    NSInteger index =  (length-3)%3;//开始的不足三位数字的个数
    if (index != 0) {
        [result appendString:[floatStr substringToIndex:index]];
    }
    
    for (int i = 0; i < count; i++) {
        if (index != 0) {
            [result appendFormat:@",%@",[floatStr substringWithRange:NSMakeRange(index, 3)]];
        }else{
            [result appendFormat:@"%@",[floatStr substringWithRange:NSMakeRange(index, 3)]];
        }
        
        index += 3;
    } 
    [result appendString:[floatStr substringWithRange:NSMakeRange(length-3, 3)]];
    return [result autorelease];
}

@end
