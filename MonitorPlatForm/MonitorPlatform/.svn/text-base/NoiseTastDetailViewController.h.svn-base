//
//  NoiseTastDetailViewController.h
//  MonitorPlatform
//
//  Created by ihumor on 13-2-28.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MBProgressHUD.h"
#import "NSURLConnHelper.h"

@interface NoiseTastDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate>

@property (retain, nonatomic) IBOutlet UITableView *tetailTable;
@property (copy, nonatomic) NSString *yhid;
@property (copy, nonatomic) NSString *bwbhnew;
@property (copy, nonatomic) NSString *ywxtbh;
@property (copy, nonatomic) NSString *lclxbh;
@property (copy, nonatomic) NSString *SFZB;
@property (copy, nonatomic) NSString *BZDYBH;
@property (copy, nonatomic) NSString *BZBH;
@property (nonatomic) BOOL hasDone;
@property(nonatomic,strong) ASINetworkQueue * networkQueue;
@property (nonatomic,strong) MBProgressHUD *hud;
@property (nonatomic,strong) NSDictionary *baseInfoDic;

@end
