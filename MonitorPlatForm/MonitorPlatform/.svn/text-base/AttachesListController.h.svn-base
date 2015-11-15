//
//  AttachesListController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-5.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReturnSelectedRowDelegate <NSObject>

- (void)returnSelectedRow:(NSInteger)row;

@end

@interface AttachesListController : UITableViewController
@property (nonatomic,strong) NSArray *attachesList;
@property (nonatomic,assign) id<ReturnSelectedRowDelegate> delegate;
@end
