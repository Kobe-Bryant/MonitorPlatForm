//
//  SearchLinkageController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-17.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "WebServiceHelper.h"
#import "PopupDateViewController.h"
#import "GufeiDetailInfoController.h"

@interface SearchLinkageController : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,PopupDateDelegate,UINavigationControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *resultTable;
@property (nonatomic,strong) IBOutlet UILabel *linkageInfoLbl;
@property (nonatomic,strong) IBOutlet UILabel *startTimeLbl;
@property (nonatomic,strong) IBOutlet UILabel *endTimeLbl;
@property (nonatomic,strong) IBOutlet UILabel *ldhLbl;
@property (nonatomic,strong) IBOutlet UITextField *ldhTfd;
@property (nonatomic,strong) IBOutlet UITextField *linkageInfoTfd;
@property (nonatomic,strong) IBOutlet UITextField *startTimeTfd;
@property (nonatomic,strong) IBOutlet UITextField *endTimeTfd;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;

@property (nonatomic,strong) NSMutableArray *infoAry;
@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,assign) BOOL bLandScape;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic,assign) BOOL bDetailShow;
@property (nonatomic,strong) NSDictionary *currentDic;

@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,copy) NSString *defaultStartTime;
@property (nonatomic,copy) NSString *defaultEndTime;
@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,strong) UIViewController *detailController;

- (IBAction)searchBtnPressed:(id)sender;

@end
