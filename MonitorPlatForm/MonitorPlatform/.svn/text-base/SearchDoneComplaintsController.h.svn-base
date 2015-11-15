//
//  SearchDoneComplaintsController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"

@interface SearchDoneComplaintsController : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,PopupDateDelegate>

@property (nonatomic,strong) IBOutlet UITableView *listTable;
@property (nonatomic,strong) IBOutlet UILabel *taskInfoLabel;
@property (nonatomic,strong) IBOutlet UILabel *completedTypeLabel;
@property (nonatomic,strong) IBOutlet UILabel *startDateLbl;
@property (nonatomic,strong) IBOutlet UILabel *endDateLbl;

@property (nonatomic,strong) IBOutlet UITextField *taskInfoField;
@property (nonatomic,strong) IBOutlet UITextField *startDateTfd;
@property (nonatomic,strong) IBOutlet UITextField *endDateTfd;
@property (nonatomic,strong) IBOutlet UISegmentedControl *completedTypeSeg;
@property (nonatomic,strong) IBOutlet UIButton *searchBtn;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;

@property (nonatomic,strong) NSURLConnHelper *webservice;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int totalPages;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,assign) BOOL isScroll;

@property (nonatomic,copy) NSString *completedType;
@property (nonatomic,strong) NSMutableArray *doneDataAry;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;

@property (nonatomic,assign) int nDataType;
@property (nonatomic,assign) int listType;

@property (nonatomic,assign) int totalDataCount;

- (IBAction)searchBtnPressed:(id)sender;

@end
