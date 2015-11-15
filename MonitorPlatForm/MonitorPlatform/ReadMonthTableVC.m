//
//  ReadMonthTableVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-5.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ReadMonthTableVC.h"
#import "JSONKit.h"
#import "NSDateUtil.h"
#import "ServiceUrlString.h"
#import "ZrsUtils.h"
#import "ReadMonthDetailViewController.h"

@interface ReadMonthTableVC ()
@property (nonatomic,assign) int requstType;
@property (nonatomic,assign) int currentTag;
@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,copy) NSString *fileName;
@property (nonatomic,copy) NSString *fileType;

@property (nonatomic,strong) UIPopoverController *wordsPopover;
@property (nonatomic,strong) CommenWordsViewController *wordSelectCtrl;

@property (nonatomic,strong) NSArray *fileAry;
@property (nonatomic,assign) int fileCount;
@end

@implementation ReadMonthTableVC
@synthesize requstType,webHelper,fileName,fileType;
@synthesize wordSelectCtrl,wordsPopover,currentTag;
@synthesize fileAry,fileCount;

#define getList 1
#define getFile 2

#pragma mark - Private methods

- (void)addView:(UIView *)view type:(NSString *)type subType:(NSString *)subType
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    [self.view addSubview:view];
    [[view layer] addAnimation:transition forKey:@"ADD"];
}

- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
}

- (void)requestListData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_ZHYB_LIST" forKey:@"service"];
    
    NSString *yearStr = yearField.text;
    NSString *monthStr = monthField.text;
    NSString *toYearStr = toyearField.text;
    NSString *toMonthStr = tomonthField.text;
    NSString *fromDateStr = [self getPostDateStrWithYearStr:yearStr andMonthStr:monthStr];
    NSString *toDateStr = [self getPostDateStrWithYearStr:toYearStr andMonthStr:toMonthStr];
    if (fromDateStr!=nil) {
        //开始时间
        [param setObject:fromDateStr forKey:@"tbsj"];
    }
    if (toDateStr!=nil) {
    
        //结束时间
        [param setObject:toDateStr forKey:@"tbsj2"];
    }
    NSString *url = [ServiceUrlString generateUrlByParameters:param];
    self.requstType = getList;
    self.webHelper = [[[NSURLConnHelper alloc] initWithUrl:url andParentView:self.view delegate:self] autorelease];
}


- (NSString *)getPostDateStrWithYearStr:(NSString *)year andMonthStr:(NSString *)month{
    //获取时间
    NSString *reStr = nil;
    NSString *reYear = nil;
    NSString *reMonth = nil;
    if (year.length>0) {
        reYear = [self getYearOrMonthString:year withUnit:@"年"];
        if (month.length>0) {
            reMonth = [self getYearOrMonthString:month withUnit:@"月"];
            reStr = [NSString stringWithFormat:@"%@-%@",reYear,reMonth];
        }
        else{
            reStr = reYear;
        }
    }
    return reStr;

}
- (NSString *)getYearOrMonthString:(NSString *)dateStr withUnit:(NSString *)unit{
    
    //去除中文的单位
    NSString *reStr = nil;
    NSRange dateRange = [dateStr rangeOfString:unit];
    if (dateRange.length>0) {
        NSRange range = {0,dateRange.location};
        reStr = [dateStr substringWithRange:range];
    }
    return reStr;
}

- (void)requestFileDataWithBh:(NSString *)fileCode
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_ZHYB_FILE" forKey:@"service"];
    [param setObject:fileCode forKey:@"bh"];
    
    NSString *url = [ServiceUrlString generateUrlByParameters:param];
    self.requstType = getFile;
    self.webHelper = [[[NSURLConnHelper alloc] initWithUrl:url andParentView:self.view delegate:self] autorelease];
}

- (void)selectWord:(id)sender
{
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    
    UITextField *fie = (UITextField *)sender;
    fie.text = @"";
    currentTag = fie.tag;
    
    if (currentTag == 1||currentTag == 3)
    {
        NSInteger year = [NSDateUtil currentYear];
        wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:[NSString stringWithFormat:@"%d年",year],[NSString stringWithFormat:@"%d年",year-1],[NSString stringWithFormat:@"%d年",year-2],[NSString stringWithFormat:@"%d年",year-3],[NSString stringWithFormat:@"%d年",year-4],[NSString stringWithFormat:@"%d年",year-5],[NSString stringWithFormat:@"%d年",year-6],[NSString stringWithFormat:@"%d年",year-7],[NSString stringWithFormat:@"%d年",year-8],[NSString stringWithFormat:@"%d年",year-9], nil];
    }
    else
        wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"01月",@"02月",@"03月",@"04月",@"05月",@"06月",@"07月",@"08月",@"09月",@"10月",@"11月",@"12月", nil];
    
    [wordSelectCtrl.tableView reloadData];
    
    [wordsPopover presentPopoverFromRect:[fie bounds] inView:fie permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)searchBtnPressed:(id)sender
{
    if ([yearField.text length] == 0)
        [ZrsUtils showAlertMsg:@"请先选择开始年份再进行查询" andDelegate:nil];
    else
        [self requestListData];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        fileCount = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"月报表";
    //选择短语
    [yearField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [monthField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [toyearField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [tomonthField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(200, 300)];
    self.wordSelectCtrl = wordCtrl;
    wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:wordSelectCtrl];
    self.wordsPopover = popCtrl;
    [wordCtrl release];
    [popCtrl release];
    
    //获取默认数据
    NSString *year = nil;
    NSString *month = nil;
    NSInteger yearCount = [NSDateUtil currentYear];
    NSInteger monthCount = [NSDateUtil currentMonth];
    
    if (monthCount == 1)
    {
        year = [NSString stringWithFormat:@"%d",yearCount - 1];
        month = @"12";
    }
    else
    {
        year = [NSString stringWithFormat:@"%d",yearCount];
        
        if (monthCount - 1 < 10)
            month = [NSString stringWithFormat:@"0%d",monthCount-1];
        else
            month = [NSString stringWithFormat:@"%d",monthCount-1];
    }
    
    yearField.text = [NSString stringWithFormat:@"%@年",year];
    monthField.text = @"01月";
    toyearField.text = [NSString stringWithFormat:@"%@年",year];
    tomonthField.text = [NSString stringWithFormat:@"%@月",month];
    [self requestListData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
        [webHelper cancel];
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)dealloc
{
    [wordSelectCtrl release];
    [wordsPopover release];
    [fileName release];
    [fileType release];
    [webHelper release];
    [fileAry release];
    [toyearField release];
    [tomonthField release];
    [super dealloc];
}

#pragma mark - Text field delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - Words delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    switch (currentTag) {
        case 1:
            yearField.text = words;
            break;
        case 2:
            monthField.text = words;
            break;
        case 3:
            toyearField.text = words;
            break;
        case 4:
            tomonthField.text = words;
            break;
            
        default:
            break;
    }
    
    [wordsPopover dismissPopoverAnimated:YES];
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    
    
    
    if([webData length] <=0 )
        return;
    
    if (requstType == getList)
    {
        NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
        NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];
        NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];
        self.fileAry = [str objectFromJSONString];
        
        if (fileAry && [fileAry count]>0)
        {
            NSDictionary *tmpDic = [fileAry objectAtIndex:0];
            id test = [tmpDic objectForKey:@"COUNT"];
            if (test)
            {
                self.fileAry = [NSArray array];
                fileCount = [fileAry count];
                [listTable reloadData];
            }
            else
            {
                fileCount = [fileAry count];
                [self removeView:listTable];
                [listTable reloadData];
                [self addView:listTable type:@"pageCurl" subType:kCATransitionFromRight];
            }
        }
        else
        {
            [ZrsUtils showAlertMsg:@"访问出错，请联系维护人员。" andDelegate:nil];
        }
    }
    else if (requstType == getFile)
    {
        NSString *tmpDirectory  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
        
        //如果不是xls文件 就是word文档转换后的pdf文件
        if (![fileType isEqualToString:@"xls"]) {
            if (![fileType isEqualToString:@"xlsx"]) {
                fileType = @"pdf";
            }
        }
        NSString *tmpStr = [NSString stringWithFormat:@"月报表.%@",fileType];
       
        NSString *tempFile = [tmpDirectory stringByAppendingPathComponent:tmpStr];
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if ([manager fileExistsAtPath: tempFile])
            [manager removeItemAtPath:tempFile error:NULL];
        
        NSURL *url = [NSURL fileURLWithPath:tempFile];
        [webData writeToURL:url atomically:NO];
        
        [attachmentView loadRequest:[NSURLRequest requestWithURL:url]];
        
        [self removeView:attachmentView];
        
        [self addView:attachmentView type:@"rippleEffect" subType:kCATransitionFromTop];
    }
}

-(void)processError:(NSError *)error
{
    [ZrsUtils showAlertMsg:@"请求数据失败,请检查网络连接并重试。" andDelegate:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [fileAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	//return 120;
    return 72;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionHead = [NSString stringWithFormat:@"总共查到%d个月报表文件",fileCount];
    
    return sectionHead;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell_monthTable_List";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17];
    cell.textLabel.numberOfLines = 0;
    
    NSInteger row = [indexPath row];
    NSDictionary *tmpDic = [fileAry objectAtIndex:row];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d、%@",row+1,[tmpDic objectForKey:@"FJMZ"]];
    
    NSString *attchFileName = [tmpDic objectForKey:@"FJMZ"];
    if([attchFileName hasSuffix:@".doc"])
    {
        cell.imageView.image = [UIImage imageNamed:@"doc_file"];
    }
    else if([attchFileName hasSuffix:@".xls"])
    {
        cell.imageView.image = [UIImage imageNamed:@"xls_file"];
    }
    else if([attchFileName hasSuffix:@".rar"])
    {
        cell.imageView.image = [UIImage imageNamed:@"rar_file"];
    }
    else if([attchFileName hasSuffix:@".pdf"])
    {
        cell.imageView.image = [UIImage imageNamed:@"pdf_file"];
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"default_file"];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSDictionary *tmpDic = [fileAry objectAtIndex:row];
    
    
    self.fileName = [tmpDic objectForKey:@"FJMZ"];
    NSArray *tmpAry = [fileName componentsSeparatedByString:@"."];
    self.fileType = [tmpAry lastObject];
    NSString *fjbh = [tmpDic objectForKey:@"FJBH"];
//    [self requestFileDataWithBh:fjbh];
    ReadMonthDetailViewController *readMonthDetail = [[ReadMonthDetailViewController alloc] initWithNibName:@"ReadMonthDetailViewController" bundle:nil];
    readMonthDetail.fileType = fileType;
    readMonthDetail.fjbh = fjbh;
    [self.navigationController pushViewController:readMonthDetail animated:YES];
    [readMonthDetail release];
    

    //演示版本
    /*
    NSString *fileMC = [tmpAry objectAtIndex:0];
    NSString *path = [[NSBundle mainBundle] pathForResource:fileMC ofType:@"pdf"];
    NSURL *fileUrl = [NSURL fileURLWithPath:path];
    [attachmentView loadRequest:[NSURLRequest requestWithURL:fileUrl]];
    
    [self removeView:attachmentView];
    
    [self addView:attachmentView type:@"rippleEffect" subType:kCATransitionFromTop];
     */
}
- (void)viewDidUnload {
    [toyearField release];
    toyearField = nil;
    [tomonthField release];
    tomonthField = nil;
    [super viewDidUnload];
}
@end
