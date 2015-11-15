//
//  PWSFViewController.m
//  MonitorPlatform
//
//  Created by ihumor on 13-2-25.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "PWSFViewController.h"
#import "ServiceUrlString.h"
#import "NSDateUtil.h"
#import "JSONKit.h"
#import "PWSFDetailViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface PWSFViewController ()

@end

@implementation PWSFViewController
@synthesize popController,dateController,webservice;

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
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"statisticBG2.png"]];

    _detailTable.layer.cornerRadius = 5.0;
    _headTable.layer.cornerRadius = 5.0;
    
    self.fromDateStr = [NSDateUtil firstDateThisYear];
    self.endDateStr = [NSDateUtil todayDateStringWithFMT:@"yyyy-MM-dd"];
     self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] autorelease];
    
    NSArray *itemArr = nil;
    if (_statisticType == TYPEPWSF1) {
        itemArr = [NSArray arrayWithObjects:@"收费情况统计",@"征缴情况统计", nil];
         self.title = [NSString stringWithFormat:@"排污收费统计(%@~%@)",_fromDateStr,_endDateStr];
    }
    else if(_statisticType == TYPEXFTS){
        
        itemArr = [NSArray arrayWithObjects:@"受理立案情况统计",@"按类型统计", nil];
        self.title = [NSString stringWithFormat:@"信访投诉统计(%@~%@)",_fromDateStr,_endDateStr];
        
        _detailTable.hidden = YES;
        _headTable.frame = CGRectMake(10.0, 50.0, 748.0, 900.0);
         
    }
    else if(_statisticType == TYPEXZCF1){
        
        itemArr = [NSArray arrayWithObjects:@"总体统计",@"按违法类型统计", nil];
         self.title = [NSString stringWithFormat:@"行政处罚统计(%@~%@)",_fromDateStr,_endDateStr];
        _detailTable.hidden = YES;
        _headTable.frame = CGRectMake(10.0, 50.0, 748.0, 900.0);
    }
    typeSeg = [[UISegmentedControl alloc] initWithItems:itemArr];
    [typeSeg setFrame:CGRectMake(209.0, 5, 350.0,40.0)];
    typeSeg.segmentedControlStyle = UISegmentedControlStyleBar;
    if (isZJQKTJ) {
        [typeSeg setSelectedSegmentIndex:1];
    }
    else{
        [typeSeg setSelectedSegmentIndex:0];
    }
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],UITextAttributeFont,nil];
    
    [typeSeg setTitleTextAttributes:dic forState:UIControlStateNormal];
    [typeSeg addTarget:self action:@selector(chooseType:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:typeSeg];
    [typeSeg release];
    
    ChooseDateRangeController *date = [[ChooseDateRangeController alloc] init];
	self.dateController = date;
	dateController.delegate = self;
	[date release];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popover release];
	[nav release];
    [self requestHeaderWebData];
}

#pragma mark - Private methods

-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)requestHeaderWebData{
  
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];

    NSString *requestString = nil;
    if (_statisticType == TYPEPWSF1) {
        
        if (!isZJQKTJ) {
            [params setObject:@"COUNT_PWSF_QSSBJSFQKTJ_LIST" forKey:@"service"];
        }
        else{
            [params setObject:@"COUNT_PWSF_QSSBJZJQKTJ_LIST" forKey:@"service"];
        }
        [params setObject:_fromDateStr forKey:@"startTime"];
        [params setObject:_endDateStr forKey:@"endTime"];
        requestString = [ServiceUrlString generateUrlByParameters:params];
    }
    else if(_statisticType == TYPEXFTS){
        
        if (!isZJQKTJ) {
            [params setObject:@"GET_HJXF_HJXFAKSTJ" forKey:@"service"];
        }
        else{
            [params setObject:@"GET_HJXF_HJXFALXTJ" forKey:@"service"];
        }
        [params setObject:_fromDateStr forKey:@"kssj"];
        [params setObject:_endDateStr forKey:@"jssj"];
        requestString = [ServiceUrlString generateUrlByParameters:params];
    }
    else if(_statisticType == TYPEXZCF1){
        
        if (!isZJQKTJ) {
            [params setObject:@"GET_XZCF_XZCFAZTTJ" forKey:@"service"];
        }
        else{
            [params setObject:@"GET_XZCF_XZCFAWFLX" forKey:@"service"];
        }
        [params setObject:_fromDateStr forKey:@"kssj"];
        [params setObject:_endDateStr forKey:@"jssj"];
        requestString = [ServiceUrlString generateXZCFUrlByParameters:params];
        //NSLog(@"%@",requestString);
    }
    curRequestType = GETHEADER;
    if (webservice) {
        [webservice cancel];
        [webservice initWithUrl:requestString andParentView:self.view delegate:self];
    }
    else{
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    }
}

- (void)requestDetailWebDate:(NSString *)type{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    
    if (!isZJQKTJ) {
        [params setObject:@"COUNT_PWSF_GPWLXSFQKTJ_LIST" forKey:@"service"];
        [params setObject:type forKey:@"type"];
    }
    else{
        if (![type integerValue]) {
            [params setObject:@"COUNT_PWSF_XZQHZJQKTJ_LIST" forKey:@"service"];
        }
        else{
            [params setObject:@"COUNT_PWSF_KSZJQKTJ_LIST" forKey:@"service"];
        }
    }
    [params setObject:_fromDateStr forKey:@"startTime"];
    [params setObject:_endDateStr forKey:@"endTime"];
    NSString *requestString = [ServiceUrlString generateUrlByParameters:params];
    curRequestType = GETDETAIL;
    
    if (webservice) {
        [webservice cancel];
        [webservice initWithUrl:requestString andParentView:self.view delegate:self];
    }
    else{
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    }


}

- (void)chooseType:(UISegmentedControl *)seg{
    
    int curSelect = seg.selectedSegmentIndex;
    if (curSelect==0) {
        isZJQKTJ = NO;
        
    }
    else{
        isZJQKTJ = YES;
    }
    [self requestHeaderWebData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    if (webservice)
        [webservice cancel];
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == TYPEHEAD) {
        
        if (_statisticType == TYPEXZCF1) {
            return _headerArr.count-1;
        }
        return _headerArr.count;
    }
    return _detailArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag == TYPEDETAIL) {
        return @"具体详情";
    }
    else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView.tag == TYPEHEAD) {
         return 50;
    }
    else{
        return 40;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    if (tableView.tag==TYPEHEAD) {
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 748.0, 50.0)] autorelease];
        headerView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"table_bg.png"]];
        
        NSArray *titleArr = nil;
        if (_statisticType == TYPEPWSF1) {
            if (!isZJQKTJ) {
                titleArr = [NSArray arrayWithObjects:@"类型",@"收费金额(元)",@"上年同期(元)",@"同比增长", nil];
            }
            else{
                titleArr = [NSArray arrayWithObjects:@"类型",@"发单数",@"缴费金额(元)",@"未交金额(元)", nil];
            }
        }
        else if(_statisticType == TYPEXFTS) {
            if (!isZJQKTJ) {
                titleArr = [NSArray arrayWithObjects:@"承办单位",@"受理数",@"立案数",@"去年同期受理数",@"去年同期立案数", nil];

            }
            else{
                titleArr = [NSArray arrayWithObjects:@"案件类型",@"投诉案件数量",@"占总数百分比",@"同期案件数量",@"同比增长", nil];
            }
        }
        else if(_statisticType == TYPEXZCF1) {
            
            if (!isZJQKTJ) {
                titleArr = [NSArray arrayWithObjects:@"单位",@"建议数",@"不予立案",@"正在办理",@"处罚数",@"处罚金额(万元)", nil];
            }
            else{
                titleArr = [NSArray arrayWithObjects:@"类型",@"建议数",@"不予立案",@"正在办理",@"处罚数",@"处罚金额(万元)", nil];
            }
            
        }

        for (int i = 0; i<titleArr.count; i++) {
            UILabel *Lb = [[UILabel alloc] initWithFrame:CGRectMake((748.0/titleArr.count)*i, 0.0, (748.0/titleArr.count), 50.0)];
            Lb.text = [titleArr objectAtIndex:i];
            Lb.backgroundColor = [UIColor clearColor];
            Lb.textAlignment = UITextAlignmentCenter;
            [headerView addSubview:Lb];
            [Lb release];
        }
        
        return headerView;
    }
    return nil;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell_PWSF_List";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    for (UIView *view in cell.subviews) {
        if (view.tag == 10) {
            [view removeFromSuperview];
        }
    }
    NSArray *keyArr = nil;
    if (_statisticType == TYPEPWSF1) {
        if (!isZJQKTJ) {
            keyArr = [NSArray arrayWithObjects:@"LX",@"SFS",@"SNTQS",@"TBBFS", nil];
        }
        else{
            keyArr = [NSArray arrayWithObjects:@"LX",@"FDS",@"JFS",@"WJFS", nil];
        }
        
    }
    else if(_statisticType == TYPEXFTS){
        
        if (!isZJQKTJ) {
            keyArr = [NSArray arrayWithObjects:@"ZZJC",@"SLS",@"LAS",@"QNSLS",@"QNLAS", nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            keyArr = [NSArray arrayWithObjects:@"DMNR",@"ZS",@"",@"SNZS",@"", nil];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    else if(_statisticType == TYPEXZCF1){
        
        if (!isZJQKTJ) {
            keyArr = [NSArray arrayWithObjects:@"ZZJC",@"JYS",@"BYLAS",@"ZZBLS",@"CFS",@"CFJE", nil];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            if (indexPath.row == _headerArr.count-2) {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        else{
            keyArr = [NSArray arrayWithObjects:@"DMNR",@"JYS",@"BYLAS",@"ZZBLS",@"CFS",@"CFJE", nil];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
        
    }
    
    
    if (tableView.tag == TYPEHEAD) {
        
        for (int i = 0; i<keyArr.count; i++) {
            UILabel *Lb = [[UILabel alloc] initWithFrame:CGRectMake((748.0/keyArr.count)*i, 0.0, 748.0/keyArr.count, 50.0)];
            NSString *key = [keyArr objectAtIndex:i];
            NSDictionary *dic = [_headerArr objectAtIndex:indexPath.row];
            
            if (![key isEqualToString:@""]) {
                                          
                Lb.text = [self formatterNumberWithDic:dic AndKey:key];
               
            }
            else{
                
                if (_statisticType == TYPEXFTS) {
                    float zs = [[dic objectForKey:@"ZS"] floatValue];
                    float snzs = [[dic objectForKey:@"SNZS"] floatValue];
                    
                    if (i==2) {
                        //占总量百分比
                        float zsCount = 0.0;
                        for (int j = 0; j<_headerArr.count-1; j++) {
                            zsCount = zsCount + [[[_headerArr objectAtIndex:j] objectForKey:@"ZS"] floatValue];
                        }
                        
                        if ((int)zsCount == 0) {
                            Lb.text = @"0.00%";
                        }
                        else{
                            double zsb = (zs*1.0/zsCount*1.0)*100.0;
                            Lb.text = [NSString stringWithFormat:@"%0.2lf%%",zsb];
                        }
                    
                    }
                    else if(i==4){
                        //同比
                        
                        if ((int)snzs == 0) {
                            Lb.text = @"0.00%";
                        }
                        else{
                             Lb.text = [NSString stringWithFormat:@"%0.2f%%",((zs-snzs)/snzs)*100.0];
                        }
                       
                    }
                    
                }
                else if(_statisticType == TYPEXZCF1){
                    
                    Lb.text = @"市本级";
                }
                
            }
            Lb.tag = 10;
            Lb.textAlignment = UITextAlignmentCenter;
            Lb.backgroundColor = [UIColor clearColor];
            Lb.numberOfLines = 0;
            [cell addSubview:Lb];
            [Lb release];
        }
    }
    else if(tableView.tag == TYPEDETAIL){
        
        
        if (isZJQKTJ) {
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else{
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.accessoryType = UITableViewCellAccessoryNone;
            
        }
        
        NSDictionary *dic = [_detailArr objectAtIndex:indexPath.row];
        NSString *typeStr = @"ORGMC";
        
        if (isZJQKTJ) {
            NSString *str = [dic objectForKey:typeStr];
            if (str == nil) {
                typeStr = @"ZZJC";
            }
        }
        for (int i = 0; i<4; i++) {
            UILabel *Lb = [[UILabel alloc] initWithFrame:CGRectMake(187.0*i, 0.0, 187.0, 50.0)];
            NSString *key = [keyArr objectAtIndex:i];
            if (isZJQKTJ&&i==0) {
                NSString *deptName = [NSString stringWithFormat:@"%@",[dic objectForKey:typeStr]];
                if ([deptName isEqualToString:@"深圳市人居环境委员会"])
                    deptName = @"深圳市环境监察支队";
                Lb.text = deptName;
            }
            else{
                
                Lb.text = [self formatterNumberWithDic:dic AndKey:key];
            }
            Lb.backgroundColor = [UIColor clearColor];
            Lb.tag = 10;
            Lb.font = [UIFont systemFontOfSize:17.0];
            Lb.textAlignment = UITextAlignmentCenter;
            Lb.numberOfLines = 0;
            [cell addSubview:Lb];
            [Lb release];
        }
        
    }
    cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:187.0/255.0 blue:224.0/255.0 alpha:1.0];
    return cell;


}

#pragma mark - 规范格式化数字 添加“,”号

- (NSString *)formatterNumberWithDic:(NSDictionary *)dic AndKey:(NSString *)key{
    
    NSString *str = nil;
    id  object = [dic objectForKey:key];
    if ([object isKindOfClass:[NSNumber class]]) {
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        str = [formatter stringFromNumber:object];
        [formatter release];
    }
    else{
        str = [NSString stringWithFormat:@"%@",[dic objectForKey:key]];
    }

    return str;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == TYPEHEAD) {
         NSDictionary *dic = [_headerArr objectAtIndex:indexPath.row];
        if (_statisticType == TYPEPWSF1) {
            //排污收费统计
            int type = -1;
            if ([[dic objectForKey:@"LX"] isEqualToString:@"全市"]) {
                type = 0;
            }
            else if([[dic objectForKey:@"LX"] isEqualToString:@"市本级"]){
                
                type = 1;
            }
            
            if (type!=-1) {
                [self requestDetailWebDate:[NSString stringWithFormat:@"%i",type]];
            }

        }
        else if (_statisticType == TYPEXFTS){
            //信访投诉统计
            if (!isZJQKTJ) {
                PWSFDetailViewController *detail = [[PWSFDetailViewController alloc] initWithNibName:@"PWSFDetailViewController" bundle:nil];
                detail.type = 103;
                detail.fromDateStr = _fromDateStr;
                detail.endDateStr = _endDateStr;
                detail.infoStr = [dic objectForKey:@"ZZBH"];
                detail.title = [NSString stringWithFormat:@"%@(%@~%@)",[dic objectForKey:@"ZZJC"],_fromDateStr,_endDateStr];
                [self.navigationController pushViewController:detail animated:YES];
                [detail release];
                return;
            }
            
        }
        else if(_statisticType == TYPEXZCF1){
            //行政处罚统计
            if (indexPath.row == _headerArr.count-2) {
                return;
            }
            if (!isZJQKTJ) {
                PWSFDetailViewController *detail = [[PWSFDetailViewController alloc] initWithNibName:@"PWSFDetailViewController" bundle:nil];
                detail.type = 104;
                detail.fromDateStr = _fromDateStr;
                detail.endDateStr = _endDateStr;
                detail.infoStr = [dic objectForKey:@"ZZBH"];
                detail.title = [NSString stringWithFormat:@"%@(%@~%@)",[dic objectForKey:@"ZZJC"],_fromDateStr,_endDateStr];
                [self.navigationController pushViewController:detail animated:YES];
                [detail release];
                return;
            }

            
        }
    }
    if (tableView.tag == TYPEDETAIL) {
        if (isZJQKTJ) {
            NSDictionary *dic = [_detailArr objectAtIndex:indexPath.row];
            NSString *typeStr = @"ORGMC";
            int type = 100;
            NSString *str = [dic objectForKey:typeStr];
            if (str==nil) {
                type = 101;
            }
            
            PWSFDetailViewController *detail = [[PWSFDetailViewController alloc] initWithNibName:@"PWSFDetailViewController" bundle:nil];
            detail.type = type;
            detail.fromDateStr = _fromDateStr;
            detail.endDateStr = _endDateStr;
            if (type==100) {
                
                //行政编号
                detail.infoStr = [dic objectForKey:@"ORGID"];
              
                NSString *name = [dic objectForKey:@"ORGMC"];
                if ([name isEqualToString:@"深圳市人居环境委员会"])
                    name = @"深圳市环境监察支队";
                detail.title = [NSString stringWithFormat:@"%@(%@~%@)",name,_fromDateStr,_endDateStr];
            }
            else{
                //科室标号
                detail.infoStr = [dic objectForKey:@"ZZBH"];
                detail.title = [NSString stringWithFormat:@"%@(%@~%@)",[dic objectForKey:@"ZZJC"],_fromDateStr,_endDateStr];
            }
            if (detail.infoStr == nil) {
                [detail release];
                return;
            }

            [self.navigationController pushViewController:detail animated:YES];
            [detail release];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_headTable release];
    [_detailTable release];
    [_headerArr release];
    [_detailArr release];
    [_fromDateStr release];
    [_endDateStr release];
    [popController release];;
    [dateController release];
    [super dealloc];
}

- (void)viewDidUnload {
    [self setFromDateStr:nil];
    [self setEndDateStr:nil];
    [self setPopController:nil];
    [self setDateController:nil];
    [self setHeaderArr:nil];
    [self setDetailArr:nil];
    [self setHeadTable:nil];
    [self setDetailTable:nil];
    [super viewDidUnload];
}

#pragma mark - Choose date range

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    
    if (_statisticType == TYPEPWSF1) {
        self.title = [NSString stringWithFormat:@"排污收费统计(%@~%@)",_fromDateStr,_endDateStr];
    }
    else if(_statisticType == TYPEXFTS){
        self.title = [NSString stringWithFormat:@"信访投诉统计(%@~%@)",_fromDateStr,_endDateStr];
        
    }
    else if(_statisticType == TYPEXZCF1){
        self.title = [NSString stringWithFormat:@"行政处罚统计(%@~%@)",_fromDateStr,_endDateStr];
    }
    [self requestHeaderWebData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

#pragma mark - NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    
    //异常处理
    NSRange range = [resultJSON rangeOfString:@"exception"];
    if (range.length>0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"数据异常!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;

    }
    NSArray * receiveArr = [resultJSON objectFromJSONString];
    
    if (receiveArr.count==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相关数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
        self.headerArr = [NSMutableArray arrayWithCapacity:0];
        [_headTable reloadData];
        
        self.detailArr = [NSMutableArray arrayWithCapacity:0];
        [_detailTable reloadData];
        
        return;
    }
    if (receiveArr.count == 1) {
        NSDictionary *dic = [receiveArr objectAtIndex:0];
        if ([dic objectForKey:@"COUNT"]!=nil) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有相关数据!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            self.headerArr = [NSMutableArray arrayWithCapacity:0];
            [_headTable reloadData];
            
            self.detailArr = [NSMutableArray arrayWithCapacity:0];
            [_detailTable reloadData];
            return;
        }
    }
    if (_statisticType == TYPEPWSF1) {
        
        if (curRequestType == GETHEADER) {
          
            self.headerArr = receiveArr;
            [_headTable reloadData];
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            [_headTable selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:_headTable didSelectRowAtIndexPath:indexPath];
        }
        else if(curRequestType == GETDETAIL){
        
            self.detailArr = receiveArr;
            [_detailTable reloadData];
        }

    }
    else if(_statisticType == TYPEXFTS){
   
        if (!isZJQKTJ) {
            self.headerArr = receiveArr;
            //{"SLS":2,"LAS":2,"QNSLS":1227,"QNLAS":1227,"ZZBH":"0404","ZZJC":"信访科","SJZZXH":"04"}
            
            for(NSDictionary *item in receiveArr){
                
            }
            [_headTable reloadData];
        }
        else{
            NSMutableArray *tmpAry = [NSMutableArray arrayWithCapacity:10];
            int zsCount = 0;
            int snzsCount = 0;
            for (NSDictionary *aDic in receiveArr)
            {
                [tmpAry addObject:[aDic copy]];
                int zs = [[aDic objectForKey:@"ZS"] intValue];
                int snzs = [[aDic objectForKey:@"SNZS"] intValue];
                zsCount += zs;
                snzsCount += snzs;
            }
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:5];
            [tmpDic setObject:@"汇总" forKey:@"DMNR"];
            [tmpDic setObject:@"999" forKey:@"TSXZDM"];
            [tmpDic setObject:@"999" forKey:@"PXH"];
            [tmpDic setObject:[NSNumber numberWithInt:zsCount] forKey:@"ZS"];
            [tmpDic setObject:[NSNumber numberWithInt:snzsCount] forKey:@"SNZS"];
            
            [tmpAry addObject:[tmpDic copy]];
            
            
            self.headerArr = tmpAry;
            _detailTable.hidden = YES;
            _headTable.frame = CGRectMake(10.0, 50.0, 748.0, 900.0);
            [_headTable reloadData];
        }
        
    }
    else if (_statisticType == TYPEXZCF1){
        
        if (!isZJQKTJ) {
            self.headerArr = receiveArr;
            [_headTable reloadData];
        }
        else{
            self.headerArr = receiveArr;
            _detailTable.hidden = YES;
            _headTable.frame = CGRectMake(10.0, 50.0, 748.0, 900.0);
            [_headTable reloadData];
        }

    }
}

- (void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"请求数据失败,请检查网络连接并重试。"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

@end
