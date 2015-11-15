//
//  DoneNoiseAllowDetailVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MBProgressHUD.h"

@interface DoneNoiseAllowDetailVC : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIWebView *resultWebView;
    IBOutlet UITableView *listTable;
}

@property (nonatomic,copy) NSString *complaintNum;
@property (nonatomic,strong) NSArray *listAry;

@property(nonatomic,strong) ASINetworkQueue * networkQueue;
@property (nonatomic,strong) MBProgressHUD *hud;

@end
