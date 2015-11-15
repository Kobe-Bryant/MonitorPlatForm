//
//  TaskCountZSXKDataModel.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataModel.h"

@interface TaskCountZSXKDataModel : TaskDataModel <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic,copy) NSString *endDateStr;

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID;

@end
