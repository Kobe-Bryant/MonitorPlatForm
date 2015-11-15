//
//  HandlePassViewController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "QQSectionHeaderView.h"
#import "CommenWordsViewController.h"
#import "UsualOpinionVC.h"

@interface HandlePassViewController : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,QQSectionHeaderViewDelegate,WordsDelegate,UITextViewDelegate,UsualOpinionDelegate>

@property (nonatomic,strong) IBOutlet UITableView *processTable;
@property (nonatomic,strong) IBOutlet UIButton *usualOpinionBtn;
@property (nonatomic,strong) IBOutlet UILabel *noticeLabel;
@property (nonatomic,strong) IBOutlet UITextView *opinionText;
@property (nonatomic,strong) IBOutlet UITextField *signature;
@property (nonatomic,strong) IBOutlet UIButton *saveForUsual;
@property (nonatomic,strong) IBOutlet UIButton *rewrite;
@property (nonatomic,strong) IBOutlet UIButton *pass;
@property (nonatomic,strong) IBOutlet UIButton *jyyBtn;
@property (nonatomic,strong) IBOutlet UIButton *ljcBtn;
@property (nonatomic,strong) IBOutlet UIImageView *backgroundView;

@property (nonatomic,copy) NSString *letterVisitNum;
@property (nonatomic,strong) NSMutableArray *allInfo;
@property (nonatomic,strong) NSMutableArray *qqListAry;
@property (nonatomic,strong) NSMutableArray *peopleSelected;

@property (nonatomic,assign) int nAlertStatus;
@property (nonatomic,assign) int nParseStatus;
@property (nonatomic,assign) int nLinker;
@property (nonatomic,assign) int nDataType;

@property (nonatomic,strong) NSURLConnHelper *webservice;

@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;

@property (nonatomic, retain) UIPopoverController *opinionPopover;
@property (nonatomic, retain) UsualOpinionVC *opinionSelectVC;

@property (nonatomic,assign) BOOL isChangeUser;
@property (nonatomic,copy) NSString *changeUserID;

- (IBAction)saveForUsualPressed:(id)sender;
- (IBAction)rewritePressed:(id)sender;
- (IBAction)passPressed:(id)sender;
- (IBAction)usualOpinionPressed:(id)sender;
- (IBAction)shortcutButtonPressed:(id)sender;

@end
