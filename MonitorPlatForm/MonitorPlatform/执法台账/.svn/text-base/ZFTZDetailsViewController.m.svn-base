//
//  ZFTZDetailsViewController.m
//  MonitorPlatform
//
//  Created by PowerData on 14-4-17.
//  Copyright (c) 2014年 博安达. All rights reserved.
//

#import "ZFTZDetailsViewController.h"
#import "UITableViewCell+Custom.h"
#import "QQSectionHeaderView.h"
#import "QQList.h"
#import "ServiceUrlString.h"
#import "NSURLConnHelper.h"
#import "JSONKit.h"
#import "ZFTZParticularsViewController.h"
#import "ZFTZChartViewController.h"

@interface ZFTZDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,QQSectionHeaderViewDelegate,NSURLConnHelperDelegate>
@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,strong) NSArray *titleArray;
@property (nonatomic,strong) NSArray *keyArray;
@property (nonatomic,strong) NSMutableArray *headeArray;
@property (nonatomic,strong) NSMutableArray *valueArray;
@property (nonatomic,copy) NSString *service;

@property (nonatomic,strong) NSMutableArray *lists;
@end

@implementation ZFTZDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (self.webHelper) {
        [self.webHelper cancel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = [self.dataDic objectForKey:@"TITLE"];
    self.titleArray = [NSArray arrayWithObjects:@"污染源编号：",@"污染源名称：",@"污染源地址：",@"法人代表：",@"联系电话：",@"环保联系人：",@"环保人联系电话：",@"环保人联系地址", nil];
    self.keyArray = [NSArray arrayWithObjects:@"WRYBH",@"WRYMC",@"DWDZ",@"FRDB",@"TIME",@"REMARK",@"FRDBLXDH",@"DESCRIPTION", nil];

    self.lists = [NSMutableArray array];
    self.valueArray = [NSMutableArray array];
    self.headeArray = [NSMutableArray array];
 
    NSMutableDictionary *paramsCount = [NSMutableDictionary dictionary];
    [paramsCount setObject:@"QUERY_WRYGTBD_COUNT" forKey:@"service"];
    [paramsCount setObject:[self.dataDic objectForKey:@"WRYBH"] forKey:@"WRYBH"];
    [paramsCount setObject:@"2" forKey:@"TYPE"];
    NSString *strUrlCount = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:paramsCount];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrlCount andParentView:self.view delegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)processWebData:(NSData *)webData andTag:(NSInteger)tag{
    NSString *jsonStr = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    if (tag == 2){
        NSDictionary *jsonDic = [jsonStr objectFromJSONString];
        [self.valueArray removeAllObjects];
        [self.valueArray addObjectsFromArray:[jsonDic objectForKey:@"data"]];
        QQList *list = nil;
        NSString *timeKey = nil;
        NSInteger dataTag = 0;
        if ([self.service isEqualToString:@"QUERY_XCJC_RECORDS"]) {
            list = [self.lists objectAtIndex:1];
            dataTag = 1;
            timeKey = @"JCSJS";
        }
        else{
            list = [self.lists objectAtIndex:2];
            dataTag = 2;
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
                [self.headeArray addObject:self.dataDic];
                
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
                [params setObject:[self.dataDic objectForKey:@"WRYBH"] forKey:@"WRYBH"];
                [params setObject:@"2" forKey:@"TYPE"];
                
                NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8086/"  Application:@"platform" Parameters:params];
                self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self andTag:1];
            }
            else if (tag == 1){
                
                [self.headeArray addObjectsFromArray:array];
                for (int i = 0; i < [self.headeArray count]; i++) {
                    NSDictionary *dataDic = [self.headeArray objectAtIndex:i];
                    QQList *list = [[[QQList alloc] init] autorelease];
                    list.m_nID = i + 1; //  分组依据
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
    [self.tableView reloadData];
}

- (void)processError:(NSError *)error{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
        return self.lists.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section > 0) {
        QQList *persons = [self.lists objectAtIndex:section];
        if ([persons opened]) {
            return [persons.m_arrayPersons count]; // 人员数
        }else {
            return 0;	// 不展开
        }
    }
    else{
        return self.titleArray.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section > 0)
    {
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
    else{
        NSString *title = [self.titleArray objectAtIndex:indexPath.row];
        NSString *value = [self.dataDic objectForKey:[self.keyArray objectAtIndex:indexPath.row]];
        if (indexPath.row == 4){
            value = [value substringFromIndex:3];
        }
        else if (indexPath.row == 5){
            value = [value substringFromIndex:6];
        }
        UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value height:60];
        cell.userInteractionEnabled = NO;
        return cell;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section > 0)
    {
        QQList *persons = [self.lists objectAtIndex:section];
        
        QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] initWithFrame:CGRectMake(0.0, 0.0, self.tableView.bounds.size.width, 44)title:persons.m_strGroupName section:section opened:persons.opened delegate:self];
        [sectionHeadView setBackgroundWithPortrait:@"cellBG_type1.png" andLandscape:@"cellBG_type1.png"];
        return [sectionHeadView autorelease];
    }
    else{
       
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
        headerView.font = [UIFont systemFontOfSize:19.0];
        headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
        headerView.textColor = [UIColor blackColor];
        headerView.text= @"  基本信息";
        return headerView ;
    
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 0) {
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
        headerView.font = [UIFont systemFontOfSize:19.0];
        headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
        headerView.textColor = [UIColor blackColor];
        headerView.text= @"  执法笔录";
        return headerView ;
    }
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 44;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    QQList *list = [self.lists objectAtIndex:indexPath.section];
    QQPerson *person = [list.m_arrayPersons objectAtIndex:indexPath.row];
    if (indexPath.section < 3 && indexPath.section != 0) {
        ZFTZChartViewController *chart = [[ZFTZChartViewController alloc]init];
        if (indexPath.section == 1) {
            chart.isExplain = YES;
        }
        else{
            chart.isExplain = NO;
        }
        chart.dataDic = person.m_dataDic;
        chart.wrybm = [self.dataDic objectForKey:@"WRYBH"];
        [self.navigationController pushViewController:chart animated:YES];
    }
    else{
        ZFTZParticularsViewController *particulars = [[ZFTZParticularsViewController alloc]init];
        particulars.wrybm = [self.dataDic objectForKey:@"WRYBH"];
        particulars.section = indexPath.section;
        particulars.dataDic = person.m_dataDic;
        particulars.title = self.title;
        [self.navigationController pushViewController:particulars animated:YES];
        [particulars release];
    }
}

-(void)sectionHeaderView:(QQSectionHeaderView *)sectionHeaderView sectionOpened:(NSInteger)section{
    QQList *persons = [self.lists objectAtIndex:section];
	persons.opened = !persons.opened;
	
	// 展开+动画 (如果不需要动画直接reloaddata)
    if ([persons.m_arrayPersons count] > 0)
    {
		[self.tableView insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
    NSDictionary *dataDic = [self.headeArray objectAtIndex:section];
    NSInteger number = [[dataDic objectForKey:@"NUM"] intValue];
    QQList *list = [self.lists objectAtIndex:section];
    if (section < 3 && !list.m_arrayPersons.count && number) {
        if (section == 1) {
            self.service = @"QUERY_XCJC_RECORDS";
        }
        else{
            self.service = @"QUERY_ASK_RECORDS";
        }
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:self.service forKey:@"service"];
        [params setObject:[self.dataDic objectForKey:@"WRYBH"] forKey:@"WRYBH"];
        NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self andTag:2];
    }
    else if (!list.m_arrayPersons.count && number) {
        NSDictionary *dataDic = [self.headeArray objectAtIndex:section];
        NSMutableDictionary *params = [NSMutableDictionary dictionary];
        [params setObject:@"LIST_ZFBD_RECORD" forKey:@"service"];
        [params setObject:[self.dataDic objectForKey:@"WRYBH"] forKey:@"WRYBH"];
        [params setObject:[dataDic objectForKey:@"MBBH"] forKey:@"templateId"];
        NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8086/"  Application:@"platform" Parameters:params];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self andTag:section+3];
    }

}

-(void)sectionHeaderView:(QQSectionHeaderView *)sectionHeaderView sectionClosed:(NSInteger)section{
    QQList *persons = [self.lists objectAtIndex:section];
    persons.opened = !persons.opened;
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [self.tableView numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0)
    {
		
        [self.tableView deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
  }

//-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    self.scrollView.contentSize = CGSizeMake(708, 440+self.listTableView.contentSize.height);
//    self.listTableView.frame = CGRectMake(0, 440, 708, self.listTableView.contentSize.height);
//}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
