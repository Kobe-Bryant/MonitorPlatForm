//
//  GFTransferCountController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-16.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseDateRangeController.h"
#import "NSURLConnHelperDelegate.h"
@class WebServiceHelper;

@interface GFTransferCountController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,NSXMLParserDelegate,ChooseDateRangeDelegate>

@property (nonatomic,strong) IBOutlet UITableView *dataTableView;

@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,strong) ChooseDateRangeController *dateController;

@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic,copy) NSString* endDateStr;
@property (nonatomic,strong) NSArray *resultDataAry;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic, strong) NSMutableString *curParsedData;

@property (nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic, assign) BOOL bLoaded;
@property (nonatomic,strong) NSArray *widthAry;

@end
