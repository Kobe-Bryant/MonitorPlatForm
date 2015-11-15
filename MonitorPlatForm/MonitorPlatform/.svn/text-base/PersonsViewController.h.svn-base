//
//  PersonsViewController.h
//  MonitorPlatform
//
//  Created by zhang on 12-9-5.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
//在地图重显示这个人的位置
@protocol PersonPositonDelegate
-(void)showPosition:(NSDictionary*)info;
@end

@interface PersonsViewController : UITableViewController
@property(nonatomic,retain)NSArray *aryPersons;
@property(nonatomic,assign)id<PersonPositonDelegate> delegate;
@end
