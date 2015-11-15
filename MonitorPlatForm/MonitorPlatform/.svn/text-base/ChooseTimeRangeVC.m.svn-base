//
//  ChooseTimeRangeVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-9-27.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ChooseTimeRangeVC.h"

@interface ChooseTimeRangeVC ()

@end

@implementation ChooseTimeRangeVC
@synthesize delegate,theDP,s_TP,e_TP;

#pragma mark - Private methods

- (void)makeSureTheRange:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateStr = [dateFormatter stringFromDate:theDP.date];
    [dateFormatter release];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSString *s_time = [timeFormatter stringFromDate:s_TP.date];
    NSString *e_time = [timeFormatter stringFromDate:e_TP.date];
    [timeFormatter release];
    
    NSString *from = [NSString stringWithFormat:@"%@ %@",dateStr,s_time];
    NSString *end = [NSString stringWithFormat:@"%@ %@",dateStr,e_time];
    
    [delegate choosedFromTime:from andEndTime:end];
    
}

- (void)cancelTheRange:(id)sender
{
    [delegate cancelSelectTimeRange];
}

#pragma mark - View life cycle

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contentSizeForViewInPopover = CGSizeMake(426.0, 570.0);
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BGPortrait.png"]];
    background.frame = CGRectMake(0, 0, 426, 570.0);
    [self.view addSubview:background];
    [background release];
    
    UILabel *yearLbl = [[UILabel alloc] initWithFrame:CGRectMake(159, 11, 108, 31)];
    [yearLbl setBackgroundColor:[UIColor clearColor]];
    [yearLbl setTextColor:CELL_HEADER_COLOR];
    yearLbl.font = [UIFont boldSystemFontOfSize:20];
    yearLbl.textAlignment = UITextAlignmentCenter;
    yearLbl.text = @"查询日期";
    [self.view addSubview:yearLbl];
    [yearLbl release];
    
    UILabel *startMonthLbl = [[UILabel alloc] initWithFrame:CGRectMake(60, 284, 108, 31)];
    [startMonthLbl setBackgroundColor:[UIColor clearColor]];
    [startMonthLbl setTextColor:CELL_HEADER_COLOR];
    startMonthLbl.font = [UIFont boldSystemFontOfSize:20];
    startMonthLbl.textAlignment = UITextAlignmentCenter;
    startMonthLbl.text = @"开始时间";
    [self.view addSubview:startMonthLbl];
    [startMonthLbl release];
    
    UILabel *endMonthLbl = [[UILabel alloc] initWithFrame:CGRectMake(255, 284, 108, 31)];
    [endMonthLbl setBackgroundColor:[UIColor clearColor]];
    [endMonthLbl setTextColor:CELL_HEADER_COLOR];
    endMonthLbl.font = [UIFont boldSystemFontOfSize:20];
    endMonthLbl.textAlignment = UITextAlignmentCenter;
    endMonthLbl.text = @"结束时间";
    [self.view addSubview:endMonthLbl];
    [endMonthLbl release];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(20, 49, 386, 216)];
    datePicker.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:datePicker];
    self.theDP = datePicker;
    [datePicker release];
    
    UIDatePicker *timePicker1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(18, 329, 193, 216)];
    timePicker1.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:timePicker1];
    self.s_TP = timePicker1;
    [timePicker1 release];
    
    UIDatePicker *timePicker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(213, 329, 193, 216)];
    timePicker2.datePickerMode = UIDatePickerModeTime;
    [self.view addSubview:timePicker2];
    self.e_TP = timePicker2;
    [timePicker2 release];
    
	//导航栏按钮设置
    UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelTheRange:)];
    self.navigationItem.leftBarButtonItem = aButtonItem;
	[aButtonItem release];
    
	UIBarButtonItem *aButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered target:self action:@selector(makeSureTheRange:)];
    
    self.navigationItem.rightBarButtonItem = aButtonItem2;
	[aButtonItem2 release];
    
    //选取器默认值设置
    theDP.date = [NSDate date];
    
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
    [timeFormatter setDateFormat:@"HH:mm"];
    s_TP.date = [timeFormatter dateFromString:@"00:00"];
    e_TP.date = [timeFormatter dateFromString:@"23:59"];
    [timeFormatter release];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
