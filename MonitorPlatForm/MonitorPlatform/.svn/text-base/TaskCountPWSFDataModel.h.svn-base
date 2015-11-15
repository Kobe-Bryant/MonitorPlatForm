//
//  TaskCountDataModel.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 排污收费

#import <Foundation/Foundation.h>
#import "TaskDataModel.h"
#import "WebServiceHelper.h"

@interface TaskCountPWSFDataModel : TaskDataModel<NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID;
@property (nonatomic,copy) NSString *fromDate;
@property (nonatomic,copy) NSString *endDate;
@end
