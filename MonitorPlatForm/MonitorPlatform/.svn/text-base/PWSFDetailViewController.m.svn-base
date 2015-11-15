//
//  PWSFDetailViewController.m
//  MonitorPlatform
//
//  Created by ihumor on 13-2-26.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "PWSFDetailViewController.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"

@interface PWSFDetailViewController ()

@end

@implementation PWSFDetailViewController

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
    [self requestWebData];
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    if (_webservice)
        [_webservice cancel];
    
    [super viewWillDisappear:animated];
}

- (void)requestWebData{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    if (_type==TYPEKS) {
       
        //科室
        [params setObject:@"COUNT_PWSF_KSRYZJQKTJ_LIST" forKey:@"service"];
        [params setObject:_infoStr forKey:@"zzbh"];
        
    }
    else if(_type == TYPEXZQH){
        
        //行政区划
        [params setObject:@"COUNT_PWSF_XZQHWRYZJQKTJ_LIST" forKey:@"service"];
        [params setObject:_infoStr forKey:@"xzqh"];
    }
    else if(_type == TYPEPERSON){
        
        //科室人员下一层
        [params setObject:@"COUNT_PWSF_KSRYWRYZJQKTJ_LIST" forKey:@"service"];
        [params setObject:_infoStr forKey:@"yhid"];
    }
    else if(_type == xftsTPYE){//信访投诉
        
        [params setObject:@"GET_HJXF_HJXFAKSTJWRY" forKey:@"service"];
        [params setObject:_infoStr forKey:@"bmbh"];
        
    }
    else if(_type == xzcfTPYE){//行政处罚
        
        [params setObject:@"GET_XZCF_XZCFAKSTJ" forKey:@"service"];
        [params setObject:_infoStr forKey:@"cbbm"];
    }
    else if(_type == xzcfPERSON){
        //行政处罚统计到个人
        [params setObject:@"GET_XZCF_XZCFAKSRYTJ" forKey:@"service"];
        [params setObject:_infoStr forKey:@"deptid"];
    }
    if (_type == xftsTPYE||_type == xzcfTPYE||_type== xzcfPERSON) {
        [params setObject:_fromDateStr forKey:@"kssj"];
        [params setObject:_endDateStr forKey:@"jssj"];
    }
    else{
        [params setObject:_fromDateStr forKey:@"startTime"];
        [params setObject:_endDateStr forKey:@"endTime"];
    }
  
    NSString *requestString = nil;
    if (_type == xzcfTPYE||_type == xzcfPERSON) {
        requestString = [ServiceUrlString generateXZCFUrlByParameters:params];
    }
    else{
        requestString = [ServiceUrlString generateUrlByParameters:params];
    }
    
    if (_webservice) {
        [_webservice cancel];
        [_webservice initWithUrl:requestString andParentView:self.view delegate:self];
    }
    else{
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_detailTable release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setDetailTable:nil];
    [super viewDidUnload];
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


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_type == xzcfTPYE||_type==xzcfPERSON) {
        return _infoArr.count-1;
    }
    return _infoArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
 }

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
  
   
        UIView *headerView = [[[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 768.0, 50.0)] autorelease];

    
        NSArray *titleArr;
        if (_type==TYPEKS) {
            titleArr = [NSArray arrayWithObjects:@"人员",@"发单数",@"缴费金额(元)",@"未交金额(元)", nil];
        }
        else if (_type == xftsTPYE){
            titleArr = [NSArray arrayWithObjects:@"污染源名称",@"投诉次数", nil];
        }
        else if(_type == xzcfTPYE){
            titleArr = [NSArray arrayWithObjects:@"部门",@"建议数",@"处罚数",@"处罚金额(万元)",nil];
            
        }
        else if(_type == xzcfPERSON){
            
            titleArr = [NSArray arrayWithObjects:@"人员",@"建议数",@"处罚数",@"处罚金额(万元)",nil];
        }
        else{
            titleArr = [NSArray arrayWithObjects:@"单位名称",@"发单数",@"缴费金额(元)",@"未交金额(元)", nil];
        }
        for (int i = 0; i<titleArr.count; i++) {
            
            UILabel *Lb = [[UILabel alloc] init];
            if (_type == xftsTPYE) {
                Lb.frame = CGRectMake(384.0*i, 0.0, 384.0, 50.0);
            }
            else{
                if (i==0) {
                    Lb.frame = CGRectMake(0.0, 0.0, 250.0, 50.0);
                }
                else{
                    Lb.frame = CGRectMake(250+172.0*(i-1), 0.0, 172.0, 50.0);
                }
            }
            Lb.text = [titleArr objectAtIndex:i];
            Lb.backgroundColor = [UIColor colorWithRed:135.0/255.0 green:153.0/255.0 blue:188.0/255.0 alpha:1.0];
            Lb.textAlignment = UITextAlignmentCenter;
            [headerView addSubview:Lb];
            [Lb release];
        }
        return headerView;

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
    if (_type==TYPEKS) {
        keyArr = [NSArray arrayWithObjects:@"YHMC",@"FDS",@"JFS",@"WJFS", nil];
    }
    else if(_type==xftsTPYE){
        
        keyArr = [NSArray arrayWithObjects:@"BTSDWMC",@"NUM", nil];
    }
    else if(_type == xzcfTPYE){
        
        keyArr = [NSArray arrayWithObjects:@"ZZJC",@"JYS",@"CFS",@"CFJE",nil];
    }
    else if(_type == xzcfPERSON){
        
        keyArr = [NSArray arrayWithObjects:@"YHMC",@"JYS",@"CFS",@"CFJE",nil];
    }
    else{
        keyArr = [NSArray arrayWithObjects:@"WRYMC",@"FDS",@"JFS",@"WJFS", nil];
    }
        for (int i = 0; i<keyArr.count; i++) {
            UILabel *Lb = [[UILabel alloc] init];
            if (_type == xftsTPYE) {
                
                Lb.frame = CGRectMake(384.0*i, 0.0, 384.0, 50.0);
            }
            else{
                if (i==0) {
                    Lb.frame = CGRectMake(0.0, 0.0, 250.0, 50.0);
                    Lb.numberOfLines = 0;
                }
                else{
                    Lb.frame = CGRectMake(250+172.0*(i-1), 0.0, 172.0, 50.0);
                }

            }
            
            NSString *key = [keyArr objectAtIndex:i];
            NSDictionary *dic = [_infoArr objectAtIndex:indexPath.row];
            Lb.text = [self formatterNumberWithDic:dic AndKey:key];
            Lb.tag = 10;
            Lb.font = [UIFont systemFontOfSize:20.0];
            Lb.textAlignment = UITextAlignmentCenter;
            Lb.backgroundColor = [UIColor clearColor];
            [cell addSubview:Lb];
            [Lb release];
        }
    
    if (_type == TYPEKS ||_type == xzcfTPYE) {
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_type == TYPEKS) {
        NSDictionary *dic = [_infoArr objectAtIndex:indexPath.row];
        PWSFDetailViewController *detail = [[PWSFDetailViewController alloc] initWithNibName:@"PWSFDetailViewController" bundle:nil];
        detail.infoStr = [dic objectForKey:@"YHID"];
        detail.type = TYPEPERSON;
        detail.fromDateStr = _fromDateStr;
        detail.endDateStr = _endDateStr;
        detail.title = [NSString stringWithFormat:@"%@(%@~%@)",[dic objectForKey:@"YHMC"],_fromDateStr,_endDateStr];
        if (detail.infoStr == nil) {
            [detail release];
            return;
        }
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];
    }
    
    if (_type == xzcfTPYE) {
        NSDictionary *dic = [_infoArr objectAtIndex:indexPath.row];
        PWSFDetailViewController *detail = [[PWSFDetailViewController alloc] initWithNibName:@"PWSFDetailViewController" bundle:nil];
        detail.infoStr = [dic objectForKey:@"ZZBH"];
        detail.type = xzcfPERSON;
        detail.fromDateStr = _fromDateStr;
        detail.endDateStr = _endDateStr;
        detail.title = [NSString stringWithFormat:@"%@(%@~%@)",[dic objectForKey:@"ZZJC"],_fromDateStr,_endDateStr];
        if (detail.infoStr == nil) {
            [detail release];
            return;
        }
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];

    }
}

#pragma mark - NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    
    NSArray *receiveArr = [resultJSON objectFromJSONString];
    if (receiveArr.count==0) {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取不到数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    NSDictionary *dic = [receiveArr objectAtIndex:0];
    NSArray *keyArr = [dic allKeys];
    if ([keyArr containsObject:@"COUNT"]) {
        return;
    }
    
    if (_type == xftsTPYE)
    {
        NSMutableArray *resultAry = [NSMutableArray arrayWithArray:receiveArr];
        int count = 0;
        for (NSDictionary *tmpDic in receiveArr)
        {
            count += [[tmpDic objectForKey:@"NUM"] intValue];
        }
        NSMutableDictionary *totalDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [totalDic setObject:[NSString stringWithFormat:@"%d",count] forKey:@"NUM"];
        [totalDic setObject:@"汇总" forKey:@"BTSDWMC"];
        [resultAry addObject:[totalDic copy]];
        
        self.infoArr = [resultAry copy];
    }
    else
        self.infoArr = receiveArr;
    [_detailTable reloadData];
    
    
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
