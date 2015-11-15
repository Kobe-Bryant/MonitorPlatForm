//
//  ZFTZChartViewController.h
//  MonitorPlatform
//
//  Created by PowerData on 14-4-21.
//  Copyright (c) 2014年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZFTZChartViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) NSDictionary *dataDic;
@property (copy, nonatomic) NSString *wrybm;
@property (assign) BOOL isExplain;
@end
