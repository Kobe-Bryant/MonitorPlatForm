//
//  XkzDetailViewController.h
//  MonitorPlatform
//
//  Created by 王哲义 on 13-10-11.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "WebServiceHelper.h"

@interface XkzDetailViewController : UITableViewController <NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSDictionary *resultDic;
@property (nonatomic,strong) NSMutableArray *sectionTitleAry;
@property (nonatomic,assign) int sectionCount;
@property (nonatomic,assign) BOOL isLoading;

@property (nonatomic,strong) NSArray *titleAry1;
@property (nonatomic,strong) NSArray *titleAry2;
@property (nonatomic,strong) NSArray *valueAry1;
@property (nonatomic,strong) NSArray *valueAry2;

@property (nonatomic,strong) NSArray *titleAry_fs1;
@property (nonatomic,strong) NSArray *titleAry_fs2;
@property (nonatomic,strong) NSArray *valueAry_fs1;
@property (nonatomic,strong) NSArray *valueAry_fs2;

@property (nonatomic,strong) NSArray *titleAry_fq1;
@property (nonatomic,strong) NSArray *titleAry_fq2;
@property (nonatomic,strong) NSArray *valueAry_fq1;
@property (nonatomic,strong) NSArray *valueAry_fq2;

@property (nonatomic,strong) NSArray *titleAry_zs1;
@property (nonatomic,strong) NSArray *titleAry_zs2;
@property (nonatomic,strong) NSArray *valueAry_zs1;
@property (nonatomic,strong) NSArray *valueAry_zs2;

@property (nonatomic,strong) NSArray *titleAry_gf1;
@property (nonatomic,strong) NSArray *titleAry_gf2;
@property (nonatomic,strong) NSArray *valueAry_gf1;
@property (nonatomic,strong) NSArray *valueAry_gf2;

- (id)initWithStyle:(UITableViewStyle)style andBH:(NSString *)xkzBH;

@end
