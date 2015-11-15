//
//  TaskCountDataModel.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataModel.h"
#import "MBProgressHUD.h"

@protocol ZTQKDelegate <NSObject>

- (void)returnRequestType:(NSDictionary *)dic;

@end

@interface TaskCountZTQKDataModel : TaskDataModel<NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,retain) MBProgressHUD *HUD;
@property (nonatomic,assign) id<ZTQKDelegate> delegate;
@property (nonatomic,assign) int requetStatus;
@property (nonatomic,strong) NSMutableArray *allDataAry;
@property (nonatomic,copy) NSString *fromDate;
@property (nonatomic,copy) NSString *endDate;
@property (nonatomic,copy) NSString *deptID;
-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID;
@end
