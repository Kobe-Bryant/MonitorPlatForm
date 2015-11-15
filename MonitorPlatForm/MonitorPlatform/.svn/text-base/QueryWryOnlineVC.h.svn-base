//
//  QueryWryOnlineVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-8-30.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WebServiceHelper.h"
#import "NSURLConnHelperDelegate.h"
#import "CommenWordsViewController.h"
#import "PopupDateViewController.h"

@interface QueryWryOnlineVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WordsDelegate,NSXMLParserDelegate,NSURLConnHelperDelegate,PopupDateDelegate>
{
    IBOutlet UITextField *wryNameFie;
    IBOutlet UITextField *xzqhFie;
    IBOutlet UITextField *qsrqFie;//开始日期
    IBOutlet UITextField *jsrqFie;//结束日期
    IBOutlet UIButton *searchBtn;
    IBOutlet UITableView *resultTable;
}

@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;

@property (nonatomic,strong) UIPopoverController *datePopover;
@property (nonatomic,strong) PopupDateViewController *dateSelectCtrl;

@property (nonatomic,assign) int currentTag;

@property (nonatomic,assign) BOOL isGotJsonString;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSMutableArray *webResultAry;

- (IBAction)searchBtnPressed:(id)sender;

@end
