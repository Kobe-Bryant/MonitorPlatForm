//
//  ReportDetailItem.m
//  MonitorPlatform
//
//  Created by 曾静 on 13-6-3.
//  Copyright (c) 2013年 深圳市博安达软件开发有限公司. All rights reserved.
//

#import "ReportDetailItem.h"

@implementation ReportDetailItem

@synthesize reportAuthor,pubDate,reportLocation,reportResult,pollutionName,stdStage,hasOverPass;

- (void)dealloc
{
    self.reportAuthor = nil;
    self.pubDate = nil;
    self.reportLocation = nil;
    self.reportResult = nil;
    self.pollutionName = nil;
    self.stdStage = nil;
    self.hasOverPass = nil;
    [super dealloc];
}

@end
