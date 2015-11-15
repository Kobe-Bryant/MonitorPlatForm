//
//  ChooseDateRangeController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ChooseDateRangeController.h"
#import "NSDateUtil.h"

@implementation ChooseDateRangeController
@synthesize delegate,fromDatePicker,endDatePicker;

// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)init{
	if((self = [super init])){
        
	}
	return self;
}
/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */

//保存按钮触发方法
-(IBAction)saveDate:(id)sender{
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    NSString *from = [formatter stringFromDate:fromDatePicker.date];
    NSString *end = [formatter stringFromDate:endDatePicker.date];
    [formatter release];
    NSDate *fromDate = fromDatePicker.date;
    NSDate *endDate = endDatePicker.date;
    NSDate *compareDate = [fromDate earlierDate:endDate];
    if (![compareDate isEqualToDate:fromDate]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"选择的日期格式错误!请重新选择" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    

    
	[delegate choosedFromDate:from andEndDate:end];
}



-(IBAction)cancelDate:(id)sender{
	
	[delegate cancelSelectDateRange];
}

- (IBAction)btnPressed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    NSString *fromDateStr;
    NSString *endDateStr;
    
    if (btn.tag == 0)
    {
        fromDateStr = [NSDateUtil firstDateThisYear];
        endDateStr = [NSDateUtil stringFromDate:[NSDate date] andTimeFMT:@"yyyy-MM-dd"];
    }
    
    else if (btn.tag == 1)
    {
        fromDateStr = [NSDateUtil firstDateOfFirstSeason];
        endDateStr = [NSDateUtil lastDateOfFirstSeason];
    }
    
    else if (btn.tag == 2)
    {
        fromDateStr = [NSDateUtil firstDateOfSecondSeason];
        endDateStr = [NSDateUtil lastDateOfSecondSeason];
    }
    
    else if (btn.tag == 3)
    {
        fromDateStr = [NSDateUtil firstDateOfThirdSeason];
        endDateStr = [NSDateUtil lastDateOfThirdSeason];
    }    
    else
    {
        fromDateStr = [NSDateUtil firstDateOfForthSeason];
        endDateStr = [NSDateUtil lastDateOfForthSeason];
    }
    
        
    [delegate choosedFromDate:fromDateStr andEndDate:endDateStr];
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	
    [super viewDidLoad];

	self.contentSizeForViewInPopover = CGSizeMake(658, 422);
    
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"BGPortrait.png"]];
    background.frame = CGRectMake(0, 0, 658, 422);
    [self.view addSubview:background];
    [background release];
    
    UILabel *startDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(105, 20, 121, 31)];
    [startDateLbl setBackgroundColor:[UIColor clearColor]];
    [startDateLbl setTextColor:CELL_HEADER_COLOR];
    startDateLbl.font = [UIFont boldSystemFontOfSize:20];
    startDateLbl.textAlignment = UITextAlignmentCenter;
    startDateLbl.text = @"开始日期";
    [self.view addSubview:startDateLbl];
    [startDateLbl release];
    
    UILabel *endDateLbl = [[UILabel alloc] initWithFrame:CGRectMake(428, 20, 121, 31)];
    [endDateLbl setBackgroundColor:[UIColor clearColor]];
    [endDateLbl setTextColor:CELL_HEADER_COLOR];
    endDateLbl.font = [UIFont boldSystemFontOfSize:20];
    endDateLbl.textAlignment = UITextAlignmentCenter;
    endDateLbl.text = @"结束日期";
    [self.view addSubview:endDateLbl];
    [endDateLbl release];
    
    UIDatePicker *picker1 = [[UIDatePicker alloc] initWithFrame:CGRectMake(14, 54, 303, 216)];
    picker1.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:picker1];
    self.fromDatePicker = picker1;
    [picker1 release];
    
    UIDatePicker *picker2 = [[UIDatePicker alloc] initWithFrame:CGRectMake(337, 54, 303, 216)];
    picker2.datePickerMode = UIDatePickerModeDate;
    [self.view addSubview:picker2];
    self.endDatePicker = picker2;
    [picker2 release];
    
    UIButton *yearBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    yearBtn.frame = CGRectMake(40, 351, 576, 44);
    [yearBtn setTitle:@"年初到现在" forState:UIControlStateNormal];
    yearBtn.tag = 0;
    [yearBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:yearBtn];
    
    UIButton *firstSeasonBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    firstSeasonBtn.frame = CGRectMake(40, 289, 121, 44);
    [firstSeasonBtn setTitle:@"第一季度" forState:UIControlStateNormal];
    firstSeasonBtn.tag = 1;
    [firstSeasonBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:firstSeasonBtn];
    
    UIButton *secondSeasonBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    secondSeasonBtn.frame = CGRectMake(169, 289, 121, 44);
    [secondSeasonBtn setTitle:@"第二季度" forState:UIControlStateNormal];
    secondSeasonBtn.tag = 2;
    [secondSeasonBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:secondSeasonBtn];
    
    UIButton *thirdSeasonBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    thirdSeasonBtn.frame = CGRectMake(363, 289, 121, 44);
    [thirdSeasonBtn setTitle:@"第三季度" forState:UIControlStateNormal];
    thirdSeasonBtn.tag = 3;
    [thirdSeasonBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:thirdSeasonBtn];
    
    UIButton *forthSeasonBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    forthSeasonBtn.frame = CGRectMake(492, 289, 121, 44);
    [forthSeasonBtn setTitle:@"第四季度" forState:UIControlStateNormal];
    forthSeasonBtn.tag = 4;
    [forthSeasonBtn addTarget:self action:@selector(btnPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:forthSeasonBtn];
    
	UIBarButtonItem *aButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                    style:UIBarButtonItemStyleBordered target:self action:@selector(cancelDate:)];
    
    self.navigationItem.leftBarButtonItem = aButtonItem;
	[aButtonItem release];
	UIBarButtonItem *aButtonItem2 = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleBordered 
																	target:self action:@selector(saveDate:)];
    
    self.navigationItem.rightBarButtonItem = aButtonItem2;
	[aButtonItem2 release];
	
}

-(void)viewWillAppear:(BOOL)animated{
	[super viewWillAppear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
	[fromDatePicker release];
    [endDatePicker release];
    
    [super dealloc];
}



@end
