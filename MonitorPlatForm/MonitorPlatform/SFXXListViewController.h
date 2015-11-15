//
//  SFXXListViewController.h
//  MonitorPlatform
//
//  Created by apple on 13-6-7.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PwsfDataModel;

@interface SFXXListViewController : UIViewController
{
    PwsfDataModel *pwsf;
    UITableView *resTableView;
}

@property (nonatomic, retain) UIImageView *emptyView;
@property (nonatomic, copy) NSString *wrybh;

@end
