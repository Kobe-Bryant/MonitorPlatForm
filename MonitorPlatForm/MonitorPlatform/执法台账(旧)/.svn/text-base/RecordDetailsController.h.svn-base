//
//  RecordDetailsController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-13.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "CommenWordsViewController.h"

@interface RecordDetailsController : UIViewController <WordsDelegate>
{
    IBOutlet UIWebView *myWebView;
}

@property (nonatomic,strong) NSDictionary *dataDic;

@property (nonatomic,strong) NSMutableArray *childTableAry;

@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;

@property (nonatomic,assign) CGRect childViewRect; 
@end
