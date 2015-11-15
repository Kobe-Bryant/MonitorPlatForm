//
//  GFTypeStatisticController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseDateRangeController.h"
#import "NSURLConnHelperDelegate.h"
@class WebServiceHelper;

@interface GFTypeStatisticController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,NSXMLParserDelegate,ChooseDateRangeDelegate>

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
@property (nonatomic, assign) int nEntrance;
@property (nonatomic,copy) NSString *dwmc;
@property (nonatomic,copy) NSString *jszbh;
@property (nonatomic,copy) NSString *currentMethod;


@property (nonatomic,strong) NSArray *widthAry;
@end
