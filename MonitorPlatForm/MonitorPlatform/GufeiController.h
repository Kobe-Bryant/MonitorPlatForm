//
//  GufeiController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PollutionSelectedController.h"
#import "ChooseDateRangeController.h"
#import "NSURLConnHelperDelegate.h"
#import "GufeiDetailInfoController.h"

@class WebServiceHelper;

@interface GufeiController : UIViewController<NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UIAlertViewDelegate,ChooseDateRangeDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>
    
@property (nonatomic,strong) IBOutlet UITableView *resultTableView;
@property (nonatomic,strong) IBOutlet UIToolbar *myToolbar;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *gfld;
@property (nonatomic,strong) IBOutlet UIBarButtonItem *zyba;

@property (nonatomic,strong) UIButton *btnTitleView;

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property (nonatomic, assign) int curretTag;

@property (nonatomic,copy) NSString *wrybh;
@property (nonatomic,copy) NSString *wryjc;
@property (nonatomic,strong) NSMutableArray *infoArray;

@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic,copy) NSString *endDateStr;

@property (nonatomic,assign) int nParserStatus;
@property (nonatomic,assign) BOOL isGotJsonString;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,copy) NSString *currentMethod;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) UIViewController *detailController;

- (void)getWebData;

@end
