//
//  WryDataModel.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WryDataModel.h"

@implementation WryDataModel
@synthesize wrybh,curParsedData,isGotJsonString,webHelper;
@synthesize displayTableView,isDataRequested,parentController;

-(id)initWithWryBH:(NSString*)bh 
  parentController:(UIViewController*)controller 
      andTableView:(UITableView*)tableView{
    
    self = [super init];
    if (self)
    {
        self.wrybh = bh;
        self.displayTableView = tableView;
        self.parentController = controller;
        isDataRequested = NO;
    }
    return self;
}

-(void)requestData{
    
}

- (void)dealloc
{
    [wrybh release];
    [curParsedData release];
    [displayTableView release];
    [parentController release];
    [super dealloc];
}
@end
