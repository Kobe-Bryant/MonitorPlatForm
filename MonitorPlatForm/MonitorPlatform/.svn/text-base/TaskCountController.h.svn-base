//
//  TaskCountController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-5.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseDateRangeController.h"
#import "TaskCountZTQKDataModel.h"
#import "TaskCountDataModel.h"
#import "TaskCountPWSFDataModel.h"
#import "TaskChildYJDataModel.h"
#import "TaskCountXFTSDataModel.h"
#import "TaskCountXZCFDataModel.h"
#import "TaskCountZSXKDataModel.h"
#import "CommenWordsViewController.h"
#define DataType_TaskCountZTQK 10
#define DataType_TaskCountHJXF 0
#define DataType_TaskCountZSXK 1
#define DataType_TaskCountXZCF 2
#define DataType_TaskCount     3
#define DataType_TaskCountPWSF 4
#define DataType_TaskChildYJ   5

@interface TaskCountController : UIViewController<ChooseDateRangeDelegate,ZTQKDelegate,WordsDelegate>
{
    BOOL isLoading;
}

@property (nonatomic,retain) IBOutlet UITableView *dataTableView;
@property (nonatomic,retain) IBOutlet UITableView *childTableView;

@property (nonatomic,assign) NSInteger requestDataType;
@property (nonatomic,assign) BOOL bSelViewRotated;
@property (nonatomic,retain) TaskCountDataModel *taskCountModel;//现场执法任务统计
@property (nonatomic,retain) TaskCountPWSFDataModel *taskCountPWSFModel;//排污收费
@property (nonatomic,retain) TaskChildYJDataModel *taskChildYJModel;//预警
@property (nonatomic,retain) TaskCountXFTSDataModel *taskHJXFModel;//环境信访
@property (nonatomic,retain) TaskCountZSXKDataModel *taskZSXKModel;//噪声许可
@property (nonatomic,retain) TaskCountXZCFDataModel *taskXZCFModel;//行政处罚
@property (nonatomic,retain) TaskCountZTQKDataModel *taskCountZTQKModel;//总体情况

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;

@property (nonatomic,retain) NSString *fromDateStr;
@property (nonatomic,retain) NSString *endDateStr;
@property (nonatomic,retain)  UIBarButtonItem *chooseDeptBar;
@property (nonatomic,retain) NSString *departID;

@end
