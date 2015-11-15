//
//  ProcesserInfoItem.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ProcesserInfoItem.h"

@implementation ProcesserInfoItem
@synthesize stepID,stepDesc,nextProcesser;
@synthesize processers,nextProcesserID,stepDept;
@synthesize canSplit,currentProcesser;

- (ProcesserInfoItem *)init {
    self = [super init];
    if (self) {
        stepDept = @"";
        stepID = @"";
        stepDesc = @"";
        nextProcesser = @"";
        nextProcesserID = @"";
        processers = [[NSMutableArray alloc] init];
        currentProcesser = @"";
        canSplit = NO;
    }
    return self;
}
@end
