//
//  TrackMapViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-8-31.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "TrackMapViewController.h"
#import "JSONKit.h"
#import "WebServiceHelper.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@interface TrackMapViewController ()
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property(nonatomic,retain)  BMKMapView* baiduMapView;
@property(nonatomic,retain)  NSArray *aryPersonItems;
@property(nonatomic,retain)NSMutableArray *aryAnnotations;
@property(nonatomic,retain) NSTimer* trackTimer;
@property(nonatomic,retain) BMKPointAnnotation *posPointAnnotation;
@property (nonatomic,strong) NSMutableString *curParsedData;
@property(nonatomic,assign) BOOL findTag;
-(void)playTracking:(id)sender;
-(void)showRoute;

@property(nonatomic,assign) BOOL isPlaying;
@end

@implementation TrackMapViewController
@synthesize theDateStr,usrID,usrName;
@synthesize webHelper,baiduMapView,aryPersonItems,isPlaying;
@synthesize aryAnnotations,trackTimer,posPointAnnotation;
@synthesize findTag,curParsedData;

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
    NSString *param = [WebServiceHelper createParametersWithKey:@"pUserID" value:usrID,@"pDate",theDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl
                                                    method:@"GetUserGpsTrail"
                                                 nameSpace:@"http://tempuri.org/"
                                                parameters:param
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = [NSString stringWithFormat:@"%@%@的轨迹",usrName,theDateStr];
    // 设置mapView的Delegate
    baiduMapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
	baiduMapView.delegate = self;
	[self.view addSubview:baiduMapView];
    baiduMapView.showsUserLocation = YES;
    
    baiduMapView.zoomLevel = 13;
    
    [self requestPersonPositions];
    
    UIBarButtonItem *button = [[UIBarButtonItem alloc] initWithTitle:@"播放轨迹" style:UIBarButtonItemStyleDone target:self action:@selector(playTracking:)];
    self.navigationItem.rightBarButtonItem = button;
    [button release];
    self.isPlaying = NO;
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
    if(isPlaying){
        [trackTimer invalidate];
        [trackTimer release];
        trackTimer = nil;
    }
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
	
	if([elementName isEqualToString:@"GetUserGpsTrailResult"])
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
		if([elementName isEqualToString:@"GetUserGpsTrailResult"]){
            self.aryPersonItems= [curParsedData objectFromJSONString];
            
        }
	}
	findTag = NO;
	[curParsedData setString:@""];
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------end--------------");
    if (aryAnnotations && [aryAnnotations count]) {
        [baiduMapView removeAnnotations:aryAnnotations];
        [aryAnnotations removeAllObjects];
    }
    self.aryAnnotations = [NSMutableArray arrayWithCapacity:50];
    
    CGFloat nextJD;
    CGFloat nextWD ;
    CGFloat wd;
    CGFloat jd;
    NSMutableArray *aryTmp = [NSMutableArray arrayWithCapacity:100];
    for (NSDictionary *dic in aryPersonItems) {
        nextWD = [[dic objectForKey:@"WD"] floatValue];
        nextJD = [[dic objectForKey:@"JD"] floatValue];
        
        if((fabs(nextJD - jd) < 0.00001) && (fabs(nextWD - wd) < 0.00001)){
            //[aryTmp removeObject:dic];
            continue;
        }
        [aryTmp insertObject:dic atIndex:0];
        wd = nextWD;
        jd = nextJD;
        
        
    }
    self.aryPersonItems = aryTmp;
    
    if([aryPersonItems count]>=2){
        NSDictionary *dicFrom = [aryPersonItems objectAtIndex:0];
        NSDictionary *dicEnd = [aryPersonItems objectAtIndex:aryPersonItems.count-1];
        CGFloat WDFrom = [[dicFrom objectForKey:@"WD"] floatValue];
        CGFloat JDFrom = [[dicFrom objectForKey:@"JD"] floatValue];
        CGFloat WDEnd = [[dicEnd objectForKey:@"WD"] floatValue];
        CGFloat JDEnd = [[dicEnd objectForKey:@"JD"] floatValue];
        
        BMKPointAnnotation* annotation1 = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor1;
        coor1.latitude = WDFrom;
        coor1.longitude = JDFrom;
        annotation1.coordinate = coor1;
        annotation1.title = usrName;
        NSString *time1 = [NSString stringWithFormat:@"%@",[dicFrom objectForKey:@"DWSJ"]];
        annotation1.subtitle = time1;        
        [baiduMapView addAnnotation:annotation1];
        [aryAnnotations addObject:annotation1];
        [annotation1 release];
        
        BMKPointAnnotation* annotation2 = [[BMKPointAnnotation alloc]init];
        CLLocationCoordinate2D coor2;
        coor2.latitude = WDEnd;
        coor2.longitude = JDEnd;        
        annotation2.coordinate = coor2;
        annotation2.title = usrName;
        NSString *time2 = [NSString stringWithFormat:@"%@",[dicEnd objectForKey:@"DWSJ"]];
        annotation2.subtitle = time2;
        
        [baiduMapView addAnnotation:annotation2];
        [aryAnnotations addObject:annotation2];
        [annotation2 release];
  
    }
   
    
    [self showRoute];
    
}



//显示轨迹路线
-(void)showRoute{
    NSInteger count = [aryPersonItems count];
    if (count <= 0)
        return;
    
    CLLocationCoordinate2D *coors =(CLLocationCoordinate2D*) malloc(sizeof(CLLocationCoordinate2D)*count);
    //CLLocationCoordinate2D coors[100];
    NSInteger index = 0;
    
    CGFloat maxWD = 0,maxJD= 0,minWD=0,minJD=0;
    for (NSDictionary *dic in aryPersonItems) {
        CGFloat wd = [[dic objectForKey:@"WD"] floatValue];
        CGFloat jd = [[dic objectForKey:@"JD"] floatValue];
        
        coors[index].latitude = wd;
        coors[index].longitude = jd;
        if(index == 0){
            maxJD = minJD = jd;
            maxWD = minWD = wd;
        }else{
            if(wd > maxWD)
                maxWD = wd;
            else if(wd < minWD)
                minWD = wd;
            
            if(jd > maxJD)
                maxJD = jd;
            else if(jd < minJD)
                minJD = jd;
            
        }
        
        
        index++;
        
    }
    
    BMKCoordinateSpan span;
    span.latitudeDelta = maxWD - minWD;
    span.longitudeDelta = maxJD - minJD;
    
    
    CLLocationCoordinate2D centerCoor;
    centerCoor.latitude = (maxWD + minWD) *0.5;
    centerCoor.longitude = (maxJD + minJD)*0.5;
    baiduMapView.centerCoordinate = centerCoor;
    
    BMKCoordinateRegion region;
    region.center = coors[0];
    region.span = span;
    [baiduMapView regionThatFits:region];
    
    
    BMKPolyline* polyline = [BMKPolyline polylineWithCoordinates:coors count:count];
    [baiduMapView addOverlay:polyline];
    free(coors);
    
}

- (void)handleTrackTimer:(NSTimer *)theTimer {
    if(posPointAnnotation){
        [baiduMapView removeAnnotation:posPointAnnotation];
    }
    
    NSInteger count = [aryPersonItems count];
    if (count <= 0)
        return;
    
    static int index = 0;
    if (index >= count) {
        index = 0;
        [trackTimer invalidate];
        [trackTimer release];
        trackTimer = nil;
        self.isPlaying = NO;
        self.navigationItem.rightBarButtonItem.title = @"播放轨迹";
        if (aryAnnotations && [aryAnnotations count]) {
            [baiduMapView addAnnotations:aryAnnotations];
        }
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"轨迹播放完毕。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
        
    }
    //因为返回的数据时间是倒序的
    NSDictionary *dic = [aryPersonItems objectAtIndex:(count-index-1)];
    
    CGFloat wd = [[dic objectForKey:@"WD"] floatValue];
    CGFloat jd = [[dic objectForKey:@"JD"] floatValue];
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    CLLocationCoordinate2D coor;
    coor.latitude  = wd;
    coor.longitude = jd;
    annotation.coordinate = coor;
    
    annotation.title = usrName;
    NSString *time = [NSString stringWithFormat:@"%@",[dic objectForKey:@"DWSJ"]];
    annotation.subtitle = time;
    
    [baiduMapView addAnnotation:annotation];
    self.posPointAnnotation = annotation;
    [annotation release];
    index++;
    
}


//播放轨迹
-(void)playTracking:(id)sender{
    UIBarButtonItem *button = (UIBarButtonItem*)sender;
    if(isPlaying){
        [trackTimer invalidate];
        [trackTimer release];
        trackTimer = nil;
        self.isPlaying = NO;
        button.title = @"播放轨迹";
        if(posPointAnnotation)[baiduMapView removeAnnotation:posPointAnnotation];
        
        if (aryAnnotations && [aryAnnotations count]) {
            [baiduMapView addAnnotations:aryAnnotations];
        }
        
        
    }else{
        self.isPlaying= YES;
        button.title = @"停止播放";
        
        if (aryAnnotations && [aryAnnotations count]) {
            [baiduMapView removeAnnotations:aryAnnotations];
        }
        
        self.trackTimer = [NSTimer scheduledTimerWithTimeInterval:0.4
                                                           target:self
                                                         selector:@selector(handleTrackTimer:)
                                                         userInfo:nil
                                                          repeats:YES];
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
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(30, -10, 80, 22)];
        label.text =theAnnotation.title;
        label.textColor = [UIColor redColor];
        label.alpha = 0.8;
        [newAnnotation addSubview:label];
        [label release];
        
        UILabel *labelSub = [[UILabel alloc] initWithFrame:CGRectMake(30, 12, 80, 22)];
        labelSub.text =[theAnnotation.subtitle substringFromIndex:11];
        labelSub.textColor = [UIColor redColor];
        labelSub.alpha = 0.8;
        [newAnnotation addSubview:labelSub];
        [labelSub release];
        
		return [newAnnotation autorelease];
	}
	return nil;
}

- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay{
    if ([overlay isKindOfClass:[BMKPolyline class]]){ BMKPolylineView* polylineView = [[[BMKPolylineView alloc] initWithOverlay:overlay] autorelease];
        polylineView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 5.0;
        return polylineView;
    }
    return nil;
}


-(void)dealloc{
    [webHelper release];
    [baiduMapView release];
    [aryPersonItems release];
    [usrName release];
    [usrID release];
    [theDateStr release];
    [aryAnnotations release];
    [posPointAnnotation release];
    [trackTimer release];
    [super dealloc];
}
@end