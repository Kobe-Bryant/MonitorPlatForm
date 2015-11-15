//
//  ShowStaticsGraphVC.h
//  StatisticsGraphController
//
//  Created by zhang on 12-9-7.
//  Copyright (c) 2012年 zhang. All rights reserved.
// 所有统计图的基类 分两页 左边一页显示柱状图 右边一页显示表格数据

#import <UIKit/UIKit.h>


@interface ShowStaticsGraphVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic,retain)  UISegmentedControl *segCtrl; //根据showType 来显示具体有几段

//canShowGraph:(BOOL)show show:NO时 不方便画图，所以只用tableview
-(void)addGraphDataType:(NSString*)showType  withGroupName:(NSString*)groupName colValues:(NSDictionary*)dicColValues;
-(void)addTableDataType:(NSString*)showType withColumns:(NSArray*)cols columnWidthPercent:(NSArray*)aryWidth itemValues:(NSArray*)aryValues showImage:(BOOL)bShown;
-(void)showGraphDatas;
-(void)clearAllDataItems; //清除所有的数据项
-(void)doNotShowChartNumCol;//柱状图 不在柱子上画数值

@end
