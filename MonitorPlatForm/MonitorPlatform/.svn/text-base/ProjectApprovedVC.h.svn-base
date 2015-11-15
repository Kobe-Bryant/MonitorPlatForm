//
//  ProjectApprovedVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-8-28.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "PopupDateViewController.h"
#import "WebServiceHelper.h"

@interface ProjectApprovedVC : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,PopupDateDelegate,UIScrollViewDelegate>
{
    IBOutlet UITableView *resultTable;
    IBOutlet UITextField *projectName;
    IBOutlet UITextField *approver;
    IBOutlet UITextField *startDate;
    IBOutlet UITextField *endDate;
    IBOutlet UIImageView *scrollImage;
}

@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSArray *webResultAry;
@property (nonatomic,strong) NSMutableArray *infoAry;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;
@property (nonatomic,assign) int currentTag;

- (IBAction)searchBtnPressed:(id)sender;

@end
