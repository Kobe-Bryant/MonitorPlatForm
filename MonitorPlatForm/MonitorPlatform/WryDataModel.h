//
//  WryDataModel.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLConnHelperDelegate.h"
#import "WebServiceHelper.h"

@interface WryDataModel : NSObject{
    NSString* wrybh;//污染源编号 440301200600568
    NSMutableString *curParsedData;
    BOOL isGotJsonString;
    
    UITableView *displayTableView;
    UIViewController *parentController;
    BOOL isDataRequested;
}

@property(nonatomic,strong)NSString* wrybh;//污染源编号 440301200600568
@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) WebServiceHelper *webHelper;

@property(nonatomic,strong)UITableView *displayTableView;
@property(nonatomic,strong)UIViewController *parentController;
@property(nonatomic,assign)BOOL isDataRequested;

-(id)initWithWryBH:(NSString*)bh parentController:(UIViewController*)controller andTableView:(UITableView*)tableView;

-(void)requestData;
@end
