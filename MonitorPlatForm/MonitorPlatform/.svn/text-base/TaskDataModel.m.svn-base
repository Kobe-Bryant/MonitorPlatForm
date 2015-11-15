//
//  TaskDataModel.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TaskDataModel.h"

@implementation TaskDataModel
@synthesize curParsedData,isGotJsonString,isLoading,webHelper,webservice;
@synthesize displayTableView,isDataRequested,parentController,resultDataAry;

-(id)initWithParentController:(UIViewController*)controller andTableView:(UITableView*)tableView{
    
    self = [super init];
    if (self)
    {
        
        self.displayTableView = tableView;
        self.parentController = controller;
        isDataRequested = NO;
    }
    return self;
}

-(void)requestDataWithFromDate:(NSString*)from andEndDate:(NSString*)end andDepID:(NSString*)depID{

}

- (void)dealloc
{
    [resultDataAry release];
    [curParsedData release];
    [displayTableView release];
    [parentController release];
    [super dealloc];
}
@end
