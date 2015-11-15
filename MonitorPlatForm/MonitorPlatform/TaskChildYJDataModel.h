//
//  TaskChildYJDataModel.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataModel.h"

@interface TaskChildYJDataModel : TaskDataModel <NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSString *fromDate;
@property (nonatomic,strong) NSString *endDate;

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID;

@end
