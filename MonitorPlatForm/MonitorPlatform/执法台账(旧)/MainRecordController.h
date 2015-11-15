//
//  MainRecordController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "PopupDateViewController.h"
#import "WebServiceHelper.h"

@interface MainRecordController : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,PopupDateDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *recordTable;
@property (nonatomic,strong) IBOutlet UILabel *wrymcLab;
@property (nonatomic,strong) IBOutlet UILabel *zfryLab;
@property (nonatomic,strong) IBOutlet UILabel *qsrqLab;
@property (nonatomic,strong) IBOutlet UILabel *jzrqLab;
@property (nonatomic,strong) IBOutlet UITextField *wrymcFie;
@property (nonatomic,strong) IBOutlet UITextField *zfryFie;
@property (nonatomic,strong) IBOutlet UITextField *qsrqFie;
@property (nonatomic,strong) IBOutlet UITextField *jzrqFie;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;

@property (nonatomic,strong) NSArray *webResultAry;
@property (nonatomic,strong) NSMutableArray *infoAry;
@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;

@property (nonatomic,copy) NSString *defaultStartTime;
@property (nonatomic,copy) NSString *defaultEndTime;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,assign) int currentTag;

- (IBAction)searchBtnPressed:(id)sender;

@end
