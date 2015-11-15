//
//  PollutionSelectVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-8-24.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PollutionSelectVC.h"
#import "UITableViewCell+Custom.h"
#import "GufeiController.h"
#import "WryJbxxController.h"
#import "WryOnlineMonitorConroller.h"
#import "MonitorWarnItemController.h"
#import "DBHelper.h"
#import "WryEntity.h"
#import "ReportListViewController.h"

@implementation PollutionSelectVC

@synthesize dataResultAry,currentTag;
@synthesize status,wordsPopover,wordSelectCtrl;
@synthesize enterCode;

#define zxjc 1
#define wrytz 2
#define jccb 3

- (IBAction)searchBtnPressed:(id)sender
{
    if ([wryNameFie.text length] == 0 && [xzqhFie.text length] == 0 && [jgjbFie.text length] == 0 && [hylxFie.text length] == 0)
    {
        /*
        if (status == zxjc || status == jccb)
        {
            self.dataResultAry = [[DBHelper sharedInstance] queryWrysBySql:@"select WRYBH,WRYMC,DWDZ,XZQH,DLMC,HBJGJB from wry_zxjc a inner join wry_jbxx b on a.QYBH = b.WRYBH"];
        }
        else
        {
            self.dataResultAry = [[DBHelper sharedInstance] queryWrysBySql:@"select WRYBH,WRYMC,DWDZ,XZQH,DLMC,HBJGJB from wry_jbxx"];
        }*/
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"查询条件不能为空" delegate:self cancelButtonTitle:@"取消" otherButtonTitles: nil];
        [alert show];
        [alert release];
        self.dataResultAry = [[DBHelper sharedInstance] queryWrysBySql:@"select WRYBH,WRYMC,WRYJC,DWDZ,XZQH,DLMC,HBJGJB from wry_jbxx where SFQXGL = \'0\'"];
        
        [resultTable reloadData];
        return;
    }
    
    NSMutableString * sqlStr = [NSMutableString stringWithString:@"select WRYBH,WRYMC,WRYJC,DWDZ,XZQH,DLMC,HBJGJB from wry_jbxx where SFQXGL = \'0\'"];
    /*
    if (status == zxjc || status == jccb)
    {
        sqlStr = [NSMutableString stringWithString:@"select WRYBH,WRYMC,DWDZ,XZQH,DLMC,HBJGJB from wry_zxjc a inner join wry_jbxx b on a.QYBH = b.WRYBH where "];
    }
    else
    {
        sqlStr = [NSMutableString stringWithString:@"select WRYBH,WRYMC,DWDZ,XZQH,DLMC,HBJGJB from wry_jbxx where "];
    }*/
    
    if ([wryNameFie.text length] > 0)
    {
        [sqlStr appendFormat:@"and WRYMC like \'%%%@%%\' ",wryNameFie.text];
    }
    
    if ([xzqhFie.text length] > 0)
    {
        [sqlStr appendFormat:@"and XZQH = \'%@\' ",xzqhFie.text];
    }
    
    if ([jgjbFie.text length] > 0)
    {
        if ([jgjbFie.text isEqualToString:@"国控"])
            [sqlStr appendFormat:@"and HBJGJB = \'1\' "];
        else if ([jgjbFie.text isEqualToString:@"省控"])
            [sqlStr appendFormat:@"and HBJGJB = \'2\' "];
        else if ([jgjbFie.text isEqualToString:@"市控"])
            [sqlStr appendFormat:@"and HBJGJB = \'3\' "];
        else
            [sqlStr appendFormat:@"and HBJGJB = \'9\' or HBJGJB = \'\' "];
    }
    
    if ([hylxFie.text length] > 0)
    {
        [sqlStr appendFormat:@"and DLMC = \'%@\'",hylxFie.text];
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    self.dataResultAry = [[DBHelper sharedInstance] queryWrysBySql:sqlStr];
    if(self.dataResultAry.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [resultTable reloadData];
}

- (void)selectWord:(id)sender
{
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    
    UITextField *fie = (UITextField *)sender;
    fie.text = @"";
    currentTag = fie.tag;
    
    switch (currentTag)
    {
        case 2:
            wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"南山区",@"宝安区",@"福田区",@"罗湖区",@"龙岗区",@"盐田区",@"坪山新区",@"光明新区", nil];
            break;    
        case 3:
            wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"国控",@"省控",@"市控",@"非控", nil];
            break;
        case 4:
            wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"工业",@"市政设施",@"医疗机构",@"农业污染源",@"危险废物储存、处理、处置单位",@"饮食娱乐服务业污染源",@"其它", nil];
            break;
        default:
            break;
    }
    [wordSelectCtrl.tableView reloadData];
    [wordsPopover presentPopoverFromRect:[fie bounds] inView:fie permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [dataResultAry release];
    [wordSelectCtrl release];
    [wordsPopover release];
    [super dealloc];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"查询污染源";
    
    //选择短语
    [xzqhFie addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [hylxFie addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [jgjbFie addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:wordSelectCtrl];
    self.wordsPopover = popCtrl;
    [wordCtrl release];
    [popCtrl release];
    
    self.dataResultAry = [[[NSMutableArray alloc] initWithCapacity:1900] autorelease];
    /*在线监测和超标旧代码  
    if (status == zxjc || status == jccb)
        self.dataResultAry = [[DBHelper sharedInstance] queryWrysBySql:@"select WRYBH,WRYMC,WRYJC,DWDZ,XZQH,DLMC,HBJGJB from wry_zxjc a inner join wry_jbxx b on a.QYBH = b.WRYBH"];
    else
        self.dataResultAry = [[DBHelper sharedInstance] queryWrysBySql:@"select WRYBH,WRYMC,WRYJC,DWDZ,XZQH,DLMC,HBJGJB from wry_jbxx"];
     */
    
    self.dataResultAry = [[DBHelper sharedInstance] queryWrysBySql:@"select WRYBH,WRYMC,WRYJC,DWDZ,XZQH,DLMC,HBJGJB from wry_jbxx where SFQXGL = \'0\'"];
    
    if(self.dataResultAry.count == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"暂无数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [resultTable reloadData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Words delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    switch (currentTag)
    {
        case 2:
            xzqhFie.text = words;
            break;
        case 3:
            jgjbFie.text = words;
            break;
        case 4:
            hylxFie.text = words;
            break;
        default:
            break;
    }
    [wordsPopover dismissPopoverAnimated:YES];
}

#pragma mark - Table View Data Source


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataResultAry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    WryEntity *aEntity = [dataResultAry objectAtIndex:indexPath.row];
    
    NSString *hylx = [NSString stringWithFormat:@"行业类型：%@",aEntity.DLMC];
    NSString *xzqh = [NSString stringWithFormat:@"所在区域：%@",aEntity.XZQH];
    NSString *jgjb = [NSString stringWithFormat:@"监管级别：%@",aEntity.HBJGJB];
    NSString *dwdz = [NSString stringWithFormat:@"地址：%@",aEntity.DWDZ];
    
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:aEntity.WRYMC andSubvalue1:dwdz andSubvalue2:hylx andSubvalue3:xzqh  andSubvalue4:jgjb andNoteCount:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WryEntity *aEntity = [dataResultAry objectAtIndex:indexPath.row];
    
    if(enterCode == 12)
    {
        //监测报告
        ReportListViewController *list = [[ReportListViewController alloc] initWithNibName:@"ReportListViewController" bundle:nil];
        list.wrymc = aEntity.WRYMC;
        list.wrybh = aEntity.WRYBH;;
        [self.navigationController pushViewController:list animated:YES];
        [list release];
        return;
    }
    
    if (status == zxjc)
    {
        WryOnlineMonitorConroller *childView = [[[WryOnlineMonitorConroller alloc] initWithNibName:@"WryOnlineMonitorConroller" bundle:nil] autorelease];
        childView.wrybh = aEntity.WRYBH;
        childView.wrymc = aEntity.WRYMC;
        
        [self.navigationController pushViewController:childView animated:YES];
    }
    
    else if (status == wrytz)
    {
        WryJbxxController *childView = [[[WryJbxxController alloc] initWithNibName:@"WryJbxxController" bundle:nil] autorelease];
        childView.wrybh = aEntity.WRYBH;
        childView.wrymc = aEntity.WRYMC;
        childView.wryjc = aEntity.WRYJC;
        
        [self.navigationController pushViewController:childView animated:YES];
    }
    
    else if (status == jccb)
    {
        NSDate *nowDate = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *endDateStr = [dateFormatter stringFromDate:nowDate];
        NSArray *dateAry = [endDateStr componentsSeparatedByString:@"-"];
        NSString *fromDateStr = [NSString stringWithFormat:@"%@-01-01",[dateAry objectAtIndex:0]];
        [dateFormatter release];
        
        MonitorWarnItemController *itemController = [[MonitorWarnItemController alloc] initWithWryBh:aEntity.WRYBH wryMc:aEntity.WRYMC fromDateStr:fromDateStr andEndDateStr:endDateStr];
        itemController.bChooseDate = YES;
        [self.navigationController pushViewController:itemController animated:YES];
        [itemController release];
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end
