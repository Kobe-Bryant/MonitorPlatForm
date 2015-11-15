//
//  DatesSubViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-3.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "DatesSubViewController.h"

#import "NSDateUtil.h"
#import "JSonKit.h"
#import "MPAppDelegate.h"
#import "TrackMapViewController.h"
extern MPAppDelegate *g_appDelegate;

@interface DatesSubViewController ()

@property(nonatomic,retain) NSDictionary *dicUsersItems;
@property(nonatomic,retain) NSArray *aryDepartNames;

@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property(nonatomic,assign) BOOL findTag;
@end

@implementation DatesSubViewController
@synthesize curParsedData;
@synthesize dicUsersItems,webHelper;
@synthesize listTableView,findTag,aryDepartNames;
@synthesize theDateStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


-(void)requestDatas{
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"aDate" value:theDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetUsersByDate"
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
	
	if([elementName isEqualToString:@"GetUsersByDateResult"])
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
		if([elementName isEqualToString:@"GetUsersByDateResult"]){
            NSArray *ary = [curParsedData objectFromJSONString];
            NSMutableArray *aryDeparts = [NSMutableArray arrayWithCapacity:5];
            NSMutableDictionary *dicDeparts = [NSMutableDictionary dictionaryWithCapacity:5];
            for(NSDictionary *dic in ary){
                NSString *departName = [dic objectForKey:@"DEPARTMENT"];
                NSNumber *number = [dic objectForKey:@"NUMBERS"];
                if([aryDeparts containsObject:departName]){
                    if([number intValue] > 0){
                        NSMutableArray *aryTmp = [dicDeparts objectForKey:departName];
                        if(aryTmp)[aryTmp addObject:dic];
                    }
                    
                }else{
                    if([number intValue] > 0){
                        NSMutableArray *aryUsrs = [NSMutableArray arrayWithCapacity:10];
                        [aryUsrs addObject:dic];
                        [dicDeparts setObject:aryUsrs forKey:departName];
                        [aryDeparts addObject:departName];
                    }
                    
                }
            }
            self.aryDepartNames = aryDeparts;
            self.dicUsersItems = dicDeparts;
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
    return [aryDepartNames objectAtIndex:section];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [aryDepartNames count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    NSString *name = [aryDepartNames objectAtIndex:section];
    NSArray *ary = [dicUsersItems objectForKey:name];
    if(ary)
        return [ary count];
    else
        return 0;
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
    
    NSString *name = [aryDepartNames objectAtIndex:indexPath.section];
    NSArray *ary = [dicUsersItems objectForKey:name];
    NSDictionary *dic = [ary objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"USERNAME"];
    cell.detailTextLabel.text = [dic objectForKey:@"NUMBERS"];
    
    
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
    controller.theDateStr = theDateStr;
    
    NSString *name = [aryDepartNames objectAtIndex:indexPath.section];
    NSArray *ary = [dicUsersItems objectForKey:name];
    NSDictionary *dic = [ary objectAtIndex:indexPath.row];
    
    controller.usrID = [dic objectForKey:@"UM_LOGIN_ID"];
    controller.usrName = [dic objectForKey:@"USERNAME"];
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

-(void)dealloc{
    [webHelper release];
    [listTableView release];
    [dicUsersItems release];
    [aryDepartNames release];
    [theDateStr release];
    
    [super dealloc];
}
@end
