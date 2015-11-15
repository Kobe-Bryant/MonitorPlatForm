//
//  AirPM25DetailVC.h
//  PDBaseFrame
//
//  Created by 王哲义 on 13-1-28.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "NSURLConnHelper.h"
#import "PM25GraphView.h"
#import "PopupDateViewController.h"
#import "WebServiceHelper.h"

@interface AirPM25DetailVC : UIViewController <NSURLConnHelperDelegate,S7GraphViewDataSource,PopupDateDelegate>
{
    IBOutlet UITableView *cedianList;
}

@property (nonatomic,retain) UIWebView *resultWebView;

@end
