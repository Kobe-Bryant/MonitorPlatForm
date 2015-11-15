//
//  DoneNoiseAllowVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "PopupDateViewController.h"

@interface DoneNoiseAllowVC : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,PopupDateDelegate>
{
    IBOutlet UITableView *listTable;
    IBOutlet UITextField *taskInfoField;
    IBOutlet UITextField *startDateTfd;
    IBOutlet UITextField *endDateTfd;
    IBOutlet UILabel *completedLbl;
    IBOutlet UISegmentedControl *completedTypeSeg;
    IBOutlet UIButton *searchBtn;
    IBOutlet UIImageView *scrollImage;
}

@property (nonatomic,strong) NSURLConnHelper *webservice;
@property (nonatomic) BOOL isTastDone;
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

- (IBAction)searchBtnPressed:(id)sender;

@end
