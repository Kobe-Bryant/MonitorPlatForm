//
//  SolidLinkageDataModel.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-27.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "WryDataModel.h"

@interface SolidLinkageDataModel : WryDataModel <NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray *infoArray;

@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic,copy) NSString *endDateStr;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;
@property (nonatomic,strong) UIViewController *detailController;
@property (nonatomic,strong) UIImageView *scrollImage;

-(id)initWithWryBH:(NSString*)bh 
  parentController:(UIViewController*)controller 
      andTableView:(UITableView*)tableView
      andImageView:(UIImageView *)img;
-(void)hideDetailController:(BOOL)animated;
@end
