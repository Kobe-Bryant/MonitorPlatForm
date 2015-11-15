//
//  ZfrwDataModel.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ZfrwDataModel.h"
#import "JSONKit.h"
#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "RecordDetailsController.h"
#import "MPAppDelegate.h"
#import "ChildRecordDetailController.h"
#import "WryJbxxController.h"
#import "ZFXXListViewController.h"
#import "ServiceUrlString.h"
#import "NSURLConnHelper.h"
#import "QQList.h"
#import "QQSectionHeaderView.h"
#import "ZFTZParticularsViewController.h"
#import "ZFTZChartViewController.h"

extern MPAppDelegate *g_appDelegate;
@interface ZfrwDataModel()
@property (nonatomic,retain) NSURLConnHelper *webHelper;
@property (nonatomic,retain) NSMutableArray *headeArray;
@property (nonatomic,retain) NSMutableArray *valueArray;
@property (nonatomic,retain) NSMutableArray *lists;
@property (nonatomic,copy) NSString *service;
@property (nonatomic,retain) NSArray *titleArray;
@property (nonatomic,retain) NSArray *keyArray;
@property (retain, nonatomic) NSDictionary *dataDic;
@end

@implementation ZfrwDataModel
@synthesize infoAry,mutableInfoAry,webResultAry;
@synthesize titleAry1,titleAry2,isLoading;
@synthesize isEnd,isScroll,currentPage,scrollImage;

#define nAskRecord 1
#define nWasteWaterRecord 2
#define nWasteGasRecord 3
#define nPowerStationRecord 4
#define nTreatmentPlantRecord 5
#define nGeneralCheckRecord 6

#define RetrieveAskRecord 1
#define RetrieveWastewaterRecord 2
#define RetrieveWasteGasRecord 3
#define RetrievePowerStationRecord 4
#define RetrieveWastewaterTreatmentPlantRecord 5
#define RetrieveGeneralCheckRecord 6
#define RetrieveCheckTrans 7
#define RetrieveWasteLandFill 8
#define RetrieveWasteIncineration 9
#define RetrieveCityWatsteWater 10
#define RetrieveDuping 11
#define RetrieveFrmIndustrySafety 12
#define RetrieveFrmPowerStationForm 13
#define RetrieveFrmPowerStationRQ 14
#define RetrieveIndustry 15
#define RetrieveNewAskRecord 16
#define RetrievePlatingPCB  17
#define RetrieveSiteSupervise  18
#define RetrieveSludgeLandFill 19

#pragma mark - Private methods

-(id)initWithWryBH:(NSString*)bh 
  parentController:(UIViewController*)controller 
      andTableView:(UITableView*)tableView
      andImageView:(UIImageView *)img
{
    
    self = [super init];
    if (self)
    {
        self.wrybh = bh;
        self.displayTableView = tableView;
        self.parentController = controller;
        self.scrollImage = img;
        isDataRequested = NO;
    }
    return self;
}

- (void)getWebDataWithCode:(NSString *)wryCode pageCount:(int)page
{
    self.isLoading = YES;
    self.lists = [NSMutableArray array];
    self.valueArray = [NSMutableArray array];
    self.headeArray = [NSMutableArray array];
    
    NSMutableDictionary *paramsCount = [NSMutableDictionary dictionary];
    [paramsCount setObject:@"QUERY_WRYGTBD_COUNT" forKey:@"service"];
    [paramsCount setObject:wryCode forKey:@"WRYBH"];
    [paramsCount setObject:@"2" forKey:@"TYPE"];
    NSString *strUrlCount = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:paramsCount];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrlCount andParentView:parentController.view delegate:self];
    
}

-(void)requestData
{
    self.mutableInfoAry = [NSMutableArray array];
    self.infoAry = [NSMutableArray array];
    
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    if(isDataRequested)
    {
        [displayTableView reloadData];
        return;
    }
    
    currentPage = 1;
    isScroll = NO;
    isEnd = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self getWebDataWithCode:wrybh pageCount:currentPage];
}

#pragma mark - URL ConnHelper Delegate

- (void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    NSString *jsonStr = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    if (tag == 2)
    {
        NSDictionary *jsonDic = [jsonStr objectFromJSONString];
        [self.valueArray removeAllObjects];
        [self.valueArray addObjectsFromArray:[jsonDic objectForKey:@"data"]];
        QQList *list = nil;
        NSString *timeKey = nil;
        NSInteger dataTag = 0;
        if ([self.service isEqualToString:@"QUERY_XCJC_RECORDS"]) {
            list = [self.lists objectAtIndex:0];
            dataTag = 0;
            timeKey = @"JCSJS";
        }
        else{
            list = [self.lists objectAtIndex:1];
            dataTag = 1;
            timeKey = @"DCJSSJ";
        }
        for (int j = 0; j < [self.valueArray count]; j++)
        {
            NSDictionary *dataDic = [self.valueArray objectAtIndex:j];
            QQPerson *person = [[[QQPerson alloc] init] autorelease];
            person.m_nListID = dataTag; //  分组依据
            person.m_dataDic = dataDic;
            person.m_strPersonName = [NSString stringWithFormat:@"现场执法编号:%@",[dataDic objectForKey:@"XCZFBH"]];
            person.m_strDept = [NSString stringWithFormat:@"执法时间:%@",[dataDic objectForKey:timeKey]];
            [list.m_arrayPersons addObject:person];
            [list.indexPaths addObject:[NSIndexPath indexPathForRow:j inSection:dataTag]];
        }
    }
    else{
        NSArray *array = [jsonStr objectFromJSONString];
        if (array && array.count) {
            if (tag == 0)
            {
                NSDictionary *jsonDic = [array objectAtIndex:0];
                NSMutableDictionary *dataDic1 = [NSMutableDictionary dictionary];
                [dataDic1 setObject:@"现场勘察情况说明" forKey:@"MBMC"];
                [dataDic1 setObject:[jsonDic objectForKey:@"XCJCCOUNT"] forKey:@"NUM"];
                [self.headeArray addObject:dataDic1];
                NSMutableDictionary *dataDic2 = [NSMutableDictionary dictionary];
                [dataDic2 setObject:@"污染源现场调查询问笔录" forKey:@"MBMC"];
                [dataDic2 setObject:[jsonDic objectForKey:@"XCXWCOUNT"] forKey:@"NUM"];
                [self.headeArray addObject:dataDic2];
                
                NSMutableDictionary *params = [NSMutableDictionary dictionary];
                [params setObject:@"LIST_WRY_ZFBD" forKey:@"service"];
                [params setObject:wrybh forKey:@"WRYBH"];
                [params setObject:@"2" forKey:@"TYPE"];
                NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8086/"  Application:@"platform" Parameters:params];
                self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:parentController.view delegate:self andTag:1];
            }
            else if (tag == 1){
                [self.headeArray addObjectsFromArray:array];
                for (int i=0; i< [self.headeArray count]; i++)
                {
                    NSDictionary *dataDic = [self.headeArray objectAtIndex:i];
                    QQList *list = [[[QQList alloc] init] autorelease];
                    list.m_nID = i; //  分组依据
                    list.m_strGroupName = [NSString stringWithFormat:@"%@:%@",[dataDic objectForKey:@"MBMC"],[dataDic objectForKey:@"NUM"]];
                    list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
                    list.opened = NO;
                    list.indexPaths = [[[NSMutableArray alloc] init] autorelease];
                    [self.lists addObject:list];
                }
            }
            else{
                tag -= 3;
                [self.valueArray removeAllObjects];
                [self.valueArray addObjectsFromArray:array];
                QQList *list = [self.lists objectAtIndex:tag];
                for (int j = 0; j < [self.valueArray count]; j++)
                {
                    NSDictionary *dataDic = [self.valueArray objectAtIndex:j];
                    QQPerson *person = [[[QQPerson alloc] init] autorelease];
                    person.m_nListID = tag; //  分组依据
                    person.m_dataDic = dataDic;
                    person.m_strPersonName = [NSString stringWithFormat:@"现场执法编号:%@",[dataDic objectForKey:@"MBBH"]];
                    person.m_strDept = [NSString stringWithFormat:@"执法时间:%@",[dataDic objectForKey:@"CJSJ"]];
                    [list.m_arrayPersons addObject:person];
                    [list.indexPaths addObject:[NSIndexPath indexPathForRow:j inSection:tag]];
                }
            }
        }
        else{
            NSString *msg = @"请求数据失败，请检查网络。";
            
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"提示"
                                  message:msg
                                  delegate:self
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
            return;
        }
    }
    [displayTableView reloadData];
}

-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败，请检查网络。";
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - Table view data source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.lists.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    QQList *persons = [self.lists objectAtIndex:section];
    if ([persons opened]) {
        return [persons.m_arrayPersons count]; // 人员数
    }else {
        return 0;	// 不展开
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    NSString *Identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:Identifier];
    }
    QQList *header= [self.lists objectAtIndex:indexPath.section];
    QQPerson *person = [header.m_arrayPersons objectAtIndex:indexPath.row];
    cell.textLabel.text = person.m_strPersonName;
    cell.detailTextLabel.text = person.m_strDept;
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if ([self.lists count]) {

    QQList *persons = [self.lists objectAtIndex:section];
    
    QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768, 60)title:persons.m_strGroupName section:section opened:persons.opened delegate:self];
    [sectionHeadView setBackgroundWithPortrait:@"cellBG_type1.png" andLandscape:@"cellBG_type1.png"];
    return [sectionHeadView autorelease];
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QQList *list = [self.lists objectAtIndex:indexPath.section];
    QQPerson *person = [list.m_arrayPersons objectAtIndex:indexPath.row];
    if (indexPath.section < 2) {
        ZFTZChartViewController *chart = [[ZFTZChartViewController alloc]init];
        if (indexPath.section == 0) {
            chart.isExplain = YES;
        }
        else{
            chart.isExplain = NO;
        }
        chart.dataDic = person.m_dataDic;
        chart.wrybm = wrybh;
        [parentController.navigationController pushViewController:chart animated:YES];
    }
    else{
        ZFTZParticularsViewController *particulars = [[ZFTZParticularsViewController alloc]init];
        particulars.wrybm = wrybh;
        particulars.section = indexPath.section;
        particulars.dataDic = person.m_dataDic;
        [parentController.navigationController pushViewController:particulars animated:YES];
        [particulars release];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section{
    QQList *persons = [self.lists objectAtIndex:section];
	persons.opened = !persons.opened;
    
    // 展开+动画 (如果不需要动画直接reloaddata)
    if ([persons.m_arrayPersons count] > 0)
    {
		[displayTableView insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
    NSDictionary *dataDic = [self.headeArray objectAtIndex:section];
    NSInteger number = [[dataDic objectForKey:@"NUM"] intValue];
    QQList *list = [self.lists objectAtIndex:section];
    if (section < 2 && !list.m_arrayPersons.count && number) {
        if (section == 0) {
            self.service = @"QUERY_XCJC_RECORDS";
        }
        else{
            self.service = @"QUERY_ASK_RECORDS";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.service forKey:@"service"];
        [params setObject:wrybh forKey:@"WRYBH"];
        NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:parentController.view delegate:self andTag:2];
    }
    else if (!list.m_arrayPersons.count && number) {
        NSDictionary *dataDic = [self.headeArray objectAtIndex:section];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"LIST_ZFBD_RECORD" forKey:@"service"];
        [params setObject:wrybh forKey:@"WRYBH"];
        [params setObject:[dataDic objectForKey:@"MBBH"] forKey:@"templateId"];
        NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8086/"  Application:@"platform" Parameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:parentController.view delegate:self andTag:section+3];
    }
  
    
}

-(void)sectionHeaderView:(QQSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section{
    QQList *persons = [self.lists objectAtIndex:section];
    persons.opened = !persons.opened;
	
   	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [displayTableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
        [displayTableView deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    parentController.scrollView.contentSize = CGSizeMake(708, 440+self.listTableView.contentSize.height);
//    self.listTableView.frame = CGRectMake(0, 440, 708, self.listTableView.contentSize.height);
}

@end
