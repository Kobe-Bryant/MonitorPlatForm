//
//  OneDayTrailCountController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "PopupDateViewController.h"
@class WebServiceHelper;

@interface OneDayTrailCountController : UIViewController<NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,PopupDateDelegate>

@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property(nonatomic,strong)NSArray *resultDataAry;
@property(nonatomic,strong)IBOutlet UITableView *resultTableView;
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) PopupDateViewController *dateController;
@property (nonatomic,strong) NSString *selDateStr;
@property (nonatomic,strong) WebServiceHelper *webHelper;
-(void)requestDataWithDate;
@end
