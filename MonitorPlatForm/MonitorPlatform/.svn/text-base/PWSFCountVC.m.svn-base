//
//  PWSFCountVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PWSFCountVC.h"
#import "NSDateUtil.h"

@interface PWSFCountVC ()
@property (nonatomic,assign) NSInteger requestDataType;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property (nonatomic,retain) NSString *fromDateStr;
@property (nonatomic,retain) NSString *endDateStr;

@property (nonatomic,strong) PwsfZtqkDataModel *ztqkModel;
@property (nonatomic,strong) PwsfDetailDataModel *detailModel;
@end

@implementation PWSFCountVC
@synthesize requestDataType,popController,dateController;
@synthesize fromDateStr,endDateStr,ztqkModel,detailModel;

#pragma mark - Private methods

-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
	//[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)requestData
{
    switch (requestDataType) {
        case DataType_Pay_ZTQK:
            [ztqkModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr];
            [childTableView setHidden:YES];
            break;
        case DataType_Pay_FS:
            detailModel.type = @"FS";
            [detailModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr];
            break;
        case DataType_Pay_FQ:
            detailModel.type = @"FQ";
            [detailModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr];
            break;
                    
        default:
            break;
    }
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    PwsfZtqkDataModel *model1 = [[PwsfZtqkDataModel alloc] initWithParentController:self andTableView:dataTableView];
    model1.delegate = self;
    self.ztqkModel = model1;
    [model1 release];
    
    PwsfDetailDataModel *model2 = [[PwsfDetailDataModel alloc] initWithParentController:self andTableView:childTableView];
    self.detailModel = model2;
    [model2 release];
    
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] autorelease];
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromDateStr = [NSDateUtil firstDateThisYear];
    self.endDateStr = [dateFormatter stringFromDate:nowDate];
    [dateFormatter release];
    self.title = [NSString stringWithFormat:@"按排污类型统计(%@至%@)",fromDateStr,endDateStr];
    // Do any additional setup after loading the view from its nib.
    
    ChooseDateRangeController *date = [[ChooseDateRangeController alloc] init];
	self.dateController = date;
	dateController.delegate = self;
	[date release];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popover release];
	[nav release];
    
    requestDataType = DataType_Pay_ZTQK;
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated{
    if (popController)
        [popController dismissPopoverAnimated:YES];
    
    switch (requestDataType) {
        case DataType_Pay_ZTQK:
            if (ztqkModel.webHelper)
                [ztqkModel.webHelper cancel];
            break;
        case DataType_Pay_FS:
            if (detailModel.webHelper)
                [detailModel.webHelper cancel];
            break;
        case DataType_Pay_FQ:
            if (detailModel.webHelper)
                [detailModel.webHelper cancel];
            break;
        
        default:
            break;
    }
    
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
}

- (void)dealloc
{
    [popController release];
    [dateController release];
    [fromDateStr release];
    [endDateStr release];
    [ztqkModel release];
    [detailModel release];
    [super dealloc];
}

#pragma mark - Choose date range delegate

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    
    self.title = [NSString stringWithFormat:@"按排污类型统计(%@至%@)",fromDateStr,endDateStr];
    
    requestDataType = DataType_Pay_ZTQK;
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

#pragma mark - ZTQK delegate

- (void)returnRequestType:(NSInteger)type
{
    requestDataType = type;
    
    [self requestData];
}

@end
