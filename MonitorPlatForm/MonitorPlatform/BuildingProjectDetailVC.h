//
//  BuildingProjectDetailVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MBProgressHUD.h"

@interface BuildingProjectDetailVC : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    IBOutlet UIWebView *myWeb;
    IBOutlet UITableView *myTable;
    NSMutableArray *zfxxList;
    NSMutableArray *sfxxList;
}

@property (nonatomic,strong) NSDictionary *dataDic;
@property (nonatomic,strong) NSArray * listAry;
@property (nonatomic,copy) NSString *sbdjbh;
@property (nonatomic, copy) NSString *wrybh;

@property(nonatomic,strong) ASINetworkQueue * networkQueue;
@property (nonatomic,strong) MBProgressHUD *hud;
@end
