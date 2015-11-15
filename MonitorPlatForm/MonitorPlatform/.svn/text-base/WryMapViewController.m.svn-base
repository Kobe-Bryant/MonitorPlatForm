//
//  WryMapViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-5.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WryMapViewController.h"
#import "WebServiceHelper.h"
#import "DBHelper.h"
#import "WryEntity.h"
#import "MapPinButton.h"
#import "WryBMKPointAnnotation.h"
#import "WryJbxxController.h"
@interface WryMapViewController ()
@property(nonatomic,retain)  BMKMapView* baiduMapView;
@property(nonatomic,retain)  NSArray *aryWryItems;
@property(nonatomic,assign) BOOL findTag;
@property (nonatomic,strong) NSMutableString *curParsedData;
@end

@implementation WryMapViewController
@synthesize baiduMapView,aryWryItems,findTag,curParsedData;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // 要使用百度地图，请先启动BaiduMapManager
        BMKMapManager *mapManager = [[BMKMapManager alloc]init];
        BOOL ret = [mapManager start:@"C42968B2FB398D5C63706C36E6467DB772214220" generalDelegate:self];
        if (!ret) {
            NSLog(@"manager start failed!");
        }
    }
    return self;
}

-(void)showTop20Annotations{
    if(aryWryItems.count > 20){
        for( int i = 0; i<20;i++){
            WryEntity *aEntity = [aryWryItems objectAtIndex:i];
            WryBMKPointAnnotation* annotation = [[WryBMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [aEntity.Latitude floatValue];
            coor.longitude = [aEntity.Longitude floatValue];
            
            annotation.coordinate = coor;
            annotation.title = @"污染源";
            annotation.subtitle = aEntity.WRYMC;
            annotation.wrybh = aEntity.WRYBH;
            annotation.wrymc = aEntity.WRYMC;

            [baiduMapView addAnnotation:annotation];
            [annotation release];
        }
    }
}

-(void)showLastAnnotations{
    
    
    if(aryWryItems.count > 20){
        for( int i = 20; i<aryWryItems.count;i++){
            WryEntity *aEntity = [aryWryItems objectAtIndex:i];
            WryBMKPointAnnotation* annotation = [[WryBMKPointAnnotation alloc]init];
            CLLocationCoordinate2D coor;
            coor.latitude = [aEntity.Latitude floatValue];
            coor.longitude = [aEntity.Longitude floatValue];
            
            annotation.coordinate = coor;
            annotation.title = @"污染源";
            annotation.subtitle = aEntity.WRYMC;
            annotation.wrybh = aEntity.WRYBH;
            annotation.wrymc = aEntity.WRYMC;
            
            [baiduMapView addAnnotation:annotation];
            [annotation release];
        }
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"污染源地图";
    // Do any additional setup after loading the view from its nib.
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
    
    self.aryWryItems = [[DBHelper sharedInstance] queryAllWrys:NO];
    [self performSelector:@selector(showTop20Annotations) withObject:nil afterDelay:0.5];
    [self performSelector:@selector(showLastAnnotations) withObject:nil afterDelay:0.5];
//    [self showAnnotations];
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

-(void)selWry:(id)sender{
    
    WryJbxxController *childView = [[[WryJbxxController alloc] initWithNibName:@"WryJbxxController" bundle:nil] autorelease];
    childView.wrybh =  [(MapPinButton*)sender wrybh];
    childView.wrymc = [(MapPinButton*)sender wrymc];
    [self.navigationController pushViewController:childView animated:YES];
    
    
}


// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
	if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
		BMKPinAnnotationView *newAnnotation = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
		newAnnotation.pinColor = BMKPinAnnotationColorPurple;
		newAnnotation.animatesDrop = NO;
		newAnnotation.draggable = NO;
        
		MapPinButton *btn = [[MapPinButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        btn.wrybh = [(WryBMKPointAnnotation*)annotation wrybh];
        btn.wrymc = [(WryBMKPointAnnotation*)annotation wrymc];
        [btn setImage:[UIImage imageNamed:@"info.png"] forState:UIControlStateNormal];
        newAnnotation.rightCalloutAccessoryView = btn;
        [btn addTarget:self action:@selector(selWry:) forControlEvents:UIControlEventTouchUpInside];
        [btn release];
		return [newAnnotation autorelease];
	}
	return nil;
}

-(void)dealloc{
    [baiduMapView release];
    [aryWryItems release];
    [super dealloc];
}

@end
