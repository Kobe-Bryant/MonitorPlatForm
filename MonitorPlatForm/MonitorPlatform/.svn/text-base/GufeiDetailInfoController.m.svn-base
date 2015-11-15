//
//  GufeiDetailInfoController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "GufeiDetailInfoController.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@implementation GufeiDetailInfoController
@synthesize wrybh,code;
@synthesize isGotJsonString,nParserStatus;
@synthesize curParsedData,currentMethod,infoDic;
@synthesize titleArray,valueArray,webHelper;

#define nLiandan 1
#define nBeian 2

#pragma mark - Private method

- (void)getWebData{
    
    NSString *param;
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];


    switch (nParserStatus) {
        case nLiandan:
            param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,@"ldbh",code,nil];
            self.currentMethod = @"GetEveryLinkage";
            self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                         method:currentMethod 
                                                      nameSpace:@"http://tempuri.org/" 
                                                     parameters:param 
                                                       delegate:self] autorelease];
            [webHelper runAndShowWaitingView:self.view];
            break;
            
        case nBeian:
            param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,@"sqxh",code,nil];
            self.currentMethod = @"GetEveryZybeiAn";
            self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                         method:currentMethod 
                                                      nameSpace:@"http://tempuri.org/" 
                                                     parameters:param 
                                                       delegate:self] autorelease];
            [webHelper runAndShowWaitingView:self.view];
            break;
            
        default:
            break;
    }
}

- (UITableViewCell*)makeSubCell:(UITableView *)tableView
					 withTitle:(NSString *)aTitle
						 value:(NSString *)aValue
{
	UILabel* lblTitle = nil;
	UILabel* lblValue = nil;
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cellcustom"];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcustom"] autorelease];
    }
    
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblValue = (UILabel *)[aCell.contentView viewWithTag:2];
	}
	
	if (lblTitle == nil) {
		CGRect tRect2 = CGRectMake(5, 0, 140, 44);
		lblTitle = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor grayColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblTitle.textAlignment = UITextAlignmentRight;
        lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];
		[lblTitle release];
		
		CGRect tRect3 = CGRectMake(160, 0, 320, 44);
		lblValue = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblValue setBackgroundColor:[UIColor clearColor]];
		[lblValue setTextColor:[UIColor blackColor]];
		lblValue.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblValue.textAlignment = UITextAlignmentLeft;
        lblValue.numberOfLines = 2;
		lblValue.tag = 2;	
		[aCell.contentView addSubview:lblValue];
		[lblValue release];
	}
	if (aTitle == nil) aTitle = @"";
    if (aValue == nil) aValue = @"";
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblValue != nil)	[lblValue setText:aValue];
	
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
}

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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

- (void)dealloc
{
    [wrybh release];
    [code release];
    [curParsedData release];
    [currentMethod release];
    [infoDic release];
    [titleArray release];
    [valueArray release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (nParserStatus == nLiandan)
        self.title = @"危废联单详细信息";
    else
        self.title = @"转移备案详细信息";
    
    [self getWebData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}


-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - NSURLConnHelper delegate
-(void)processWebData:(NSData*)webData{
    
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败，请检查网络。";
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:msg 
                          delegate:nil 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - NSXMLParser delegate

#pragma mark - Xml parser delegate
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
    self.currentMethod = [NSString stringWithFormat:@"%@Result",currentMethod];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:currentMethod])
        isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString) {
        [self.curParsedData appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:currentMethod]) 
    {
        NSRange range = [curParsedData rangeOfString:@"\n"];
        while (range.location != NSNotFound) {
            [curParsedData deleteCharactersInRange:range];
            range = [curParsedData rangeOfString:@"\n"];
        }
        
        if ([curParsedData length] > 0) {
            NSArray *tmpAry = [curParsedData objectFromJSONString];
            self.infoDic = [tmpAry lastObject];
        } else
            self.infoDic = [NSDictionary dictionary];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([curParsedData length] > 0) {
        if (nParserStatus == nLiandan) {
            self.titleArray = [NSArray arrayWithObjects:@"联单号:",@"产废单位:",@"经营单位:",@"运输日期:",@"废物种类:",@"废物名称:",@"数量:",@"单位:",@"废物特征:",@"形态:",@"主要危险成分:",@"运输起点:",@"经由地:",@"运输终点:",@"废物处置方式:", nil];
            
            NSString *ldh = [[infoDic objectForKey:@"联单号码"] length] > 0 ? [infoDic objectForKey:@"联单号码"]:@"";
            NSString *cfdw = [[infoDic objectForKey:@"产生者单位名称"] length] > 0 ? [infoDic objectForKey:@"产生者单位名称"]:@"";
            NSString *jydw = [[infoDic objectForKey:@"废物运输者单位名称"] length] > 0 ? [infoDic objectForKey:@"废物运输者单位名称"]:@"";
            NSString *ysrq = [[infoDic objectForKey:@"运输日期"] length] > 0 ? [infoDic objectForKey:@"运输日期"]:@"";
            if ([ysrq length] > 10)
                ysrq = [ysrq substringToIndex:10];
            
            NSString *kind = [[infoDic objectForKey:@"废物名称"] length] > 0 ? [infoDic objectForKey:@"废物名称"]:@"";
            NSString *name = [[infoDic objectForKey:@"废物种类"] length] > 0 ? [infoDic objectForKey:@"废物种类"]:@"";
            NSString *count = [[infoDic objectForKey:@"数量"] length] > 0 ? [infoDic objectForKey:@"数量"]:@"";
            NSString *unit = [[infoDic objectForKey:@"单位"] length] > 0 ? [infoDic objectForKey:@"单位"]:@"";
            NSString *charactor = [[infoDic objectForKey:@"废物特征"] length] > 0 ? [infoDic objectForKey:@"废物特征"]:@"";
            NSString *type = [[infoDic objectForKey:@"形态"] length] > 0 ? [infoDic objectForKey:@"形态"]:@"";
            NSString *mainDanger = [[infoDic objectForKey:@"主要危险成分"] length] > 0 ? [infoDic objectForKey:@"主要危险成分"]:@"";
            
            NSString *start = [[infoDic objectForKey:@"运输起点"] length] > 0 ? [infoDic objectForKey:@"运输起点"]:@"";
            NSString *mid = [[infoDic objectForKey:@"经由地"] length] > 0 ? [infoDic objectForKey:@"经由地"]:@"";
            NSString *end = [[infoDic objectForKey:@"运输终点"] length] > 0 ? [infoDic objectForKey:@"运输终点"]:@"";
            NSString *dealKind = [[infoDic objectForKey:@"废物处置方式"] length] > 0 ? [infoDic objectForKey:@"废物处置方式"]:@"";
            
            self.valueArray = [NSArray arrayWithObjects:ldh,cfdw,jydw,ysrq,kind,name,count,unit,charactor,type,mainDanger,start,mid,end,dealKind, nil];
        
        } else {
            
            self.titleArray = [NSArray arrayWithObjects:@"废物种类:",@"形态:",@"易燃性:",@"爆炸性:",@"毒性:",@"腐蚀性:",@"传染性:",@"反应性:",@"审核意见:",@"审核人:",@"核定该申请有效期限:", nil];
            
            NSString *name = [[infoDic objectForKey:@"废物名称"] length] > 0 ? [infoDic objectForKey:@"废物名称"]:@"";
            NSString *count = [[infoDic objectForKey:@"形态"] length] > 0 ? [infoDic objectForKey:@"形态"]:@"";
            NSString *unit = [[infoDic objectForKey:@"易燃性"] length] > 0 ? [infoDic objectForKey:@"易燃性"]:@"";
            NSString *charactor = [[infoDic objectForKey:@"爆炸性"] length] > 0 ? [infoDic objectForKey:@"爆炸性"]:@"";
            NSString *type = [[infoDic objectForKey:@"毒性"] length] > 0 ? [infoDic objectForKey:@"毒性"]:@"";
            NSString *mainDanger = [[infoDic objectForKey:@"腐蚀性"] length] > 0 ? [infoDic objectForKey:@"腐蚀性"]:@"";
            NSString *start = [[infoDic objectForKey:@"传染性"] length] > 0 ? [infoDic objectForKey:@"传染性"]:@"";
            NSString *mid = [[infoDic objectForKey:@"反应性"] length] > 0 ? [infoDic objectForKey:@"反应性"]:@"";
            NSString *end = [[infoDic objectForKey:@"审核意见"] length] > 0 ? [infoDic objectForKey:@"审核意见"]:@"";
            NSString *number = [[infoDic objectForKey:@"审核人"] length] > 0 ? [infoDic objectForKey:@"审核人"]:@"";
            NSString *dealKind = [[infoDic objectForKey:@"核定该申请有效期限"] length] > 0 ? [infoDic objectForKey:@"核定该申请有效期限"]:@"";
            
            self.valueArray = [NSArray arrayWithObjects:name,count,unit,charactor,type,mainDanger,start,mid,end,number,dealKind, nil];
            
        }
        [self.tableView reloadData];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本项无详情信息或联单号不存在" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [titleArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [self makeSubCell:tableView withTitle:[titleArray objectAtIndex:indexPath.row] value:[valueArray objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

#pragma mark - UIAlert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}


@end
