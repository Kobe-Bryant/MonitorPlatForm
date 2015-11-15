//
//  PwsfDetailDataModel.h
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataModel.h"

@interface PwsfDetailDataModel : TaskDataModel<NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,copy) NSString *type;

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end;

@end
