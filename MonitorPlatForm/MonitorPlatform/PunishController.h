//
//  PunishController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-23.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

@interface PunishController : UITableViewController <UIAlertViewDelegate,NSURLConnHelperDelegate>

@property (nonatomic,strong) NSArray *punishArray;//待办
@property (nonatomic,assign) int nDataType;
@property (nonatomic,strong) NSURLConnHelper *webservice;

@end
