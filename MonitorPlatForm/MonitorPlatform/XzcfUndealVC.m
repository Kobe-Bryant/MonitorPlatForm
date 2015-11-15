//
//  XzcfUndealVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-11-30.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "XzcfUndealVC.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "ZrsUtils.h"
#import "DonePunishDetailController.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
extern MPAppDelegate *g_appDelegate;

@interface XzcfUndealVC ()
@property (nonatomic,strong) NSURLConnHelper *webservice;
@property (nonatomic,strong) NSArray *punishArray;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property(nonatomic,assign) BOOL findTag;
@end

@implementation XzcfUndealVC
@synthesize webservice,yhid,fromStr,endStr;
@synthesize punishArray,webHelper;
@synthesize findTag,curParsedData;
#pragma mark - Private methods

- (void)getWebData
{
    if (_type==TYPEXCZF||_type==TYPEPWSF||_type==TYPEYJ) {
        [self requestDataWithDate];
        return;
    }
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    [param setObject:@"GET_XZCF_XZCFTJWWCSL" forKey:@"service"];
    
    [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
    [param setObject:fromStr forKey:@"kssj"];
    [param setObject:endStr forKey:@"jssj"];
    [param setObject:yhid forKey:@"slr"];
    
    
    NSString *requestString = [ServiceUrlString generateUrlByParameters:param];
    
    self. webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
}


-(void)requestDataWithDate{
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"StartDate" value:fromStr,
                       @"EndDate",endStr,@"UserName",yhid,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    NSString *mathod = nil;
    
    switch (_type) {
        case TYPEXCZF:
            mathod = @"TaskCountDetailed";
            break;
            
        case TYPEPWSF:
            mathod = @"TaskCountPWSFDetailed";
            break;
            
        case TYPEYJ:
            mathod = @"TaskCountYJDetailed";
            break;
            
        default:
            break;
    }
    
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:mathod
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
    
}

#pragma mark - View lifecycle

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
    if (_type==TYPEXCZF) {
        self.title = @"超时流程未结束的现场执法任务";
    }
    else if(_type==TYPEPWSF){
        self.title = @"超时流程未结束的排污收费任务";
    }
    else if (_type==TYPEYJ){
        self.title = @"超时流程未结束的预警任务";
    }
    else{
         self.title = @"超时流程未结束的处罚任务";
    }
   
    
    [self getWebData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [yhid release];
    [punishArray release];
    [webservice release];
    [fromStr release];
    [endStr release];
    [super dealloc];
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    
    if (_type == TYPEXCZF||_type == TYPEPWSF||_type == TYPEYJ) {
        findTag = NO;
        self.curParsedData = [NSMutableString stringWithCapacity:1500];
        NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
        [xmlParser setDelegate: self];
        [xmlParser setShouldResolveExternalEntities: YES];
        [xmlParser parse];
        return;
    }
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];

    NSArray *aryJson = [str objectFromJSONString];
    if(aryJson == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"访问异常"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:aryJson];
    //异常或无数据的处理
    NSDictionary *resultDic = [resultArray objectAtIndex:0];
    id count = [resultDic objectForKey:@"COUNT"];
    id exception = [resultDic objectForKey:@"exception"];
    
    if (count)
    {
        [ZrsUtils showAlertMsg:@"查无数据" andDelegate:nil];
        return;
    }
    else if (exception)
    {
        [ZrsUtils showAlertMsg:@"查询出错" andDelegate:nil];
        return;
    }
    
    self.punishArray = resultArray;
    [listTable reloadData];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [punishArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath row];
    NSDictionary *aItem = [punishArray objectAtIndex:index];
    UITableViewCell *cell;
    if (_type == TYPEXCZF||_type==TYPEPWSF||_type==TYPEYJ) {
        
        NSString *dwmc = [aItem objectForKey:@"WF_UNIT"];
        NSString *name = [NSString stringWithFormat:@"办理人：%@",yhid];
        NSString *phase = @"";
    
        NSString *longTime = [aItem objectForKey:@"WF_DEADLINE"];
        NSArray *arr = [longTime componentsSeparatedByString:@" "];
        if (arr.count>1) {
            longTime = [arr objectAtIndex:0];
        }
        NSString *kssj = [NSString stringWithFormat:@"处理期限：%@",longTime];
        
        cell = [UITableViewCell makeSubCell:tableView withTitle:dwmc andSubvalue1:name andSubvalue2:kssj andSubvalue3:@"" andSubvalue4:phase andNoteCount:indexPath.row];
        
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    else{
        
        NSString *dwmc = [aItem objectForKey:@"DWMC"];
        NSString *name = [NSString stringWithFormat:@"单位地址：%@",[aItem objectForKey:@"DWDZ"]];
        NSString *phase = @"";
        //NSString *reason = [NSString stringWithFormat:@"执法事项：%@",[aItem objectForKey:@"ZFSX"]];
        NSString *jssj = [NSString stringWithFormat:@"案件性质：%@",[aItem objectForKey:@"AJXZMC"]];
        NSString *kssj = [NSString stringWithFormat:@"立案信息：%@",[aItem objectForKey:@"SFYLA"]];
        
        cell = [UITableViewCell makeSubCell:tableView withTitle:dwmc andSubvalue1:name andSubvalue2:jssj andSubvalue3:kssj andSubvalue4:phase andNoteCount:indexPath.row];
          cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 72;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
    /*
    int count = 50*currentPage > totalDataCount ? totalDataCount : 50*currentPage;
    NSString *str = [NSString stringWithFormat:@"当前显示%d条，总共查到数据%d条",count,totalDataCount];
    return str;
     */
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [punishArray objectAtIndex:indexPath.row];
    
    if (_type == TYPEXCZF) {
        
    }
    else if(_type == TYPEPWSF){
        
    }
    else if(_type == TYPEYJ){
        
    }
    else{
        DonePunishDetailController *childView = [[[DonePunishDetailController alloc] initWithNibName:@"DonePunishDetailController" bundle:nil] autorelease];
        childView.itemID = [tmpDic objectForKey:@"BWBH"];
        [self.navigationController pushViewController:childView animated:YES];
    }
   
}


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	
	if([elementName isEqualToString:@"TaskCountDetailedResult"]||[elementName isEqualToString:@"TaskCountPWSFDetailedResult"]||[elementName isEqualToString:@"TaskCountYJDetailedResult"])
        findTag = YES;
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( findTag)
	{
		[curParsedData appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
	if( findTag)
	{
		if([elementName isEqualToString:@"TaskCountDetailedResult"]||[elementName isEqualToString:@"TaskCountPWSFDetailedResult"]||[elementName isEqualToString:@"TaskCountYJDetailedResult"]){
            NSArray *ary = [curParsedData objectFromJSONString];
            self.punishArray = ary;
        }
    }
    
	findTag = NO;
	[curParsedData setString:@""];
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------end--------------");
	[listTable reloadData];
    
}


@end
