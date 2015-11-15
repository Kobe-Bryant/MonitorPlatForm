//
//  PWSFViewController.h
//  MonitorPlatform
//
//  Created by ihumor on 13-2-25.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "ChooseDateRangeController.h"

#define TYPEPWSF1  50      //排污收费统计
#define TYPEXFTS    51      //信访统计
#define TYPEXZCF1  52      //行政处罚统计

#define TYPEHEAD 100
#define TYPEDETAIL 101
#define GETHEADER  102
#define GETDETAIL  103
@interface PWSFViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,ChooseDateRangeDelegate>{

    BOOL isZJQKTJ;//用于标记当前是否是收费情况统计
    UISegmentedControl *typeSeg;
    int curRequestType;
}

@property (nonatomic) int statisticType;//统计类型
@property (nonatomic, copy) NSString *fromDateStr;
@property (nonatomic, copy) NSString *endDateStr;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property (nonatomic, retain) NSArray *headerArr;
@property (retain, nonatomic) NSArray *detailArr;
@property (retain, nonatomic) IBOutlet UITableView *detailTable;
@property (retain, nonatomic) IBOutlet UITableView *headTable;
@property (nonatomic,strong) NSURLConnHelper *webservice;
@end
