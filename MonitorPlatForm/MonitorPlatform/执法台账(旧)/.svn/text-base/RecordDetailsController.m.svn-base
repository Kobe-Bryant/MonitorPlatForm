//
//  RecordDetailsController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-13.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "RecordDetailsController.h"
#import "ChildRecordDetailController.h"
#import "HtmlTableGenerator.h"
#import "RecordItem.h"
#import "GCDiscreetNotificationView.h"
#import "MBProgressHUD.h"

@implementation RecordDetailsController
@synthesize childTableAry;
@synthesize dataDic,childViewRect;
@synthesize wordsSelectViewController,wordsPopoverController;

#pragma mark - Private methods

- (void)dealloc
{
    self.childTableAry = nil;
    [super dealloc];
}


#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Words delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row {
    [wordsPopoverController dismissPopoverAnimated:YES];
    ChildRecordDetailController *childController =[[ChildRecordDetailController alloc] init];
    childController.theItem = [childTableAry objectAtIndex:row];
    [self.navigationController pushViewController:childController animated:YES];
    [childController release];
}

/*
1#  询问笔录  RetrieveAskRecord
2#  废水 RetrieveWastewaterRecord
3#  废气 RetrieveWasteGasRecord
4#  电厂 RetrievePowerStationRecord
5#  污水处理厂 RetrieveWastewaterTreatmentPlantRecord
6#  其他现场检查 RetrieveGeneralCheckRecord
7#  污染源现场检查（勘察）笔录 RetrieveCheckTrans
8#  生活垃圾卫生填埋处理行业现场核查表 RetrieveWasteLandFill
9#  生活垃圾焚烧处理行业现场核查表 RetrieveWasteIncineration
10# 城镇污水处理厂现场核查表 RetrieveCityWatsteWater
11# 危险废物填埋场现场核查表 RetrieveDuping
12# 工业企业环境安全风险隐患现场核查表 RetrieveFrmIndustrySafety
13# 燃煤电厂污染源现场核查记录表 RetrieveFrmPowerStationForm
14# 燃气电厂污染源现场核查记录表 RetrieveFrmPowerStationRQ
15# 一般工业污染源现场核查表 RetrieveIndustry
16# 污染源现场调查询问笔录 RetrieveNewAskRecord
17# 电镀线路板行业现场核查表 RetrievePlatingPCB
18# 污染源现场监察记录表 RetrieveSiteSupervise
19# 污泥填埋处理行业现场核查表 RetrieveSludgeLandFill
*/

-(void)parseChildBilu
{
    NSString *childBilu = [dataDic objectForKey:@"笔录类型"];
    NSArray *sepAry = [childBilu componentsSeparatedByString:@"#"];
    NSArray *childTableName = [NSArray arrayWithObjects:@"询问笔录",@"废水",@"废气", @"电厂",@"污水处理厂", @"其他现场检查",@"污染源现场检查（勘察）笔录",@"生活垃圾卫生填埋处理行业现场核查表",@"生活垃圾焚烧处理行业现场核查表",@"城镇污水处理厂现场核查表",@"危险废物填埋场现场核查表",@"工业企业环境安全风险隐患现场核查表",@"燃煤电厂污染源现场核查记录表",@"燃气电厂污染源现场核查记录表",@"一般工业污染源现场核查表",@"污染源现场调查询问笔录",@"电镀线路板行业现场核查表",@"污染源现场监察记录表",@"污泥填埋处理行业现场核查表",nil];
    NSArray *childTableService = [NSArray arrayWithObjects:@"RetrieveAskRecord",@"RetrieveWastewaterRecord",@"RetrieveWasteGasRecord", @"RetrievePowerStationRecord",@"RetrieveWastewaterTreatmentPlantRecord", @"RetrieveGeneralCheckRecord",@"RetrieveCheckTrans",@"RetrieveWasteLandFill",@"RetrieveWasteIncineration",@"RetrieveCityWatsteWater",@"RetrieveDuping",@"RetrieveFrmIndustrySafety",@"RetrieveFrmPowerStationForm",@"RetrieveFrmPowerStationRQ",@"RetrieveIndustry",@"RetrieveNewAskRecord",@"RetrievePlatingPCB",@"RetrieveSiteSupervise",@"RetrieveSludgeLandFill",nil];
    
    for(NSString *type in sepAry)
    {
        int index = [type integerValue] -1;
        if(index >=1 && index < childTableName.count)
        {
            RecordItem *aItem = [[RecordItem alloc] init];
            aItem.recordName = [childTableName objectAtIndex:index];
            aItem.recordBH = [dataDic objectForKey:@"编号"];
            aItem.serviceName = [childTableService objectAtIndex:index];
            [childTableAry addObject:aItem];
            [aItem release];
        }
    }
}

- (void)selectChildTable:(id)sender
{
    if(childTableAry.count <= 0)
    {
        [self parseChildBilu];
    }
    if(wordsPopoverController == nil)
    {
        if(childTableAry.count <= 0)
        {
            GCDiscreetNotificationView *notificationView = [[GCDiscreetNotificationView alloc] initWithText:@"暂时没有相关联的笔录信息" showActivity:YES inPresentationMode:GCDiscreetNotificationViewPresentationModeTop inView:self.view];
            [notificationView show:YES];
            [notificationView hideAnimatedAfter:2.4f];
            [notificationView release];
            return;
        }
        CommenWordsViewController *tmpController = [[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil ];
        tmpController.contentSizeForViewInPopover = CGSizeMake(320, 480);
        tmpController.delegate = self;
        NSMutableArray *aryWords = [NSMutableArray arrayWithCapacity:10];
        for(RecordItem *aItem in childTableAry)
        {
            [aryWords addObject:aItem.recordName];
        }
        tmpController.wordsAry = aryWords;
        
        UIPopoverController *tmppopover = [[UIPopoverController alloc] initWithContentViewController:tmpController];
        self.wordsSelectViewController = tmpController;
        self.wordsPopoverController = tmppopover;
        [tmppopover release];
        [tmpController release];
        
    }
    [self.wordsPopoverController dismissPopoverAnimated:YES];
    
	[self.wordsSelectViewController.tableView reloadData];
	[self.wordsPopoverController presentPopoverFromBarButtonItem:sender
                                        permittedArrowDirections:UIPopoverArrowDirectionAny
                                                        animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"任务详细信息";
    
    //导航栏右边按钮
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"关联笔录子表" style:UIBarButtonItemStyleDone target:self action:@selector(selectChildTable:)] autorelease];
        
    self.childTableAry = [NSMutableArray array];
    
    NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"现场执法笔录主表" andParaMeters:dataDic andServiceName:@"NewRetrieveCheckRecord"];
    //NSLog(@"%@",htmlStr);
    myWebView.dataDetectorTypes = UIDataDetectorTypeNone;
    [myWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (wordsPopoverController)
        [wordsPopoverController dismissPopoverAnimated:YES];
    
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}


@end
