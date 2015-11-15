//
//  SharedInformations.m
//  GMEPS_HZ
//
//  Created by chen on 11-10-11.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "SharedInformations.h"
#import "SynthesizeSingleton.h"


@implementation SharedInformations

+(NSString*)getJJCDFromInt:(NSInteger) num{
    if (num == 0) return @"一般";
    else if (num == 1) return @"紧急";
    else  return @"特急";
}

+(NSString*)getBMJBFromInt:(NSInteger) num{
    if (num == 1) return @"秘密";
    else if (num == 2) return @"机密";
    else  if (num == 3) return @"绝密";
    else return @"内部";
        
}

+(NSString*)getGKLXFromInt:(NSInteger) num{
    if (num == 1) return @"主动公开";
    else if (num == 2) return @"依申请公开";
    else  if (num == 3) return @"不予公开";
    else return @"内部公开";
    
}


+(NSString*)getFWLXFromStr:(NSString*) type{//发文类型
    NSArray * itemAry = [NSArray arrayWithObjects:@"桂环验",@"桂环审",@"桂环复议字",@"桂环委办函",@"桂环党函",@"桂环党字",@"桂环辐字",@"桂环专项办",@"桂环专项办函",@"桂环验字",@"桂环管字",@"桂环罚字",@"桂环办函",@"桂环委办字",@"桂环委字",@"桂环发",@"桂环函",@"桂环报",@"桂环复议字",@"厅务会议",@"办公会议",@"专题会议", nil];
    
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"93",@"92",@"81",@"77",@"76",@"65",@"63", @"62",@"51",@"49",@"44",@"35",@"33",@"32",@"28",@"27",@"26",@"91",@"100",@"101",@"102",nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}

+(NSString*)getLWLXFromStr:(NSString*) type{//来文类型
    NSArray *itemAry = [NSArray arrayWithObjects:@"部（委）来文",@"厅（局）来文",@"市（县）来文",@"厅内各单位来文",@"其他单位来文",@"党委政府来文",@"电话记录", nil];
    
    NSArray *typeAry = [NSArray arrayWithObjects:@"10",@"20",@"30",@"40",@"50",@"21",@"51", 
                    nil];
    int index = 0;
    for(NSString *str in typeAry){
        if ([str isEqualToString:type]) {
            return [itemAry objectAtIndex:index];
        }
        index++;
    }
    return @"";
}

@end
