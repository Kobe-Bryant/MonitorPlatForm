//
//  ShowStaticsGraphVC.m
//  StatisticsGraphController
//
//  Created by zhang on 12-9-7.
//  Copyright (c) 2012年 zhang. All rights reserved.
//

#import "ShowStaticsGraphVC.h"
#import "NTChartView.h"
#import "ChartItem.h"
#import "GraphTypeDataItem.h"
#import "GraphGroupDataItem.h"
#import "TableDataItem.h"
#import "UITableViewCell+Custom.h"

@interface ShowStaticsGraphVC (){
    
    BOOL pageControlIsChangingPage;
}
@property(nonatomic,retain) NSMutableDictionary  *dicGraphTypes;
@property(nonatomic,retain) NSMutableArray *aryTypes;
@property(nonatomic,retain) NSMutableDictionary *dicTableValues;
@property(nonatomic,retain) NTChartView *chartView;
@property(nonatomic,assign) NSInteger typeIndex;
@property(nonatomic,retain)UITableView *tableView;

@end

@implementation ShowStaticsGraphVC
@synthesize dicGraphTypes,aryTypes,typeIndex;
@synthesize scrollView,pageControl,segCtrl,chartView,dicTableValues;
@synthesize tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

-(void)addGraphDataType:(NSString*)showType  withGroupName:(NSString*)groupName colValues:(NSDictionary*)dicColValues{
    if(dicGraphTypes == nil)
        self.dicGraphTypes = [NSMutableDictionary dictionaryWithCapacity:3];
    if(aryTypes == nil)
        self.aryTypes = [NSMutableArray arrayWithCapacity:10];
    if(![aryTypes containsObject:showType]){
        [aryTypes addObject:showType];
    }
    
    GraphTypeDataItem *aItem = [dicGraphTypes objectForKey:showType];
    if(aItem == nil){
        aItem = [[GraphTypeDataItem alloc] init];
        [dicGraphTypes setObject:aItem forKey:showType];
        [aItem release];
    }
    [aItem addGroupName:groupName withDatas:dicColValues];
    
}

-(void)addTableDataType:(NSString*)showType withColumns:(NSArray*)cols columnWidthPercent:(NSArray*)aryWidth itemValues:(NSArray*)aryValues showImage:(BOOL)bShown{
    if(aryTypes == nil)
        self.aryTypes = [NSMutableArray arrayWithCapacity:10];
    if(![aryTypes containsObject:showType]){
        [aryTypes addObject:showType];
    }
    if(dicTableValues == nil)
        self.dicTableValues = [NSMutableDictionary dictionaryWithCapacity:10];
    TableDataItem *aItem = [[TableDataItem alloc] init];
    aItem.aryColumnWidth = aryWidth;
    aItem.values = aryValues;
    aItem.aryColumns = cols;
    aItem.showImage = bShown;
    [dicTableValues setObject:aItem forKey:showType];
    [aItem release];

}

-(void)refreshDatasByIndex:(NSInteger)index{
    self.typeIndex = index;

    NSString *key = [aryTypes objectAtIndex:index];
    GraphTypeDataItem *aItem  = [dicGraphTypes objectForKey:key];
    
    if(aItem !=nil){
        [chartView clearItems];        
        
        NSMutableArray *colorAry = [[ChartItem makeColorArray] retain];//不加retain会释放掉出错
        int colorIndex = 0,colorAryMax = [colorAry count];
        
        for(GraphGroupDataItem *aGroup in aItem.groupDataItems){
            NSMutableArray *itemAry = [NSMutableArray arrayWithCapacity:15];
            NSArray *columnKeys = [aGroup.dicValues allKeys];
            for(NSString* column in columnKeys){
                CGFloat value = [[aGroup.dicValues objectForKey:column] floatValue];
                if(colorIndex >= colorAryMax)colorIndex = 0;
                UIColor *color = [colorAry objectAtIndex:colorIndex];
                ChartItem *aItem = [ChartItem itemWithValue:value Name:column Color:color.CGColor];
                [itemAry addObject:aItem];
                colorIndex++;
            }
            colorIndex = 0;
            [chartView addGroupArray:itemAry withGroupName:aGroup.groupName];
        }
        [chartView setNeedsDisplay];
        scrollView.scrollEnabled = YES;
        
    }
    else{
       [scrollView scrollRectToVisible:CGRectMake(768, 0, 768, 855) animated:YES];
        scrollView.scrollEnabled = NO;
    }
    
    [self.tableView reloadData];
    
}

-(void)segCtrlValueChanged:(id)sender{

    if(segCtrl.selectedSegmentIndex >= [aryTypes count])
        return;
    
    [self refreshDatasByIndex:segCtrl.selectedSegmentIndex];
    
}

-(void)showGraphDatas{
    self.segCtrl = [[[UISegmentedControl alloc] initWithItems:aryTypes] autorelease];
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segCtrl addTarget:self action:@selector(segCtrlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segCtrl.frame = CGRectMake(100,10,568,40);
    [self.view addSubview:segCtrl];
    segCtrl.selectedSegmentIndex = 0;
    [self refreshDatasByIndex:segCtrl.selectedSegmentIndex];
}

-(void)doNotShowChartNumCol{
    if (chartView) {
        [chartView showNumStrInCol:NO];
    }
}

-(void)clearAllDataItems{ //清除所有的数据项
    if(aryTypes)
        [aryTypes removeAllObjects];
    if(dicGraphTypes)
        [dicGraphTypes removeAllObjects];
    if(dicTableValues)
        [dicTableValues removeAllObjects];
    [chartView clearItems];
    
}

-(void)addCustomUI{

    
    UIImageView *detailTopView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"edgeBG.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]] autorelease];
    detailTopView.frame = CGRectMake(5, 0, 758, 855);
    [self.scrollView addSubview:detailTopView];
    
    UIImageView *detailTopView2 = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"edgeBG.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]] autorelease];
    detailTopView2.frame = CGRectMake(773, 0, 758, 855);
    [self.scrollView addSubview:detailTopView2];
    
    self.chartView = [[[NTChartView alloc] initWithFrame:CGRectMake(20, 20, 728, 805)] autorelease];
    [self.scrollView addSubview:chartView];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(788, 20, 728, 805) style:UITableViewStylePlain] autorelease];
    [scrollView addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;
    [self.scrollView addSubview:tableView];
    [scrollView setContentSize:CGSizeMake(768*2, 855)];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    scrollView.delegate = self;
	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.backgroundColor = [UIColor clearColor];
    [self addCustomUI];
    
    [pageControl addTarget:self action:@selector(changePage:) forControlEvents:UIControlEventValueChanged];
    // Do any additional setup after loading the view from its nib.
}

- (void)changePage:(id)sender
{
    
    CGRect frame = scrollView.frame;
    frame.origin.x = frame.size.width * pageControl.currentPage;
    frame.origin.y = 0;
	
    [scrollView scrollRectToVisible:frame animated:YES];
    pageControlIsChangingPage = YES;
}


-(NSInteger)calcCurrentPage{
    return floor((scrollView.contentOffset.x - scrollView.frame.size.width / 2) / scrollView.frame.size.width) + 1;
    
}


#pragma mark UIScrollViewDelegate stuff
- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
{
    if (pageControlIsChangingPage) {
        return;
    }
    int page = [self calcCurrentPage];
    pageControl.currentPage = page;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)_scrollView
{
    pageControlIsChangingPage = NO;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 728, 60)];
    NSString *key = [aryTypes objectAtIndex:typeIndex];
    TableDataItem *aItem = [dicTableValues objectForKey:key];

    int colCount = [aItem.aryColumns count];
    CGRect tRect = CGRectMake(4, 0, 0, 60);
    CGFloat colWidth;
    for (int i =0; i < colCount; i++) {
        colWidth = [[aItem.aryColumnWidth objectAtIndex:i] floatValue] *700;
        tRect.size.width = colWidth;
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        label.numberOfLines = 0;
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        label.font = [UIFont fontWithName:@"Helvetica" size:19.0];
        if(i ==0)
            label.textAlignment = UITextAlignmentLeft;
        else
            label.textAlignment = UITextAlignmentRight;
        
        tRect.origin.x += colWidth;
        [label setText:[aItem.aryColumns objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor = CELL_HEADER_COLOR2;
    return [view autorelease];
}

-(CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section{
    return 60;
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
    
    // Return the number of rows in the section.
    NSString *key = [aryTypes objectAtIndex:typeIndex];
    TableDataItem *aItem = [dicTableValues objectForKey:key];
    return [aItem.values count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key = [aryTypes objectAtIndex:typeIndex];
    TableDataItem *aItem = [dicTableValues objectForKey:key];
    NSDictionary *dic = [aItem.values objectAtIndex:indexPath.row];
    NSMutableArray *aryValues = [NSMutableArray arrayWithCapacity:5];
    for(NSString *aKey in aItem.aryColumns){
        [aryValues addObject:[dic objectForKey:aKey]];
    }
    
    NSString *cellIdentifier;
        
        cellIdentifier = [NSString stringWithFormat:@"cellStatics%d",typeIndex];
    
    int labelCount = [aryValues count];
    if (labelCount <= 0 || labelCount > 20) {
        return nil;
    }
    UILabel *lblTitle[20];
    
    UITableViewCell *aCell;
    
    aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
	
	if (aCell.contentView != nil)
	{
        for (int i =0; i < labelCount; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+1];
	}
	
	if (lblTitle[0] == nil) {
        CGRect tRect = CGRectMake(4, 0, 0, 60);
        for (int i =0; i < labelCount; i++) {
            CGFloat width = [[aItem.aryColumnWidth objectAtIndex:i] floatValue] *700;
            tRect.size.width = width;
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            [lblTitle[i] setTextColor:[UIColor blackColor]];
            lblTitle[i].font = [UIFont systemFontOfSize:20];
            if(i ==0)
                lblTitle[i].textAlignment = UITextAlignmentLeft;
            else
                lblTitle[i].textAlignment = UITextAlignmentRight;
            lblTitle[i].numberOfLines =2;
            lblTitle[i].tag = i+1;
            [aCell.contentView addSubview:lblTitle[i]];
            [lblTitle[i] release];
            tRect.origin.x += width;
        }
        
	}
    
    for (int i =0; i < labelCount; i++)
    {
        if ([[aryValues objectAtIndex:i] isEqual:@"(null)"])
        {
            [lblTitle[i] setText:@"0"];
        }else
        {
            [lblTitle[i] setText:[aryValues objectAtIndex:i]];
        }
    }
    
    if (aItem.showImage)
    {
        NSString * percent = [aryValues objectAtIndex:labelCount-1];
        BOOL bUp;
        NSRange range = [percent rangeOfString:@"-"];
        if (range.location == NSNotFound)
            bUp = YES;
        else
            bUp = NO;
        
        NSString *imageName = nil;
        
        if (bUp)
            imageName = @"up.png";
        else
            imageName = @"down.png";
        
        UIImageView *arrow = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]] autorelease];
        aCell.accessoryView = arrow;
    }
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return aCell;
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR2;
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
