//
//  MainMenuViewController.m
//  Eve
//
//  Created by yushang on 10-11-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainMenuViewController.h"
#import "ButtonViewController.h"
#import "StuffPositionVC.h"
#import "ToDoOAController.h"
#import "PunishController.h"
#import "ComplaintsListViewController.h"
#import "SearchDoneComplaintsController.h"
#import "SearchDonePunishController.h"
#import "HaveDoneOAController.h"
#import "AssignmentViewController.h"

#import "UIView+Positioning.h"
#import "JSSGStaticsViewController.h"
#import "RequestNumberObject.h"
#import "TaskCountController.h"
#import "PollutionSelectVC.h"
#import "OneDayTrailCountController.h"
#import "MonitorWarnCountController.h"
#import "WcltjController.h"
#import "SearchLinkageController.h"
#import "GFStatisticTypeListVC.h"

#import "ProjectApprovedVC.h"

#import "WryMapViewController.h"
#import "QueryWryOnlineVC.h"
#import "QueryBuildingProjectVC.h"
#import "QueryBuildingDeptVC.h"

#import "STSViewController.h"
#import "XZCFStaticsViewController.h"
#import "NoiseStaticsViewController.h"
#import "WryQueryViewController.h"
#import "PWSFViewController.h"
#import "XFTSStaticsViewController.h"
#import "DoneNoiseAllowVC.h"
#import "UIChargeController.h"
#import "CategoryViewController.h"
#import "ChangePasswordVC.h"
#import "ReadMonthTableVC.h"
#import "NoiseAllowViewController.h"
#import "AirPM25DetailVC.h"
#import "ZFTZListViewController.h"

@implementation MainMenuViewController
@synthesize scrollView, viewControllers,aryBadgeViews,bgImageView;
@synthesize oaRequestNumber,xfRequestNumber,xzcfRequestNumber,zsxkRequestNumber,pageControl;

- (void)toggleFromByPage:(NSInteger) nPage ByIndex:(NSInteger) nIndex
{
	UIViewController *controller = nil;
    switch (nPage)
    {
        case 0:
        {
            if (nIndex == 0) 
            {
                //移动办公
                controller = [[ToDoOAController alloc] initWithNibName:@"ToDoOAController" bundle:nil];
            }
            else if (nIndex == 1)
            {
                //已办公文
                controller = [[HaveDoneOAController alloc] initWithNibName:@"HaveDoneOAController" bundle:nil];
            }
            else if (nIndex == 2)
            {
                //信访处理
                controller =  [[ComplaintsListViewController alloc] initWithNibName:@"ComplaintsListViewController" bundle:nil];
            }
            else if (nIndex == 3)
            {
                //已办信访
                SearchDoneComplaintsController *aCtrl = [[SearchDoneComplaintsController alloc] initWithNibName:@"SearchDoneComplaintsController" bundle:nil];
                aCtrl.listType = 1;
                controller = aCtrl;
            }
            else if (nIndex == 4) 
            {
                //行政处罚
                controller = [[PunishController alloc] initWithNibName:@"PunishController" bundle:nil];
            }
            else if (nIndex == 5)
            {
                //已办处罚
                SearchDonePunishController *aCtrl = [[SearchDonePunishController alloc] initWithNibName:@"SearchDonePunishController" bundle:nil];
                aCtrl.listType = 1;
                controller = aCtrl;
            }
           /* else if (nIndex == 6)
            {
                //噪声许可
                NoiseAllowViewController *noise = [[NoiseAllowViewController alloc] initWithNibName:@"NoiseAllowViewController" bundle:nil];
                controller = noise;
            }*/
            else if (nIndex == 6)
            {
                //已办噪声许可
                DoneNoiseAllowVC *noise = [[DoneNoiseAllowVC alloc] initWithNibName:@"DoneNoiseAllowVC" bundle:nil];
                noise.isTastDone = YES;
                controller = noise;
            }
            else if (nIndex == 7)
            {
                //任务指派
                AssignmentViewController *assignment = [[AssignmentViewController alloc] initWithNibName:@"AssignmentViewController" bundle:nil];
                assignment.isTastDone = YES;
                controller = assignment;
            }
        }
            break;
        case 1:
        {
            if (nIndex == 0)
            {
                //任务统计
                controller =  [[TaskCountController alloc] initWithNibName:@"TaskCountController" bundle:nil];
            }
            else if(nIndex == 1)
            {
                //排污收费统计
                controller = [[PWSFViewController alloc] initWithNibName:@"PWSFViewController" bundle:nil];
                ((PWSFViewController *)controller).statisticType = 50;
            }
            else if(nIndex == 2)
            {
                //信访投诉统计
                controller = [[PWSFViewController alloc] initWithNibName:@"PWSFViewController" bundle:nil];
                ((PWSFViewController *)controller).statisticType = 51;
            }
            else if(nIndex == 3)
            {
                //行政处罚统计
                controller = [[PWSFViewController alloc] initWithNibName:@"PWSFViewController" bundle:nil];
                ((PWSFViewController *)controller).statisticType = 52;
            }
            else if(nIndex == 4)
            {
                //在线超标统计
                controller = [[MonitorWarnCountController alloc] initWithNibName:@"MonitorWarnCountController" bundle:nil];
            }
            else if(nIndex == 5)
            {
                //危废转移统计
                controller = [[GFStatisticTypeListVC alloc] initWithNibName:@"GFStatisticTypeListVC" bundle:nil];
            }
            else if(nIndex == 6)
            {
                //噪声许可统计
                controller = [[NoiseStaticsViewController alloc] init];
            }
            else if (nIndex == 7)
            {
                //建筑工地查询
                controller = [[JSSGStaticsViewController alloc] init];
            }
        }
            break;
        case 2:
        {
            if (nIndex == 0) 
            {
                //执法台账
                controller = [[ZFTZListViewController alloc]initWithNibName:@"ZFTZListViewController" bundle:nil];
                 
            }
            else if (nIndex == 1)
            {
                //排污收费查询
                controller = [[QueryWryOnlineVC alloc] initWithNibName:@"QueryWryOnlineVC" bundle:nil];
            }
            else if (nIndex == 2) 
            {
                SearchDoneComplaintsController *aCtrl = [[SearchDoneComplaintsController alloc] initWithNibName:@"SearchDoneComplaintsController" bundle:nil];
                aCtrl.listType = 2;
                controller = aCtrl;
            }
            else if(nIndex == 3)
            {
                SearchDonePunishController *aCtrl = [[SearchDonePunishController alloc] initWithNibName:@"SearchDonePunishController" bundle:nil];
                aCtrl.listType = 2;
                controller = aCtrl;
            }
            else if(nIndex == 4)
            {
                PollutionSelectVC *aCtrl = [[PollutionSelectVC alloc] initWithNibName:@"PollutionSelectVC" bundle:nil];
                [aCtrl setStatus:1];
                controller = aCtrl;
            }
            else if (nIndex == 5)
            {
                DoneNoiseAllowVC *aCtrl = [[DoneNoiseAllowVC alloc] initWithNibName:@"DoneNoiseAllowVC" bundle:nil];
                aCtrl.listType = 2;
                controller = aCtrl;
            }
            else if (nIndex == 6)
            {
                //施工单位查询
                controller = [[QueryBuildingDeptVC alloc] initWithNibName:@"QueryBuildingDeptVC" bundle:nil];
            }
            else if(nIndex == 7)
            {
                //建筑工程项目查询
                controller = [[QueryBuildingProjectVC alloc] initWithNibName:@"QueryBuildingProjectVC" bundle:nil];
            }
            else if (nIndex == 8)
            {
                //危废转移
                controller = [[SearchLinkageController alloc] initWithNibName:@"SearchLinkageController" bundle:nil];
            }
            else if(nIndex == 9)
            {
                //综合月报
                controller = [[ReadMonthTableVC alloc] initWithNibName:@"ReadMonthTableVC" bundle:nil];
            }
            else if(nIndex == 10)
            {
                //PM2.5数据监测
                controller = [[AirPM25DetailVC alloc] initWithNibName:@"AirPM25DetailVC" bundle:nil];
            }
            else if(nIndex == 11)
            {
                //监测报告
                PollutionSelectVC *aCtrl = [[PollutionSelectVC alloc] initWithNibName:@"PollutionSelectVC" bundle:nil];
                [aCtrl setStatus:1];
                aCtrl.enterCode = 12;
                controller = aCtrl;
            }
        }
            break;
            
        case 3:
        {
            if (nIndex == 0)
            {
                //污染源台账
                controller = [[WryQueryViewController alloc] initWithNibName:@"WryQueryViewController" bundle:nil];
                
            }
            else if (nIndex == 1)
            {
                controller = [[ProjectApprovedVC alloc] initWithNibName:@"ProjectApprovedVC" bundle:nil];
            }
            else if (nIndex == 2)
            {
                controller =  [[WryMapViewController alloc] initWithNibName:@"WryMapViewController" bundle:nil];
            }
            else if (nIndex == 3)
            {
                controller =  [[StuffPositionVC alloc] initWithNibName:@"StuffPositionVC" bundle:nil];
            }
            
        }
            break;
            
        case 4:
        {
            if (nIndex == 0||nIndex==1||nIndex==3||nIndex==4||nIndex==5)
            {
                
                UIChargeController *charge = [[UIChargeController alloc] initWithNibName:@"UIChargeController" bundle:nil];
                if(nIndex == 0)
                    charge.firstPageType = PAGE_TYPE_FLFG;
                else if(nIndex == 1)
                    charge.firstPageType = PAGE_TYPE_ZYZDS;
                else if(nIndex == 3)
                    charge.firstPageType = PAGE_TYPE_NBZD;
                else if(nIndex == 4)
                    charge.firstPageType = PAGE_TYPE_HBBZ;
                else
                    charge.firstPageType = PAGE_TYPE_YJZN;
                controller = charge;
                
            }
            else if (nIndex == 2)
            {
                controller = [[CategoryViewController alloc]initWithNibName:@"CategoryViewController" bundle:nil];
            }
        }
            break;
            
        case 5:
        {
            if (nIndex == 0)
            {
                controller = [[ChangePasswordVC alloc] initWithNibName:@"ChangePasswordVC" bundle:nil];
            }
        }
            break;
            
        default:
            break;
    }
    if (controller != nil) {
		[self.navigationController pushViewController:controller animated:YES];
		[controller release];
	}
}

- (void)didFinishParsingWithCount:(NSInteger)numCount andType:(NSInteger)type
{
    if(type == 0)oaCount = numCount;
    else if(type == 1)xfCount = numCount;
    else if(type == 2)xzcfCount = numCount;
    else if(type == 3)zsxkCount = numCount;
    
    zsxkCount = 0;
    ButtonViewController *controller1 = [viewControllers objectAtIndex:0];
    [controller1 updateBadgesWithOaCount:oaCount andXfCount:xfCount andChufaCount:xzcfCount andZaoShengCount:zsxkCount];
}

-(NSInteger)calcCurrentPage
{
    return floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
}

-(void)syncDatas
{
    syncManager = [[DataSyncManager alloc] init];
    [syncManager syncWryList];
}

- (void)viewDidLoad {	
	self.title = @"主功能界面";
    
    [super viewDidLoad];
    

    
	//[self setupPage];	
    //[self addCustomTabView];
    RequestNumberObject *reqObject1 = [[RequestNumberObject alloc] init];
    [reqObject1 setDelegate:self];
    //[reqObject1 requestOANumber];
    self.oaRequestNumber = reqObject1;
    [reqObject1 release];
    
    RequestNumberObject *reqObject2 = [[RequestNumberObject alloc] init];
    [reqObject2 setDelegate:self];
    //[reqObject2 requestXFNumber];
    self.xfRequestNumber = reqObject2;
    [reqObject2 release];
    
    RequestNumberObject *reqObject3 = [[RequestNumberObject alloc] init];
    [reqObject3 setDelegate:self];
    //[reqObject3 requestChufaNumber];
    self.xzcfRequestNumber = reqObject3;
    [reqObject3 release];
    /*
    RequestNumberObject *reqObject4 = [[RequestNumberObject alloc] init];
    [reqObject4 setDelegate:self];
    self.zsxkRequestNumber = reqObject4;
    [reqObject4 release];*/
    
    int page = [self calcCurrentPage];
    self.scrollView.frame = CGRectMake(0, 0, 768, 900);
    CGPoint tmpOffset = CGPointMake(768 * page, scrollView.contentOffset.y);
    self.scrollView.contentOffset = tmpOffset;
    self.pageControl.frame = CGRectMake(295, 910, 179, 36);
    //self.bgImageView.frame = CGRectMake(0, 0, 768, 1024);
    self.bgImageView.image = [UIImage imageNamed:@"mainmenu_bg.jpg"];
    for (UIViewController *controller in viewControllers) {
        [controller.view removeFromSuperview];
    }
    
    [viewControllers removeAllObjects];
    [self setupPage];
    [self syncDatas];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:animated];
    
   
    
}

- (void)viewWillAppear:(BOOL)animated {

    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillAppear:animated];
    [oaRequestNumber requestOANumber];
    [xfRequestNumber requestXFNumber];
    [xzcfRequestNumber requestChufaNumber];
    //[zsxkRequestNumber requestZaoShengNumber];

}

- (void)viewWillDisappear:(BOOL)animated {
	//self.navigationItem.hidesBackButton = YES;
	[self.navigationController setNavigationBarHidden:NO animated:YES];	
	
	
}


- (void)viewDidDisappear:(BOOL)animated {
	
	[super viewDidDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    int page = [self calcCurrentPage];
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight)
    {
        self.scrollView.frame = CGRectMake(0, 0, 1024, 650);
        CGPoint tmpOffset = CGPointMake(1024 * page, scrollView.contentOffset.y);
        self.scrollView.contentOffset = tmpOffset;
        self.pageControl.frame = CGRectMake(423, 660, 179, 36);
        //self.bgImageView.frame = CGRectMake(0, 0, 1024, 768);
        self.bgImageView.image = [UIImage imageNamed:@"mainmenu_landscape.jpg"];
    }
    else if (toInterfaceOrientation == UIInterfaceOrientationPortrait || toInterfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown)
    {
        self.scrollView.frame = CGRectMake(0, 0, 768, 900);
        CGPoint tmpOffset = CGPointMake(768 * page, scrollView.contentOffset.y);
        self.scrollView.contentOffset = tmpOffset;
        self.pageControl.frame = CGRectMake(295, 910, 179, 36);
        //self.bgImageView.frame = CGRectMake(0, 0, 768, 1024);
        self.bgImageView.image = [UIImage imageNamed:@"mainmenu_bg.jpg"];
    }
    for (UIViewController *controller in viewControllers)
    {
        [controller.view removeFromSuperview];
    }
    
    [viewControllers removeAllObjects];
    [self setupPage];
    
    ButtonViewController *controller1 = [viewControllers objectAtIndex:0];
    [controller1 updateBadgesWithOaCount:oaCount andXfCount:xfCount andChufaCount:xzcfCount andZaoShengCount:zsxkCount];

}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    [viewControllers release];
    [scrollView release];
    [syncManager release];
    [oaRequestNumber release];
    [xfRequestNumber release];
    [xzcfRequestNumber release];
    [super dealloc];
}

#pragma mark -
#pragma mark The Guts
- (void)setupPage
{
	NSMutableArray *controllers = [[NSMutableArray alloc] init];
	self.viewControllers = controllers;
	[controllers release];
	  

    NSArray * titlePage1 = [[NSArray alloc] initWithObjects:@"移动办公",@"已办公文",@"信访处理",@"已办信访",@"行政处罚",@"已办处罚",@"已办噪声许可",@"任务指派",nil];

	NSArray * titlePage2 = [[NSArray alloc] initWithObjects:@"任务统计",@"排污收费统计",@"信访投诉统计",@"行政处罚统计",@"在线超标统计",@"危废转移统计",@"噪声许可统计",@"建筑工地统计",nil];
    
    NSArray * titlePage3 = [[NSArray alloc] initWithObjects:@"执法台账",@"排污收费查询",@"信访投诉查询",@"行政处罚台账",@"在线监测查询",@"噪声许可查询",@"施工单位查询",@"建筑工程项目查询",@"危废转移联单查询",@"综合月报表查询",@"PM2.5实时监测数据",@"监测报告",nil];
    
    NSArray * titlePage4 = [[NSArray alloc] initWithObjects:@"污染源台账",@"建设项目审批查询",@"污染源地图查询",@"人员定位", nil];
    
    NSArray * titlePage5 = [[NSArray alloc] initWithObjects:@"法律法规",@"作业指导书",@"危险化学品",@"内部管理制度",@"环保标准",@"应急指南", nil];
    
    NSArray * titlePage6 = [[NSArray alloc] initWithObjects:@"修改密码", nil];

    ButtonViewController *controller1 = 
    [[ButtonViewController alloc] initWithButtonsAry:titlePage1
                                            andTitle:@"业务办理"
                                          andPageNum:0];
    controller1.parent = self;
    [viewControllers addObject:controller1];
    
    
    ButtonViewController *controller2 = 
    [[ButtonViewController alloc] initWithButtonsAry:titlePage2
                                            andTitle:@"业务统计"
                                          andPageNum:1];
    controller2.parent = self;
    [viewControllers addObject:controller2];
    
    ButtonViewController *controller3 = 
    [[ButtonViewController alloc] initWithButtonsAry:titlePage3
                                            andTitle:@"业务查询"
                                          andPageNum:2];
    controller3.parent = self;
    [viewControllers addObject:controller3];
    
    ButtonViewController *controller4 = 
    [[ButtonViewController alloc] initWithButtonsAry:titlePage4
                                            andTitle:@"污染源管理"
                                          andPageNum:3];
    controller4.parent = self;
    [viewControllers addObject:controller4];
    
    ButtonViewController *controller5 = 
    [[ButtonViewController alloc] initWithButtonsAry:titlePage5
                                            andTitle:@"环保手册"
                                          andPageNum:4];
    controller5.parent = self;
    [viewControllers addObject:controller5];
  
    ButtonViewController *controller6 = 
    [[ButtonViewController alloc] initWithButtonsAry:titlePage6
                                            andTitle:@"系统设置"
                                          andPageNum:5];
    controller6.parent = self;
    [viewControllers addObject:controller6];
   /* 
    ButtonViewController *controller7 = 
    [[ButtonViewController alloc] initWithButtonsAry:titlePage7
                                            andTitle:@"视频监控"
                                          andPageNum:6];
    controller7.parent = self;
    [viewControllers addObject:controller7];
    */

    [controller1 release];
    [controller2 release];
    [controller3 release];
    [controller4 release];
    [controller5 release];
    [controller6 release];
 //   [controller7 release];
    [titlePage1 release];
    [titlePage2 release];
    [titlePage3 release];
    [titlePage4 release];
    [titlePage5 release];
    [titlePage6 release];
 //   [titlePage7 release];
    
	scrollView.delegate = self;	

	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.backgroundColor = [UIColor clearColor];
	
	CGFloat cx = 0;

	for (int i = 0; i < 6; i++) {
		// replace the placeholder if necessary
        
        UIViewController *controller = [viewControllers objectAtIndex:i];
        
        CGRect frame = scrollView.frame;
        frame.origin.x = frame.size.width * i;
        frame.origin.y = 0;
        //frame.size.height = frame.size.height + 20;

        controller.view.frame = frame;
        [scrollView addSubview:controller.view];
		cx += scrollView.frame.size.width;
	}
	
    self.pageControl.numberOfPages = 6;
	[scrollView setContentSize:CGSizeMake(cx, [scrollView bounds].size.height)];
}

#pragma mark -
#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
	
    int page = [self calcCurrentPage];

    pageControl.currentPage = page;
    

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView 
{
    pageControlIsChangingPage = NO;
}

#pragma mark - PageControl stuff
- (IBAction)changePage:(id)sender 
{
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlIsChangingPage = YES;	
}

@end
