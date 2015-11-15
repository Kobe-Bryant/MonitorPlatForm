//
//  JSSGStaticsViewController.h
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 建设施工统计

#import <UIKit/UIKit.h>
#import "ShowStaticsGraphVC.h"
#import "NSURLConnHelper.h"
#import "ChooseDateRangeController.h"


@interface JSSGStaticsViewController : ShowStaticsGraphVC <NSURLConnectionDelegate,ChooseDateRangeDelegate>

@end
