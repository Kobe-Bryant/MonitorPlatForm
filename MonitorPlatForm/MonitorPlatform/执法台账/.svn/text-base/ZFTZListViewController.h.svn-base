//
//  ZFTZListViewController.h
//  MonitorPlatform
//
//  Created by PowerData on 14-4-17.
//  Copyright (c) 2014年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "CommenWordsViewController.h"
#import "WebServiceHelper.h"
#import "NSURLConnHelper.h"

@interface ZFTZListViewController : UIViewController<NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UIScrollViewDelegate,WordsDelegate>
@property (nonatomic,retain) IBOutlet UITableView *recordTable;
@property (nonatomic,retain) IBOutlet UITextField *dwmcFie;
@property (nonatomic,retain) IBOutlet UITextField *dwdzFie;
@property (nonatomic,retain) IBOutlet UITextField *dwlxFie;
@property (nonatomic,retain) IBOutlet UITextField *jgjbFie;
@property (nonatomic,retain) IBOutlet UIButton *searchBtn;
@property (nonatomic,retain) IBOutlet UIImageView *scrollImage;

@property (nonatomic,retain) NSArray *webResultAry;
@property (nonatomic,retain) NSMutableArray *infoAry;
@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,retain) NSMutableString *curParsedData;
@property (nonatomic,retain) NSURLConnHelper *webHelper;

@property (nonatomic,copy) NSString *defaultStartTime;
@property (nonatomic,copy) NSString *defaultEndTime;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,retain) UIPopoverController *wordsPopover;
@property (nonatomic,retain) CommenWordsViewController *wordSelectCtrl;
@property (nonatomic,assign) int currentTag;

- (IBAction)searchBtnPressed:(id)sender;
@end
