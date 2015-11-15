//
//  WryOnlineMonitorConroller.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 污染源在线监测排放数据

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WebServiceHelper.h"
#import "OCPSelectedController.h"
#import "ChooseTimeRangeVC.h"
#import "S7GraphView.h"

@interface WryOnlineMonitorConroller : UIViewController
<NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,ChooseTimeRangeDelegate,S7GraphViewDataSource>

@property (nonatomic,retain) UITableView *dataTableView;
@property (nonatomic,retain) UIWebView *resultWebView;
@property (nonatomic,retain) IBOutlet UIImageView *imgView;
@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic,copy) NSString *endDateStr;
@property (nonatomic,copy) NSString *unit;
@property (nonatomic,copy) NSString *itemName;
@property (nonatomic,strong) S7GraphView *graphView;
@property (nonatomic,strong) NSMutableArray *valueAry;
@property (nonatomic,strong) NSMutableArray *timeAry;

@property (nonatomic,strong) NSMutableDictionary *resultDataDic;
@property (nonatomic,strong) NSArray *resultDataAry;
@property (nonatomic,strong) NSMutableString *html;
@property (nonatomic, strong) NSMutableString *curParsedData;
@property (nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) UIButton *btnTitleView;
@property (nonatomic,copy) NSString *wrybh;//污染源编号
@property (nonatomic,copy) NSString *wrymc;//污染源名称
@property (nonatomic,assign) NSInteger nRequestDataType;

@property (nonatomic,strong) WebServiceHelper *webHelper;

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseTimeRangeVC *dateController;

@property (nonatomic,assign) BOOL bWarn;

-(void)requestData;
@end
