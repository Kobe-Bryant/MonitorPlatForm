//
//  ZfrwDataModel.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WryDataModel.h"
#import "QQSectionHeaderView.h"
@interface ZfrwDataModel : WryDataModel <NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,QQSectionHeaderViewDelegate>

@property (nonatomic,strong) NSArray *webResultAry;
@property (nonatomic,strong) NSMutableArray *infoAry;
@property (nonatomic,strong) NSMutableArray *mutableInfoAry;

@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,assign) int currentPage;
@property (nonatomic,assign) BOOL isScroll;
@property (nonatomic,assign) BOOL isEnd;

@property (nonatomic,strong) UIImageView *scrollImage;

@property (nonatomic,strong) NSArray *titleAry1;
@property (nonatomic,strong) NSArray *titleAry2;



-(id)initWithWryBH:(NSString*)bh 
  parentController:(UIViewController*)controller 
      andTableView:(UITableView*)tableView
      andImageView:(UIImageView *)img;

@end
