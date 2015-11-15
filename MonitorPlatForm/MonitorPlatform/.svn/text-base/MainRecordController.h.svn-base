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
#import "NSURLConnHelper.h"
#import "CommenWordsViewController.h"

@interface MainRecordController : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,WordsDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *recordTable;
@property (nonatomic,strong) IBOutlet UILabel *wrymcLab;
@property (nonatomic,strong) IBOutlet UILabel *zfryLab;
@property (nonatomic,strong) IBOutlet UILabel *qsrqLab;
@property (nonatomic,strong) IBOutlet UILabel *jzrqLab;
@property (nonatomic,strong) IBOutlet UITextField *dwmcFie;
@property (nonatomic,strong) IBOutlet UITextField *dwdzFie;
@property (nonatomic,strong) IBOutlet UITextField *dwlxFie;
@property (nonatomic,strong) IBOutlet UITextField *jgjbFie;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;

@property (nonatomic,strong) NSArray *webResultAry;
@property (nonatomic,strong) NSMutableArray *infoAry;
@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSURLConnHelper *webHelper;

@property (nonatomic,copy) NSString *defaultStartTime;
@property (nonatomic,copy) NSString *defaultEndTime;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;
@property (nonatomic,assign) int selectedDWLX;
@property (nonatomic,assign) int selectedJGJB;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) int totalCount;

- (IBAction)searchBtnPressed:(id)sender;

@end
