//
//  PWSFDetailViewController.h
//  MonitorPlatform
//
//  Created by ihumor on 13-2-26.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

#define TYPEXZQH 100
#define TYPEKS   101
#define TYPEPERSON 102
#define xftsTPYE 103
#define xzcfTPYE 104
#define xzcfPERSON 105

@interface PWSFDetailViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate>

@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic, copy) NSString *endDateStr;
@property (nonatomic,strong) NSURLConnHelper *webservice;
@property (nonatomic, copy) NSString *infoStr;
@property (nonatomic, retain) NSArray *infoArr;
@property (nonatomic) int type;
@property (retain, nonatomic) IBOutlet UITableView *detailTable;

@end
