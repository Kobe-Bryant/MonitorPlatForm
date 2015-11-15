//
//  SearchDonePunishController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"

@interface SearchDonePunishController : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,PopupDateDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *doneTable;
@property (nonatomic,strong) IBOutlet UILabel *caseInfoLbl;
@property (nonatomic,strong) IBOutlet UILabel *startDateLbl;
@property (nonatomic,strong) IBOutlet UILabel *endDateLbl;
@property (nonatomic,strong) IBOutlet UITextField *caseInfoTfd;
@property (nonatomic,strong) IBOutlet UITextField *startDateTfd;
@property (nonatomic,strong) IBOutlet UITextField *endDateTfd;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;

@property (nonatomic,strong) NSURLConnHelper *webservice;

@property (nonatomic,strong) NSMutableArray *punishArray;//已办
@property (nonatomic,assign) int nDataType;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int totalPages;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isLoading;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;

@property (nonatomic,assign) int listType;
@property (nonatomic,assign) int totalDataCount;

- (IBAction)searchBtnPressed:(id)sender;

@end
