//
//  PwsfZtqkDataModel.h
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TaskDataModel.h"

@protocol ZTQKDelegate <NSObject>

- (void)returnRequestType:(NSInteger)type;

@end

@interface PwsfZtqkDataModel : TaskDataModel<NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,assign) id<ZTQKDelegate> delegate;
@property (nonatomic,strong) NSArray *resultAry;

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end;

@end
