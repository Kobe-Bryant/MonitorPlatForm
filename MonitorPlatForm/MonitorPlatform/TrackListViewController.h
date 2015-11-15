//
//  TrackListViewController.h
//  MonitorPlatform
//
//  Created by zhang on 12-8-31.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PopupYearMonthViewController.h"
#import "NSURLConnHelperDelegate.h"
#import "WebServiceHelper.h"

@interface TrackListViewController : UIViewController
<PopupYearMonthDelegate,NSURLConnHelperDelegate,NSXMLParserDelegate>
@property(nonatomic,retain) IBOutlet UITableView *listTableView;
@property(nonatomic,retain) IBOutlet UILabel *infoLabel;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) PopupYearMonthViewController *dateController;
@end
