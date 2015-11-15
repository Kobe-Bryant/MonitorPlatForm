//
//  STSViewController.h
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 三同时统计

#import <UIKit/UIKit.h>
#import "ShowStaticsGraphVC.h"
#import "NSURLConnHelper.h"

@interface STSViewController : ShowStaticsGraphVC
<NSURLConnectionDelegate>
@end
