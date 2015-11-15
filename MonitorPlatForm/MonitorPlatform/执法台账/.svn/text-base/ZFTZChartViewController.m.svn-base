//
//  ZFTZChartViewController.m
//  MonitorPlatform
//
//  Created by PowerData on 14-4-21.
//  Copyright (c) 2014年 博安达. All rights reserved.
//

#import "ZFTZChartViewController.h"
#import "UITableViewCell+Custom.h"
#import "NSURLConnHelper.h"
#import "JSONKit.h"
#import "ServiceUrlString.h"

@interface ZFTZChartViewController ()<UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate>
@property (nonatomic,retain) NSURLConnHelper *webHelper;
@property (nonatomic,retain) NSMutableArray *valueArray;
@property (nonatomic,retain) NSArray *titleArray;
@property (nonatomic,retain) NSArray *keyArray;
@property (assign) NSInteger count;
@end

@implementation ZFTZChartViewController

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
    if (self.isExplain) {
        self.title = @"现场勘察情况说明";
        self.titleArray = [NSArray arrayWithObjects:@"勘察对象：",@"勘察地点：",@"现场负责人：",@"年龄：",@"身份证号码：",@"工作部门：",@"职务：",@"调查时间：",@"见证人：",@"身份号码：",@"检查人：",@"执法证号：",@"记录人：",@"执法证号：",@"勘察情况说明：", nil];
        self.keyArray = [NSArray arrayWithObjects:@"BJCDWMC",@"JCDD",@"XCFZR",@"FZRNL",@"SFZHM",@"GZBM",@"FZRZW",@"JCSJS",@"JZR",@"JZRSFZHM",@"JCRY",@"ZFZH",@"JLR",@"JLRZFZH",@"WZQKSM", nil];
    }
    else{
        self.title = @"污染源现场调查询问笔录";
        
        self.valueArray = [[NSMutableArray alloc]init];
        
        self.titleArray = [NSArray arrayWithObjects:@"被调查单位：",@"地址：",@"营业执照：",@"法人代表：",@"电话：",@"被询问人：",@"电话：",@"年龄：",@"性别：",@"身份号码：",@"工作部门：",@"职务：",@"调查时间：",@"执法人员：",@"记录人：",@"执法证号：",@"询问地点：", nil];
        self.keyArray = [NSArray arrayWithObjects:@"WRYMC",@"JCDD",@"XCFZR",@"XCFZR",@"XCFZR",@"GZBM",@"FZRZW",@"JCSJS",@"JZR",@"JZRSFZHM",@"JCRY",@"ZFZH",@"JCSJE",@"JCRY",@"JLR",@"JLR",@"JLR", nil];
        
        NSMutableDictionary *paramsCount = [NSMutableDictionary dictionary];
        [paramsCount setObject:@"QUERY_DCXWBL_WD_HISTORY" forKey:@"service"];
        [paramsCount setObject:self.wrybm forKey:@"WRYBH"];
        [paramsCount setObject:@"2" forKey:@"TYPE"];
        NSString *strUrlCount = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:paramsCount];
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrlCount andParentView:self.view delegate:self];
    }
}

-(void)processWebData:(NSData *)webData{
    NSString *jsonStr = [[NSString alloc]initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *jsonDic = [jsonStr objectFromJSONString];
    NSArray *array = [jsonDic objectForKey:@"data"];
    if (array && array.count) {
        for (NSDictionary *dataDic in array) {
            [self.valueArray addObject:[dataDic objectForKey:@"WT"]];
            [self.valueArray addObject:[dataDic objectForKey:@"DA"]];
        }
    }
    [self.tableView reloadData];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.isExplain) {
        return 1;
    }
    else{
        return 2;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.isExplain) {
        return 11;
    }
    else{
        if (section == 0) {
            return 11;
        }
        else{
            return self.valueArray.count;
        }
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.isExplain) {
        UITableViewCell *cell = nil;
        if (indexPath.row == 2){
            NSString *title1 = [self.titleArray objectAtIndex:2];
            NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:2]];
            self.count ++;
            NSString *title2 = [self.titleArray objectAtIndex:3];
            NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:3]];
            self.count ++;
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else if (indexPath.row == 3){
            NSString *title1 = [self.titleArray objectAtIndex:4];
            NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:4]];
            self.count ++;
            NSString *title2 = [self.titleArray objectAtIndex:5];
            NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:5]];
            self.count ++;
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else if (indexPath.row == 4){
            NSString *title1 = [self.titleArray objectAtIndex:6];
            NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:6]];
            self.count ++;
            NSString *title2 = [self.titleArray objectAtIndex:7];
            NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:7]];
            self.count ++;
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else if (indexPath.row == 5){
            NSString *title1 = [self.titleArray objectAtIndex:8];
            NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:8]];
            self.count ++;
            NSString *title2 = [self.titleArray objectAtIndex:9];
            NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:9]];
            self.count ++;
            cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
        }
        else {
            int conut = 0;
            if (indexPath.row > 5) {
                conut = 4;
            }
            NSString *title = [self.titleArray objectAtIndex:indexPath.row + conut];
            NSString *value = [self.dataDic objectForKey:[self.keyArray objectAtIndex:indexPath.row + conut]];
            cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value height:60];
        }
        
        cell.userInteractionEnabled = NO;
        return cell;
    }
    else{
        if (indexPath.section == 0) {
            UITableViewCell *cell = nil;
            if (indexPath.row == 2){
                NSString *title1 = [self.titleArray objectAtIndex:2];
                NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:2]];
                self.count ++;
                NSString *title2 = [self.titleArray objectAtIndex:3];
                NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:3]];
                self.count ++;
                cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
            }
            else if (indexPath.row == 3){
                NSString *title1 = [self.titleArray objectAtIndex:4];
                NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:4]];
                self.count ++;
                NSString *title2 = [self.titleArray objectAtIndex:5];
                NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:5]];
                self.count ++;
                cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
            }
            else if (indexPath.row == 4){
                NSString *title1 = [self.titleArray objectAtIndex:6];
                NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:6]];
                self.count ++;
                NSString *title2 = [self.titleArray objectAtIndex:7];
                NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:7]];
                self.count ++;
                cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
            }
            else if (indexPath.row == 5){
                NSString *title1 = [self.titleArray objectAtIndex:8];
                NSString *value1 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:8]];
                self.count ++;
                NSString *title2 = [self.titleArray objectAtIndex:9];
                NSString *value2 = [self.dataDic objectForKey:[self.keyArray objectAtIndex:9]];
                self.count ++;
                cell = [UITableViewCell makeSubCell:tableView withValue1:title1 value2:title2 value3:value1 value4:value2 height:60];
            }
            else {
                int conut = 0;
                if (indexPath.row > 5) {
                    conut = 4;
                }
                NSString *title = [self.titleArray objectAtIndex:indexPath.row + conut];
                NSString *value = [self.dataDic objectForKey:[self.keyArray objectAtIndex:indexPath.row + conut]];
                cell = [UITableViewCell makeSubCell:tableView withTitle:title value:value height:60];
            }
            
            cell.userInteractionEnabled = NO;
            return cell;
        }
        else{
            NSString *Identifier = @"Cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
            if (cell == nil) {
                cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];
            }
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            cell.textLabel.text = [NSString stringWithFormat:@"     %@",[self.valueArray objectAtIndex:indexPath.row]];
            return cell;
        }
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (self.isExplain) {
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
        headerView.font = [UIFont systemFontOfSize:19.0];
        headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
        headerView.textColor = [UIColor blackColor];
        headerView.text = @"   情况说明";
        return headerView ;
    }
    else{
        UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
        headerView.font = [UIFont systemFontOfSize:19.0];
        headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
        headerView.textColor = [UIColor blackColor];
        if (section == 0) {
            headerView.text = @"   调查信息";
        }
        else{
            headerView.text = @"   询问笔录";
        }
        return headerView;
    }
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setTableView:nil];
    [super viewDidUnload];
}
@end
