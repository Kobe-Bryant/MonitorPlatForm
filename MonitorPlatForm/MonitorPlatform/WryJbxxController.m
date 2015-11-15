//
//  WryJbxxController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-22.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WryJbxxController.h"

#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "JbxxDataModel.h"
#import "WryXmspModel.h"
#import "XkzDataModel.h"
#import "ZfrwDataModel.h"
#import "PwsfDataModel.h"
#import "CftzDataModel.h"
#import "SolidLinkageDataModel.h"
#import "DBHelper.h"
#import "ZrsUtils.h"
#import "WryOnlineMonitorConroller.h"
#import "FiftyManifestController.h"
#import "ReportListViewController.h"
#import "YCYCViewController.h"

@implementation WryJbxxController

@synthesize wrybh,curParsedData,isGotJsonString;
@synthesize dicJbxx,dicWryjs,aryKeys,resTableView,scrollImage;
@synthesize wryXmspModel,jbxxModel,xkzModel,wrymc,linkageModel;
@synthesize btnTitleView,zfrwModel,pwsfModel,cftzModel;
@synthesize _lightMenuBar,itemAry,zxjcAry,wryjc;
@synthesize emptyView;

#pragma mark - Private Methods

-(void)selectPolutionSrc
{
    PollutionSelectedController *controller = [[PollutionSelectedController alloc] initWithStyle:UITableViewStyleGrouped];	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	nav.modalPresentationStyle =  UIModalPresentationFormSheet;
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight || statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        nav.view.superview.frame = CGRectMake(162, 30, 700, 700);
    else
        nav.view.superview.frame = CGRectMake(30, 100, 700, 700);
	[self presentModalViewController:nav animated:YES];
	[controller release];
    [nav release];
    
}


#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)/2, (960-290)*0.35, 350, 290)];
    emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
    [self.view addSubview:emptyView];
    emptyView.hidden = YES;
    
    self.title = [NSString stringWithFormat:@"%@台账",wrymc];
    self.scrollImage.hidden = YES;
    NSLog(@"%@ %@",wrybh,wrymc);
    //基本信息数据
    self.jbxxModel = [[[JbxxDataModel alloc] initWithWryBH:wrybh parentController:self andTableView: resTableView] autorelease];
    [jbxxModel requestData];
    
    //项目审批数据
    self.wryXmspModel = [[[WryXmspModel alloc] initWithWryBH:wrybh parentController:self andTableView: resTableView] autorelease];
    
    //许可证
    self.xkzModel = [[[XkzDataModel alloc] initWithWryBH:wrybh parentController:self andTableView:resTableView] autorelease];
    
    //排污收费
    self.pwsfModel = [[[PwsfDataModel alloc] initWithWryBH:wrybh parentController:self andTableView:resTableView] autorelease];
    
    //在线检查
    self.zfrwModel = [[[ZfrwDataModel alloc] initWithWryBH:wrybh parentController:self andTableView:resTableView andImageView:scrollImage] autorelease];
    
    //行政处罚
    self.cftzModel = [[[CftzDataModel alloc] initWithWryBH:wrybh parentController:self andTableView:resTableView] autorelease];
    
    self.linkageModel = [[[SolidLinkageDataModel alloc] initWithWryBH:wrybh parentController:self andTableView:resTableView andImageView:scrollImage] autorelease];
    
    self._lightMenuBar = [[[LightMenuBar alloc] initWithFrame:CGRectMake(0, 0, 768, 74) andStyle:LightMenuBarStyleItem] autorelease];
    
    _lightMenuBar.delegate = self;
    _lightMenuBar.selectedItemIndex = 0;
    [self.view addSubview:self._lightMenuBar];
    self.itemAry = [NSArray arrayWithObjects:@"基本信息",@"项目审批",@"许可证",@"排污收费",@"行政处罚",@"危险废物",@"检查记录",@"在线监测", @"监测报告", @"一厂一策", nil];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.resTableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (jbxxModel.webHelper)
        [jbxxModel.webHelper cancel];
    if (wryXmspModel.webHelper)
        [wryXmspModel.webHelper cancel];
    if (xkzModel.webHelper)
        [xkzModel.webHelper cancel];
    if (zfrwModel.webHelper)
        [zfrwModel.webHelper cancel];
    if (pwsfModel.webHelper)
        [pwsfModel.webHelper cancel];
    if (cftzModel.webHelper)
        [cftzModel.webHelper cancel];
    if (linkageModel.webHelper)
        [linkageModel.webHelper cancel];
    
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}



#pragma mark LightMenuBarDelegate
- (NSUInteger)itemCountInMenuBar:(LightMenuBar *)menuBar {
    return [itemAry count];
}

- (NSString *)itemTitleAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    return [itemAry objectAtIndex:index];
}

- (void)itemSelectedAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
    emptyView.hidden = YES;
    resTableView.hidden = NO;
    if (index==0) 
    {
        //基本信息
        [jbxxModel requestData];
    }
    else if(index == 1)
    {
        //项目审批
        [wryXmspModel requestData];
    }
    else if(index == 2)
    {
        //许可证
        [xkzModel requestData];
    }
    else if(index == 3)
    {
        //排污收费
        [pwsfModel requestData];
    }
    else if(index == 4)
    {
        //行政处罚
        [cftzModel requestData];
    }
    else if(index == 5)
    {
        //危险废物
        FiftyManifestController *childVC = [[FiftyManifestController alloc] initWithNibName:@"FiftyManifestController" bundle:nil];
        if (wryjc)
            childVC.cszStr = wryjc;
        else
        {
            childVC.cszStr = wrymc;//[wrymc substringFromIndex:2];
        }
        childVC.wrymc = wrymc;
        childVC.wrybh = wrybh;
        
        childVC.entranceFlag = 2;
        [self.navigationController pushViewController:childVC animated:YES];
        [childVC release];
    }
    else if(index == 6)
    {
        //检查记录
        [zfrwModel requestData];
    }
    else if(index == 7)
    {
        //在线监测
        WryOnlineMonitorConroller *childVC = [[WryOnlineMonitorConroller alloc] initWithNibName:@"WryOnlineMonitorConroller" bundle:nil];
        childVC.wrybh = wrybh;
        childVC.wrymc = wrymc;
        
        [self.navigationController pushViewController:childVC animated:YES];
        [childVC release];
    }
    else if(index == 8)
    {
        //监测报告
        ReportListViewController *list = [[ReportListViewController alloc] initWithNibName:@"ReportListViewController" bundle:nil];
        list.wrybh = wrybh;
        list.wrymc = wrymc;
        [self.navigationController pushViewController:list animated:YES];
        [list release];
    }
    else if(index == 9)
    {
        //一厂一策
        YCYCViewController *ycyc = [[YCYCViewController alloc] initWithNibName:@"YCYCViewController" bundle:nil];
        ycyc.wrybh = wrybh;
        ycyc.wrymc = wrymc;
        [self.navigationController pushViewController:ycyc animated:YES];
        [ycyc release];
    }
        
    self.scrollImage.hidden = YES;
    [resTableView reloadData];
}

//< Optional
/*
 - (CGFloat)itemWidthAtIndex:(NSUInteger)index inMenuBar:(LightMenuBar *)menuBar {
 return 60.0f;
 }
 */

/**< Height Rate of Seperator, by Default 0.7f */
- (CGFloat)seperatorHeightRateInMenuBar:(LightMenuBar *)menuBar
{
    return 0.0f;
}

- (void)dealloc
{
    self.emptyView = nil;
    [super dealloc];
}

@end
