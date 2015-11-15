//
//  RecordItem.m
//  MonitorPlatform
//
//  Created by 张仁松 on 13-6-4.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "RecordItem.h"

@implementation RecordItem

@synthesize recordBH,serviceName,recordName;

-(void)dealloc{
    self.recordName = nil;
    self.recordBH = nil;
    self.serviceName = nil;
    [super dealloc];
}
@end
