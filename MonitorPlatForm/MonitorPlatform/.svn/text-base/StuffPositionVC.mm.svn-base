//
//  StuffPositionVC.m
//  MonitorPlatform
//
//  Created by zhang on 12-8-31.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "StuffPositionVC.h"
#import "TrackListViewController.h"
#import "WebServiceHelper.h"
#import "MPAppDelegate.h"
#import "JSonKit.h"
#import "NSDateUtil.h"

extern MPAppDelegate *g_appDelegate;

@interface StuffPositionVC ()
@property(nonatomic,strong)WebServiceHelper *webHelper;
@property(nonatomic,retain)  BMKMapView* baiduMapView;
@property(nonatomic,retain)  NSArray *aryPersonItems;
@property(nonatomic,assign) BOOL findTag;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property (nonatomic, retain) UIPopoverController *popController;
@end

@implementation StuffPositionVC
@synthesize webHelper,baiduMapView,aryPersonItems,findTag,curParsedData,popController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 要使用百度地图，请先启动BaiduMapManager
        BMKMapManager *mapManager = [[BMKMapManager alloc]init];
        BOOL ret = [mapManager start:@"C42968B2FB398D5C63706C36E6467DB772214220" generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
    }
    return self;
}

-(void)requestPersonPositions{

    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetTodayStuffLastGPS"
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:@""
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
    
}
#pragma mark PersonPositonDelegate
-(void)showPosition:(NSDictionary*)info{
    CLLocationCoordinate2D coor;
    coor.latitude = [[info objectForKey:@"WD"] floatValue];
    coor.longitude = [[info objectForKey:@"JD"] floatValue];
    baiduMapView.centerCoordinate = coor;
    baiduMapView.zoomLevel = 16; //最大的级别
    [popController dismissPopoverAnimated:YES];
}

//显示所定位到的人员点位
-(void)showRTStuffPos:(id)sender{
    if(popController == nil){
        PersonsViewController *personsVC = [[PersonsViewController alloc] initWithStyle:UITableViewStylePlain];
        
        personsVC.delegate = self;
        personsVC.aryPersons = aryPersonItems;
        personsVC.contentSizeForViewInPopover = CGSizeMake(320, 480);
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:personsVC];
        UIPopoverController *popCtrl1 = [[UIPopoverController alloc] initWithContentViewController:nav];
        self.popController = popCtrl1;
        [personsVC release];
        [nav release];
        [popCtrl1 release];
    }
    
    UIBarButtonItem *item = (UIBarButtonItem*)sender;
    [popController presentPopoverFromBarButtonItem:item permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
}

-(void)gotoHistoryList:(id)sender{
    TrackListViewController *controller = [[TrackListViewController alloc] initWithNibName:@"TrackListViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"实时定位";
    
    // 设置mapView的Delegate
    baiduMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
	baiduMapView.delegate = self;
	[self.view addSubview:baiduMapView];
    baiduMapView.showsUserLocation = YES;
    CLLocationCoordinate2D shenzhenCoor;
    shenzhenCoor.latitude = 22.53075;
    shenzhenCoor.longitude = 114.08248;
    
    baiduMapView.centerCoordinate = shenzhenCoor;
    baiduMapView.zoomLevel = 12;
    
    
    //导航栏按钮
   UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 240, 44)];
    UIBarButtonItem *flexItem = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    UIBarButtonItem *item1 = [[UIBarButtonItem  alloc] initWithTitle:@"最新人员点位" style:UIBarButtonItemStyleBordered  target:self action:@selector(showRTStuffPos:)];

    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"历史人员轨迹" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoHistoryList:)];
    
    toolBar.items = [NSArray arrayWithObjects: item1,flexItem,item2,nil];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolBar] autorelease];
    [item1 release];
    [item2 release];
    [flexItem release];
    [toolBar release];
 /*
    UIBarButtonItem *fixed = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = 20;
    UIBarButtonItem *item1 = [[UIBarButtonItem  alloc] initWithTitle:@"最新人员点位" style:UIBarButtonItemStyleBordered  target:self action:@selector(showRTStuffPos:)];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"历史人员轨迹" style:UIBarButtonItemStyleBordered target:self action:@selector(gotoHistoryList:)];
    NSArray *rightButtons = [NSArray arrayWithObjects:item2, fixed, item1, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;
    [fixed release];
    [item2 release];
    [item1 release];
    */
    [self requestPersonPositions];
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
	return YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
        [webHelper cancel];
    if(popController)
       [popController dismissPopoverAnimated:YES];
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
	
	if([elementName isEqualToString:@"GetTodayStuffLastGPSResult"])
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
		if([elementName isEqualToString:@"GetTodayStuffLastGPSResult"]){
            NSArray *ary = [curParsedData objectFromJSONString];
            NSMutableArray *aryFilterd = [NSMutableArray arrayWithCapacity:30];
            //只显示最近一周的人员点位
            NSDate *endDate = [NSDate dateWithTimeInterval:-7*24*60*60 sinceDate:[NSDate date]];
            
            NSString *endDateStr = [NSDateUtil stringFromDate:endDate andTimeFMT:@"yyyy-MM-dd"];
            
            for(NSDictionary *dic in ary){
                NSString *timeStr = [dic objectForKey:@"DWSJ"];
                if([timeStr compare:endDateStr] == NSOrderedDescending)
                    [aryFilterd addObject:dic];
            }
            self.aryPersonItems = aryFilterd;
            
        }
	}
	findTag = NO;
	[curParsedData setString:@""];
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------end--------------");
	if (aryPersonItems == nil||[aryPersonItems count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有人员的点位信息" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    

    for (NSDictionary *dic in aryPersonItems) {
        
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [[dic objectForKey:@"WD"] floatValue];
        coor.longitude = [[dic objectForKey:@"JD"] floatValue];
        
        annotation.coordinate = coor;
        annotation.title = [dic objectForKey:@"UM_NAME"];
        annotation.subtitle = [dic objectForKey:@"DWSJ"];
        
        [baiduMapView addAnnotation:annotation];
        [annotation release];
       // if(i == 2)break;
       // i++;
    }
    
}


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKAnnotationView *newAnnotation = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        
		newAnnotation.draggable = NO;
        newAnnotation.image = [UIImage imageNamed:@"person_pos.png"];
        BMKPointAnnotation* theAnnotation = (BMKPointAnnotation*)annotation;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, -10, 90, 22)];
        label.text =theAnnotation.title;
        label.textColor = [UIColor redColor];
        label.alpha = 0.9;
        [newAnnotation addSubview:label];
        [label release];
        
        UILabel *labelSub = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 90, 22)];
        labelSub.text = [theAnnotation.subtitle substringFromIndex:5];
        labelSub.font = [UIFont systemFontOfSize:13];
        labelSub.textColor = [UIColor redColor];
        labelSub.alpha = 0.9;

        [newAnnotation addSubview:labelSub];
        [labelSub release];
        
		return [newAnnotation autorelease];
	}
	return nil;
}

-(void)dealloc{
    [webHelper release];
    [baiduMapView release];
    [aryPersonItems release];
    [popController release];
    [super dealloc];
}

@end

