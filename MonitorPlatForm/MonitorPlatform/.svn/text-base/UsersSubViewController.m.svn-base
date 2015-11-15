//
//  UsersSubViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-3.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "UsersSubViewController.h"
#import "NSDateUtil.h"
#import "JSonKit.h"
#import "TrackMapViewController.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@interface UsersSubViewController ()
@property(nonatomic,retain) NSArray *aryDatesItems;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property(nonatomic,assign) BOOL findTag;
@end

@implementation UsersSubViewController
@synthesize curParsedData,usrID,usrName;
@synthesize aryDatesItems,webHelper;
@synthesize listTableView,findTag;
@synthesize fromDateStr,endDateStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)requestDatas{
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"fromDate" value:fromDateStr,@"endDate",endDateStr,@"usrid",usrID, nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetDatesByDateRangeAndUsr"
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"轨迹统计";
        
    [self requestDatas];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
        [webHelper cancel];
    [super viewWillDisappear:animated];
}

#pragma mark - URLConnHelper delegate
-(void)processWebData:(NSData*)webData
{
    findTag = NO;
    self.curParsedData = [NSMutableString stringWithCapacity:1500];
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
    
}

-(void)processError:(NSError *)error
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

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	
	if([elementName isEqualToString:@"GetDatesByDateRangeAndUsrResult"])
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
		if([elementName isEqualToString:@"GetDatesByDateRangeAndUsrResult"]){
            NSArray *ary = [curParsedData objectFromJSONString];
            NSMutableArray *aryFilterd = [NSMutableArray arrayWithCapacity:30];
            for(NSDictionary *dic in ary){
                NSString *dateStr = [dic objectForKey:@"DWSJ"];
                if(dateStr && [aryFilterd containsObject:dateStr] == NO)
                    [aryFilterd addObject:dateStr];
            }
            self.aryDatesItems = aryFilterd;
        }
	}
	findTag = NO;
	[curParsedData setString:@""];
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------end--------------");
	[listTableView reloadData];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return @"有定位信息的人员";
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [aryDatesItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        // Configure the cell...
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [aryDatesItems objectAtIndex:indexPath.row];
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TrackMapViewController *controller = [[TrackMapViewController alloc] initWithNibName:@"TrackMapViewController" bundle:nil];
    controller.theDateStr = [aryDatesItems objectAtIndex:indexPath.row];
    controller.usrID = usrID;
    controller.usrName = usrName;
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

-(void)dealloc{
    [webHelper release];
    [listTableView release];
    [aryDatesItems release];
    [fromDateStr release];
    [endDateStr release];
    [usrID release];
    [usrName release];
    [super dealloc];
}
@end