//
//  TaskCountController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-5.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TaskCountController.h"
#import "NSDateUtil.h"


#import <QuartzCore/QuartzCore.h>

@implementation TaskCountController

@synthesize dataTableView,childTableView;
@synthesize taskCountModel,taskCountZTQKModel,requestDataType;
@synthesize taskCountPWSFModel,taskChildYJModel,taskHJXFModel;
@synthesize popController,endDateStr,fromDateStr,bSelViewRotated,departID;
@synthesize taskXZCFModel,taskZSXKModel,chooseDeptBar,wordsPopoverController;

- (void)setLandscape
{
    //横屏控件位置调整
}

- (void)setPortrait
{
    //竖屏控件位置调整
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

/* 对应的服务名
 Java
 噪声许可
 GET_JCGL_ZSXKTJSL
 行政处罚
 GET_XZCF_XZCFTJSL
 环境信访
 GET_HJXF_HJXFTJSL
 总体情况
 GET_TJZS_TJZSL
 
 c#
 预警
 TaskCountChildYJ
 排污收费
 TaskCountPWSF
 总体情况
 TaskCountZTQK
 现场执法任务
 TaskCount
 */

- (void)requestData
{
    //NSLog(@"%d", requestDataType);//DataType_TaskCountZTQK
    isLoading = YES;
    [self cancelWebRequest:requestDataType];
    switch (requestDataType)
    {
        case DataType_TaskCount:
            [taskCountModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr andDepID:departID];
            break;
        case DataType_TaskCountPWSF:
            [taskCountPWSFModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr  andDepID:departID];
            break;
        case DataType_TaskChildYJ:
            [taskChildYJModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr andDepID:departID];
            break;
        case DataType_TaskCountZTQK://总体情况
            [taskCountZTQKModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr andDepID:departID];
            [childTableView setHidden:YES];
            break;
        case DataType_TaskCountHJXF:
            [taskHJXFModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr andDepID:departID];//环境信访
            break;
        case DataType_TaskCountZSXK:
            [taskZSXKModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr andDepID:departID];//噪声许可
            break;
        case DataType_TaskCountXZCF:
            [taskXZCFModel requestDataWithFromDate:fromDateStr andEndDate:endDateStr andDepID:departID];
            break;
        
        default:
            break;
    }
}

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    
    self.title = [NSString stringWithFormat:@"任务统计(%@至%@)",fromDateStr,endDateStr];
    
    requestDataType = DataType_TaskCountZTQK;
    [self requestData];
}

-(void)cancelSelectDateRange
{
    [popController dismissPopoverAnimated:YES];
}

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    [wordsPopoverController dismissPopoverAnimated:YES];
    NSArray *aryDepId = [NSArray arrayWithObjects:@"",@"0401",@"0402",@"0403",@"0404",@"0405", nil];
    if(row <aryDepId.count)
        self.departID = [aryDepId objectAtIndex:row];
    else
        self.departID = @"";
    chooseDeptBar.title = words;
    requestDataType = DataType_TaskCountZTQK;
    [self requestData];
}

#pragma mark - View lifecycle

-(void)chooseDateRange:(id)sender{
    if(wordsPopoverController)
    {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
    BOOL isload = taskCountZTQKModel.isLoading;
    if (isload) {
        return;
    }
    if(popController == nil){
        ChooseDateRangeController *dateController = [[ChooseDateRangeController alloc] init];
        dateController.delegate = self;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        self.popController = popover;
        [popover release];
        [nav release];
        [dateController release];
    }
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
	//[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)chooseDepartment:(id)sender
{
    if(popController)
    {
        [popController dismissPopoverAnimated:YES];
    }
    if(wordsPopoverController == nil)
    {
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
        tmpController.contentSizeForViewInPopover = CGSizeMake(320, 480);
        tmpController.delegate = self;
        tmpController.wordsAry = [NSArray arrayWithObjects:@"所有部门",@"监察一科",@"监察二科",@"监察三科",@"信访科",@"综合业务科", nil];
        
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.wordsPopoverController = tmppopover;
        [tmppopover release];
        [tmpController release];
        
    }
    
	[self.wordsPopoverController presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
}

-(void)initUI
{
    UIToolbar* tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [tools setTintColor:[self.navigationController.navigationBar tintColor]];
    [tools setAlpha:[self.navigationController.navigationBar alpha]];
    
    UIBarButtonItem *anotherButton0 = [[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                 target:self action:nil];
    fixedButton.width = 20.0f;
    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"选择科室" style:UIBarButtonItemStyleBordered
                                                                      target:self action:@selector(chooseDepartment:)];
    NSArray *aryBtns = [NSArray arrayWithObjects:anotherButton0,fixedButton,anotherButton1, nil];
  
    [tools setItems:aryBtns animated:NO];

    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = myBtn;
    self.chooseDeptBar = anotherButton1;
    [myBtn release];
    [tools release];
    [anotherButton0 release];
    [fixedButton release];
    [anotherButton1 release];/*
    UIBarButtonItem *anotherButton0 = [[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)];
    
    UIBarButtonItem *fixedButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                                                                 target:self action:nil];
    fixedButton.width = 20.0f;
    UIBarButtonItem *anotherButton1 = [[UIBarButtonItem alloc] initWithTitle:@"选择科室" style:UIBarButtonItemStyleBordered
                                                                      target:self action:@selector(chooseDepartment:)];
    NSArray *rightButtons = [NSArray arrayWithObjects:anotherButton1, fixedButton, anotherButton0, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;
    [anotherButton0 release];
    [fixedButton release];
    [anotherButton1 release];*/
}

-(void)initDataModel
{
    taskCountZTQKModel = [[TaskCountZTQKDataModel alloc] initWithParentController:self andTableView:dataTableView];
    taskCountZTQKModel.delegate = self;
    
    taskCountModel = [[TaskCountDataModel alloc] initWithParentController:self andTableView:childTableView];
    taskChildYJModel = [[TaskChildYJDataModel alloc] initWithParentController:self andTableView:childTableView];
    taskCountPWSFModel = [[TaskCountPWSFDataModel alloc] initWithParentController:self andTableView:childTableView];
    taskHJXFModel = [[TaskCountXFTSDataModel alloc] initWithParentController:self andTableView:childTableView];
    taskZSXKModel = [[TaskCountZSXKDataModel alloc] initWithParentController:self andTableView:childTableView];
    taskXZCFModel = [[TaskCountXZCFDataModel alloc] initWithParentController:self andTableView:childTableView];
    
    requestDataType = DataType_TaskCountZTQK;
    
    NSDate *nowDate = [NSDate date];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromDateStr = [NSDateUtil firstDateThisMonth];
    self.endDateStr = [dateFormatter stringFromDate:nowDate];
    [dateFormatter release];
    self.title = [NSString stringWithFormat:@"任务统计(%@至%@)",fromDateStr,endDateStr];
    self.departID = @"";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    bSelViewRotated = NO;
    self.view.backgroundColor = CELL_HEADER_COLOR;
    [self initUI];
    [self initDataModel];
    
    [self requestData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)cancelWebRequest:(int)dataType
{
    switch (requestDataType)
    {
        case DataType_TaskCount:
            if (taskCountModel.webHelper)
                [taskCountModel.webHelper cancel];
            break;
        case DataType_TaskCountPWSF:
            if (taskCountPWSFModel.webHelper)
                [taskCountPWSFModel.webHelper cancel];
            break;
        case DataType_TaskChildYJ:
            if (taskChildYJModel.webHelper)
                [taskChildYJModel.webHelper cancel];
            break;
        case DataType_TaskCountZTQK:
            if (taskCountZTQKModel.webHelper)
                [taskCountZTQKModel.webHelper cancel];
            if (taskCountZTQKModel.webservice)
                [taskCountZTQKModel.webservice cancel];
            break;
        case DataType_TaskCountHJXF:
            if (taskHJXFModel.webservice)
                [taskHJXFModel.webservice cancel];
            break;
        case DataType_TaskCountZSXK:
            if (taskZSXKModel.webservice)
                [taskZSXKModel.webservice cancel];
            break;
        case DataType_TaskCountXZCF:
            if (taskXZCFModel.webservice)
                [taskXZCFModel.webservice cancel];
            break;
        default:
            break;
    }
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (popController)
    {
        [popController dismissPopoverAnimated:YES];
    }
    if (wordsPopoverController)
    {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
    
    switch (requestDataType)
    {
        case DataType_TaskCount:
            if (taskCountModel.webHelper)
                [taskCountModel.webHelper cancel];
            break;
        case DataType_TaskCountPWSF:
            if (taskCountPWSFModel.webHelper)
                [taskCountPWSFModel.webHelper cancel];
            break;
        case DataType_TaskChildYJ:
            if (taskChildYJModel.webHelper)
                [taskChildYJModel.webHelper cancel];
            break;
        case DataType_TaskCountZTQK:
            if (taskCountZTQKModel.webHelper)
                [taskCountZTQKModel.webHelper cancel];
            if (taskCountZTQKModel.webservice)
                [taskCountZTQKModel.webservice cancel];
            break;
        case DataType_TaskCountHJXF:
            if (taskHJXFModel.webservice)
                [taskHJXFModel.webservice cancel];
            break;
        case DataType_TaskCountZSXK:
            if (taskZSXKModel.webservice)
                [taskZSXKModel.webservice cancel];
            break;
        case DataType_TaskCountXZCF:
            if (taskXZCFModel.webservice)
                [taskXZCFModel.webservice cancel];
            break;
        default:
            break;
    }
    
    [super viewWillDisappear:animated];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

#pragma mark - ZTQK delegate

- (void)returnRequestType:(NSDictionary *)dic
{
    //TODO:
    NSString *rwzlStr = [dic objectForKey:@"任务种类"];
    NSArray *typeStrArr = [NSArray arrayWithObjects:@"环境信访",@"噪声许可",@"行政处罚",@"现场执法任务",@"排污收费",@"预警", nil];
    requestDataType = [typeStrArr indexOfObject:rwzlStr];
    [self requestData];
}

@end
