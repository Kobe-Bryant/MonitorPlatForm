//
//  PunishDecideBookVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h> 
#import "NSURLConnHelper.h"  
@interface PunishDecideBookVC : UITableViewController <NSURLConnHelperDelegate>  

@property (nonatomic,strong) NSArray *titleAry; 
@property (nonatomic,strong) NSArray *valueAry; 
@property (nonatomic,strong) NSMutableArray *cellHeightAry;  
@property (nonatomic,strong) NSURLConnHelper *webservice; 
@property (nonatomic,copy) NSString *bwbh;  

@end 
