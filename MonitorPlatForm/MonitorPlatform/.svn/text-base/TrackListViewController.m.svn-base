//
//  TrackListViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-8-31.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TrackListViewController.h"
#import "NSDateUtil.h"
#import "JSonKit.h"
#import "UsersSubViewController.h"
#import "DatesSubViewController.h"

#import "MPAppDelegate.h"

#define SHOWDATATYPE_USRS  0 //按人员查看
#define SHOWDATATYPE_DATES 1  //按日期查看

extern MPAppDelegate *g_appDelegate;

@interface TrackListViewController ()
@property(nonatomic,retain) NSArray *aryDatesItems;
@property(nonatomic,retain) NSDictionary *dicUsersItems;
@property(nonatomic,retain) NSArray *aryDepartNames;
@property(nonatomic,assign) NSInteger showDataType;
@property(nonatomic,copy) NSString *fromDateStr;
@property(nonatomic,copy) NSString *endDateStr;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property(nonatomic,assign) BOOL findTag;
@end

@implementation TrackListViewController
@synthesize showDataType,curParsedData;
@synthesize aryDatesItems,dicUsersItems,webHelper;
@synthesize popController,dateController,listTableView,findTag,aryDepartNames;
@synthesize fromDateStr,endDateStr,infoLabel;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)requestUsersDatas{
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"fromDate" value:fromDateStr,@"endDate",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetUsrGpsCountByDateRange"
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

-(void)requestDatesDatas{

    NSString *param = [WebServiceHelper createParametersWithKey:@"fromDate" value:fromDateStr,@"endDate",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetHasGpsDatesByDateRange"
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

-(void)requestDatas{
    
    if(showDataType == SHOWDATATYPE_USRS)
        [self requestUsersDatas];
    else
        [self requestDatesDatas];
}

-(void)selectDates:(id)sender{

    UIBarButtonItem *aItem = (UIBarButtonItem *)sender;
    if (popController)
        [popController dismissPopoverAnimated:YES];
    [popController presentPopoverFromBarButtonItem:aItem permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)popupController:(PopupYearMonthViewController *)controller Saved:(BOOL)bSaved selectedYear:(NSInteger)theYear andMonth:(NSInteger)theMonth
{
    if (bSaved) {
        
        self.fromDateStr = [NSString stringWithFormat:@"%d-%d-01",theYear,theMonth];
        //算出一个月的最后一天
        NSString *endDateStrTmp = @"";
        if(theMonth == 12){
            
             endDateStrTmp = [NSString stringWithFormat:@"%d-01-01",theYear+1];
            
            
        }else{
             endDateStrTmp = [NSString stringWithFormat:@"%d-%d-01",theYear,theMonth+1];

        }
        NSDate* dateTmp = [NSDateUtil dateFromString:endDateStrTmp andTimeFMT:@"yyyy-MM-dd"];
        NSDate *endDate = [NSDate dateWithTimeInterval:-24*60*60 sinceDate:dateTmp];
        
        self.endDateStr = [NSDateUtil stringFromDate:endDate andTimeFMT:@"yyyy-MM-dd"];
            
        
        infoLabel.text = [NSString stringWithFormat:@"%d年%d月的轨迹统计",theYear,theMonth];
        
    }
    
    [popController dismissPopoverAnimated:YES];
    [self requestDatas];
    
}

-(void)segctrlClicked:(id)sender{
    UISegmentedControl *segCtrl = (UISegmentedControl*)sender;
    showDataType = segCtrl.selectedSegmentIndex;
    [self requestDatas];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"轨迹统计";
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"按人员查看", @"按日期查看",nil]];
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segCtrl addTarget:self action:@selector(segctrlClicked:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segCtrl;
    segCtrl.selectedSegmentIndex = 0;
    showDataType = SHOWDATATYPE_USRS;
    [segCtrl release];

    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"其它日期" style:UIBarButtonItemStyleDone target:self action:@selector(selectDates:)];
    self.navigationItem.rightBarButtonItem = button;
    [button release];
    
    PopupYearMonthViewController *dateCtrl = [[PopupYearMonthViewController alloc] init];
    self.dateController = dateCtrl;
    dateController.delegate = self;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
    UIPopoverController *popCtrl1 = [[UIPopoverController alloc] initWithContentViewController:nav];
    self.popController = popCtrl1;
    [dateCtrl release];
    [nav release];
    [popCtrl1 release];
    
    NSString* dateStr = [NSDateUtil stringFromDate:[NSDate date] andTimeFMT:@"yyyy-MM"];
    NSArray *tmpAry = [dateStr componentsSeparatedByString:@"-"];
    if([tmpAry count] >=2){
        self.fromDateStr = [NSString stringWithFormat:@"%@-01",dateStr];
        self.endDateStr = [NSDateUtil stringFromDate:[NSDate date] andTimeFMT:@"yyyy-MM-dd"];
        
        infoLabel.text = [NSString stringWithFormat:@"%@年%@月的轨迹统计",[tmpAry objectAtIndex:0],[tmpAry objectAtIndex:1]];
        
    }
    
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
	
	if( showDataType == SHOWDATATYPE_USRS)
	{
        if([elementName isEqualToString:@"GetUsrGpsCountByDateRangeResult"])
            findTag = YES;
	}else {
        if([elementName isEqualToString:@"GetHasGpsDatesByDateRangeResult"])
            findTag = YES;
    }
    
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
		if( showDataType == SHOWDATATYPE_USRS)
        {
            if([elementName isEqualToString:@"GetUsrGpsCountByDateRangeResult"]){
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

        }else {
            if([elementName isEqualToString:@"GetHasGpsDatesByDateRangeResult"]){
                 NSArray *ary = [curParsedData objectFromJSONString];
                NSMutableArray *aryFilterd = [NSMutableArray arrayWithCapacity:30];
                for(NSDictionary *dic in ary){
                    NSString *dateStr = [dic objectForKey:@"DWSJ"];
                    if(dateStr && [aryFilterd containsObject:dateStr] == NO)
                        [aryFilterd addObject:dateStr];
                }
                self.aryDatesItems = [aryFilterd sortedArrayUsingComparator: ^(id obj1, id obj2) {
                    
                    return [obj1 compare:obj2];
                }];
               
            }

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
    if (showDataType== SHOWDATATYPE_USRS){
        return [aryDepartNames objectAtIndex:section];
    }else{
        return @"";
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     if (showDataType== SHOWDATATYPE_USRS){
         return [aryDepartNames count];
     }
    else
        return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    if (showDataType== SHOWDATATYPE_USRS){
        NSString *name = [aryDepartNames objectAtIndex:section];
        NSArray *ary = [dicUsersItems objectForKey:name];
        if(ary)
            return [ary count];
        else
            return 0;
    }
    else
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
    
    if (showDataType== SHOWDATATYPE_USRS){
        NSString *name = [aryDepartNames objectAtIndex:indexPath.section];
        NSArray *ary = [dicUsersItems objectForKey:name];
        NSDictionary *dic = [ary objectAtIndex:indexPath.row];
        cell.textLabel.text = [dic objectForKey:@"USERNAME"];
        cell.detailTextLabel.text = [dic objectForKey:@"NUMBERS"];
    }
    else{

        cell.textLabel.text = [aryDatesItems objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = @"";
    }
    
    
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
    if(showDataType == SHOWDATATYPE_USRS){
        NSString *name = [aryDepartNames objectAtIndex:indexPath.section];
        NSArray *ary = [dicUsersItems objectForKey:name];
        NSDictionary *dic = [ary objectAtIndex:indexPath.row];
        
        UsersSubViewController *controller = [[UsersSubViewController alloc] initWithNibName:@"UsersSubViewController" bundle:nil];
        controller.fromDateStr = fromDateStr;
        controller.endDateStr = endDateStr;
        controller.usrName = [dic objectForKey:@"USERNAME"];
        controller.usrID = [dic objectForKey:@"UM_LOGIN_ID"];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }else{
        DatesSubViewController *controller = [[DatesSubViewController alloc] initWithNibName:@"DatesSubViewController" bundle:nil];
        controller.theDateStr = [aryDatesItems objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }

}

-(void)dealloc{
    [webHelper release];
    [listTableView release];
    [popController release];
    [dateController release];
    [dicUsersItems release];
    [aryDepartNames release];
    [aryDatesItems release];
    [fromDateStr release];
    [endDateStr release];
    
    [super dealloc];
}


@end
