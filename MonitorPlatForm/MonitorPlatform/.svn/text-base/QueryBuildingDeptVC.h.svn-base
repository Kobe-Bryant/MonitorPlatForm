//
//  QueryBuildingDeptVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "CommenWordsViewController.h"

@interface QueryBuildingDeptVC : UIViewController <NSURLConnHelperDelegate,WordsDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
{
    IBOutlet UITextField *gxgsFie;
    IBOutlet UITextField *dwxxFie;
    IBOutlet UIButton *searchBtn;
    IBOutlet UITableView *listTable;
    IBOutlet UIImageView *scrollImage;
}

@property (nonatomic,strong) NSMutableArray *resultAry;
@property (nonatomic,strong) NSArray *dmzAry;
@property (nonatomic,copy) NSString *gxgsValue;
@property (nonatomic,strong) NSURLConnHelper *webservice;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) int totalPages;
@property (nonatomic,assign) BOOL isScroll;

@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;

- (IBAction)searchBtnPressed:(id)sender;

@end
