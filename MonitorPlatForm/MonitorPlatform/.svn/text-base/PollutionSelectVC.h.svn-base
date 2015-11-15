//
//  PollutionSelectVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-8-24.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CommenWordsViewController.h"

@interface PollutionSelectVC : UIViewController <UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WordsDelegate,UITextFieldDelegate>

{
    IBOutlet UITextField *wryNameFie;
    IBOutlet UITextField *xzqhFie;
    IBOutlet UITextField *hylxFie;
    IBOutlet UITextField *jgjbFie;
    IBOutlet UIButton *searchBtn;
    IBOutlet UITableView *resultTable;
}

@property (nonatomic,strong) NSArray *dataResultAry;
@property (nonatomic,assign) int status;
@property (nonatomic, assign) int enterCode;//来源，如果是12则表示是点击监测报告进入的

@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;
@property (nonatomic,assign) int currentTag;


@end
