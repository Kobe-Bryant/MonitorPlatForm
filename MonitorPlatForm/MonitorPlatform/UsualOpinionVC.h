//
//  UsualOpinionVC.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-8-20.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UsualOpinionDelegate <NSObject>

- (void)returnSelectedOpinion:(NSString *)words;
- (void)refreshUsualOpinions:(NSArray *)opinionsAry;

@end

@interface UsualOpinionVC : UITableViewController

@property (nonatomic,strong) NSMutableArray *wordsAry;
@property (nonatomic,assign) id<UsualOpinionDelegate>delegate;

@end
