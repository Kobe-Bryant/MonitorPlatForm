//
//  HaveDoneOAController.h
//  ShenChaOA
//
//  Created by 王 哲义 on 12-5-13.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoOAItem.h"
#import "NSURLConnHelperDelegate.h"
#import "PopupDateViewController.h"
@class WebServiceHelper;

@interface HaveDoneOAController : UIViewController <UIScrollViewDelegate,NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource,PopupDateDelegate> {
	
	NSMutableArray *aryItems;	
	NSMutableString *curParsedData;
    ToDoOAItem *tmpTodoItem;
    
	int currentPageIndex;	
	BOOL isLoading;	
	int totalPage;//所有页数
	int totalRow; //所有条目
	int nParserStatus;
	BOOL bUpdateFlag;
    
    UIImageView *emptyView;
}


@property (nonatomic, retain) NSMutableArray *aryItems;
@property (nonatomic, retain) NSMutableString *curParsedData;
@property (nonatomic, strong) WebServiceHelper *webHelper;

@property (nonatomic, strong) IBOutlet UILabel *titleLbl;
@property (nonatomic, strong) IBOutlet UILabel *sendDateLbl;
@property (nonatomic, strong) IBOutlet UITextField *titleFie;
@property (nonatomic, strong) IBOutlet UITextField *sendDateFie;
@property (nonatomic, strong) IBOutlet UITableView *resultTable;
@property (nonatomic, strong) IBOutlet UIButton *searchBtn;
@property (nonatomic, strong) IBOutlet UILabel *psLabel;

@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *popController;

- (void)getInitialItemsList;
- (void)getYiBan;
- (IBAction)searchButtonPressed:(id)sender;
@end
