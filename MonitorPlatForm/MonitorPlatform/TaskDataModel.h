//
//  TaskDataModel.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLConnHelper.h"
#import "WebServiceHelper.h"

@interface TaskDataModel : NSObject{

    NSMutableString *curParsedData;
    BOOL isGotJsonString;

    UITableView *displayTableView;
    UIViewController *parentController;
    BOOL isDataRequested;
    BOOL isLoading;
    NSMutableArray *resultDataAry;
}

@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSURLConnHelper *webservice;

@property(nonatomic,strong)UITableView *displayTableView;
@property(nonatomic,strong)UIViewController *parentController;
@property(nonatomic,assign)BOOL isDataRequested;

@property(nonatomic,strong) NSMutableArray *resultDataAry;
@property (nonatomic,assign) BOOL isLoading;
-(id)initWithParentController:(UIViewController*)controller andTableView:(UITableView*)tableView;

//depID 部门ID
-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID;

@end

