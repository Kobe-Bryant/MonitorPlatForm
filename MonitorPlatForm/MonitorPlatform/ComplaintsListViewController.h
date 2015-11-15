//
//  ComplaintsListViewController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-13.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

@interface ComplaintsListViewController : UIViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,strong) IBOutlet UITableView *listTable;

@property (nonatomic,strong) NSArray *resultAry;

@property (nonatomic,strong) NSURLConnHelper *webservice;

@property (nonatomic,assign) int nDataType;

@end
