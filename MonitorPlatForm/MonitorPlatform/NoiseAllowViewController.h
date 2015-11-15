//
//  NoiseAllowViewController.h
//  MonitorPlatform
//
//  Created by ihumor on 13-2-28.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

@interface NoiseAllowViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,NSURLConnHelperDelegate,UIScrollViewDelegate>
@property (retain, nonatomic) IBOutlet UIImageView *scrollImage;

@property (retain, nonatomic) IBOutlet UITableView *listTable;
@property (nonatomic) BOOL hasDone;
@end
