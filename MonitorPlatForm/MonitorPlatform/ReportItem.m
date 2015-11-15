//
//  ReportItem.m
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ReportItem.h"

@implementation ReportItem

@synthesize code, content, result, pubDate, author;

- (void)dealloc
{
    self.content = nil;
    self.code = nil;
    self.result = nil;
    self.author = nil;
    self.pubDate = nil;
    [super dealloc];
}

- (NSComparisonResult)compare:(ReportItem *)otherObject
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    ReportItem *record1 = (ReportItem*)self;
    NSDate *date1 = [formatter dateFromString:record1.pubDate];
    NSDate *date2 = [formatter dateFromString:otherObject.pubDate];
    [formatter release];
    if([date1 compare:date2] > 0)
        return -1;
    else
        return 1;
}

@end
