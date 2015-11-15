//
//  XkzDetailViewController.m
//  MonitorPlatform
//
//  Created by 王哲义 on 13-10-11.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import "XkzDetailViewController.h"
#import "JSONKit.h"

#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "WryJbxxController.h"

extern MPAppDelegate *g_appDelegate;

@interface XkzDetailViewController ()
@property (nonatomic,copy) NSString *xkzCode;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) UIImageView *emptyView;
@end

@implementation XkzDetailViewController

@synthesize resultDic,isLoading,xkzCode,webHelper;
@synthesize titleAry1,titleAry2,valueAry1,valueAry2;
@synthesize titleAry_fq1,titleAry_fq2,valueAry_fq1,valueAry_fq2;
@synthesize titleAry_fs1,titleAry_fs2,valueAry_fs1,valueAry_fs2;
@synthesize titleAry_zs1,titleAry_zs2,valueAry_zs1,valueAry_zs2;
@synthesize titleAry_gf1,titleAry_gf2,valueAry_gf1,valueAry_gf2;
@synthesize sectionTitleAry,curParsedData;
@synthesize isGotJsonString,emptyView;


#pragma mark - View lifecycle

-(void)requestData{
  
    self.titleAry1 = [NSArray arrayWithObjects:@"许可证编号：",@"证件类型：",@"发证时间：",@"是否注销：", nil];
    self.titleAry2 = [NSArray arrayWithObjects:@"单位名称：",@"行业类型：",@"有效期：",@"是否新证：", nil];
    
    self.titleAry_fs1 = [NSArray arrayWithObjects:@"排水口编号：",@"最大日排量：",@"最低水重用率：", nil];
    self.titleAry_fs2 = [NSArray arrayWithObjects:@"排水口名称：",@"年排水总量：",@"年检月份：", nil];
    
    self.titleAry_fq1 = [NSArray arrayWithObjects:@"排气口编号：",@"年排气总量：", nil];
    self.titleAry_fq2 = [NSArray arrayWithObjects:@"排气口名称：",@"林格曼黑度：", nil];
    
    self.titleAry_zs1 = [NSArray arrayWithObjects:@"噪声源名称：",@"排放日限值：",@"区域日限值：", nil];
    self.titleAry_zs2 = [NSArray arrayWithObjects:@"允许排放时间：",@"排放夜限值：",@"区域夜限值：", nil];
    
    self.titleAry_gf1 = [NSArray arrayWithObjects:@"处置地点：",@"最低综合利用量：",@"最低处置量：", nil];
    self.titleAry_gf2 = [NSArray arrayWithObjects:@"储存量：",@"最低综合利用率：",@"最低处置率：", nil];

    self.sectionTitleAry = [NSMutableArray array];
    
    self.isLoading = YES;
    NSString *param = [WebServiceHelper createParametersWithKey:@"strXTBH" value:xkzCode,nil];
    NSString *URL = [NSString stringWithFormat:WRYPWXKZ_URL,g_appDelegate.xxcxServiceIP];
    
    NSLog(@"param : %@\n url : %@",param,URL);
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                     method:@"NewGetPWXKZ"
                                                  nameSpace:@"http://tempuri.org/"
                                                 parameters:param
                                                   delegate:self] autorelease];
    [self.webHelper runAndShowWaitingView:self.view];
    
}

- (id)initWithStyle:(UITableViewStyle)style andBH:(NSString *)xkzBH
{
    self = [super initWithStyle:style];
    if (self) {
        self.xkzCode = xkzBH;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"许可证详情";
    
    emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)/2, (960-290)*0.35, 350, 290)];
    emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
    [self.view addSubview:emptyView];
    emptyView.hidden = YES;
    
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData
{
    /*
    NSString *xmlStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",xmlStr);
    [xmlStr release];
    */
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error
{
    NSString *msg = @"请求数据失败，请检查网络。";
    
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:msg
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
    return sectionTitleAry.count+1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *headTitle ;
    if (section == 0)
    {
        headTitle = @"许可证基本信息";
    }
    else
    {
        if(sectionTitleAry.count > 0)
        {
            headTitle = [sectionTitleAry objectAtIndex:section-1];
        }
    }
    return headTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return [valueAry1 count];
    }
    else
    {
        if(sectionTitleAry.count > 0)
        {
            NSString *sectionTitle = [sectionTitleAry objectAtIndex:section-1];
            if ([sectionTitle isEqualToString:@"废气信息"])
            {
                return [titleAry_fq1 count];
            }
            else if ([sectionTitle isEqualToString:@"废水信息"])
            {
                return [titleAry_fs1 count];
            }
            else if ([sectionTitle isEqualToString:@"噪声信息"])
            {
                return [titleAry_zs1 count];
            }
            else if ([sectionTitle isEqualToString:@"固废信息"])
            {
                return [titleAry_gf1 count];
            }
        }
        else
        {
            return 0;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 56;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    UITableViewCell *cell;
    if (section == 0)
    {
        NSArray *values = [NSArray arrayWithObjects:[titleAry1 objectAtIndex:row],[valueAry1 objectAtIndex:row],[titleAry2 objectAtIndex:row],[valueAry2 objectAtIndex:row], nil];
        cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:2 cellHeight:56 valueArray:values];
    }
    else
    {
        if(sectionTitleAry.count > 0)
        {
            NSString *sectionTitle = [sectionTitleAry objectAtIndex:section-1];
            
            if ([sectionTitle isEqualToString:@"废气信息"])
            {
                NSArray *values = [NSArray arrayWithObjects:[titleAry_fq1 objectAtIndex:row],[valueAry_fq1 objectAtIndex:row],[titleAry_fq2 objectAtIndex:row],[valueAry_fq2 objectAtIndex:row], nil];
                cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:2 cellHeight:56 valueArray:values];
            }
            else if ([sectionTitle isEqualToString:@"废水信息"])
            {
                NSArray *values = [NSArray arrayWithObjects:[titleAry_fs1 objectAtIndex:row],[valueAry_fs1 objectAtIndex:row],[titleAry_fs2 objectAtIndex:row],[valueAry_fs2 objectAtIndex:row], nil];
                
                cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:2 cellHeight:56 valueArray:values];
            }
            else if ([sectionTitle isEqualToString:@"噪声信息"])
            {
                NSArray *values = [NSArray arrayWithObjects:[titleAry_zs1 objectAtIndex:row],[valueAry_zs1 objectAtIndex:row],[titleAry_zs2 objectAtIndex:row],[valueAry_zs2 objectAtIndex:row], nil];
                
                cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:2 cellHeight:56 valueArray:values];
            }
             else if ([sectionTitle isEqualToString:@"固废信息"])
            {
                NSArray *values = [NSArray arrayWithObjects:[titleAry_gf1 objectAtIndex:row],[valueAry_gf1 objectAtIndex:row],[titleAry_gf2 objectAtIndex:row],[valueAry_gf2 objectAtIndex:row], nil];
                
                cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:2 cellHeight:56 valueArray:values];
            }
        }
    }
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - XMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
    
    if ([sectionTitleAry count] > 0)
        [self.sectionTitleAry removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"NewGetPWXKZResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"NewGetPWXKZResult"])
    {
        NSRange range = [curParsedData rangeOfString:@"*"];
        if (range.location != NSNotFound)
            [curParsedData replaceCharactersInRange:range withString:@""];
        NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x0A];
        NSString *str =[curParsedData stringByReplacingOccurrencesOfString:ctrlChar withString:@""];
        //JSON -> Dict
        //NSLog(@"%@", str);
        self.resultDic = [str objectFromJSONString];
        
        NSArray *keys = [resultDic allKeys];

        
        for (NSString *key in keys)
        {

            
            if ([key isEqualToString:@"固废信息"] || [key isEqualToString:@"噪声信息"] || [key isEqualToString:@"废水信息"] ||[key isEqualToString:@"废气信息"])
            {
                [self.sectionTitleAry addObject:key];
            }
        }
        //NSLog(@"%@", sectionTitleAry);
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if ([curParsedData length] == 0)
    {
        emptyView.hidden = NO;
        self.tableView.hidden = YES;
        return;
    }
    self.isLoading = NO;
    NSArray *baseInfoAry = [resultDic objectForKey:@"排污许可证基本信息"];
    if(baseInfoAry.count > 0)
    {
        
        NSDictionary *baseInfo = [baseInfoAry objectAtIndex:0];
        
        NSString *xkzbh = [[baseInfo objectForKey:@"XKZBH"] length] > 0 ? [baseInfo objectForKey:@"XKZBH"]:@"";
        NSString *zjlx = [[baseInfo objectForKey:@"ZJLX"] intValue] == 1 ? @"正式":@"临时";
        NSString *fzsj = [self getShortDateString:[baseInfo objectForKey:@"FZSJ"]];
        NSString *sfzx = [[baseInfo objectForKey:@"SFZX"] intValue] == 1 ? @"是":@"否";
        
        self.valueAry1 = [NSArray arrayWithObjects:xkzbh,zjlx,fzsj,sfzx, nil];
        
        //NSString *yxq = [[baseInfo objectForKey:@"YXQ"] length] > 0 ? [baseInfo objectForKey:@"YXQ"]:@"";
        NSString *dwmc = [[baseInfo objectForKey:@"DWMC"] length] > 0 ? [baseInfo objectForKey:@"DWMC"]:@"";
        NSString *yxq = [self getShortDateString:[baseInfo objectForKey:@"YXQ"]];
        NSString *sfxz = [[baseInfo objectForKey:@"SFXZ"] intValue] == 1 ? @"是":@"否";
        NSString *xkzhylx = [[baseInfo objectForKey:@"XKZHYLX"] length] > 0 ? [baseInfo objectForKey:@"XKZHYLX"]:@"";
        switch ([xkzhylx intValue]) {
            case 1:
                xkzhylx = @"工业企业";
                break;
            case 2:
                xkzhylx = @"三产，服务业";
                break;
            case 3:
                xkzhylx = @"市政设施";
                break;
            case 4:
                xkzhylx = @"其他";
                break;
            case 5:
                xkzhylx = @"线路板";
                break;
            case 6:
                xkzhylx = @"电镀";
                break;
            case 7:
                xkzhylx = @"医院";
                break;
            case 8:
                xkzhylx = @"环保工程";
                break;
            default:
                break;
        }
        self.valueAry2 = [NSArray arrayWithObjects:dwmc,xkzhylx,yxq,sfxz, nil];
    }
    
    
    for (NSString *key in sectionTitleAry)
    {
        if ([key isEqualToString:@"废水信息"])
        {
            NSArray *fsInfoAry = [resultDic objectForKey:key];
            if(fsInfoAry.count > 0)
            {
                NSDictionary *fsInfoDic = [fsInfoAry objectAtIndex:0];
                
                NSString *pskbh = [[fsInfoDic objectForKey:@"PWKBH"] length] > 0 ? [fsInfoDic objectForKey:@"PWKBH"]:@"";
                NSString *zdrpl = [[fsInfoDic objectForKey:@"YXZDRPSL120_"] length] > 0 ? [fsInfoDic objectForKey:@"YXZDRPSL120_"]:@"";
                if ([zdrpl length] > 0)
                    zdrpl = [NSString stringWithFormat:@"%@ 吨",zdrpl];
                 NSString *scyl = [[fsInfoDic objectForKey:@"ZDSCFLYL120_"] length] > 0 ? [fsInfoDic objectForKey:@"ZDSCFLYL120_"]:@"";
                
                self.valueAry_fs1 = [NSArray arrayWithObjects:pskbh,zdrpl,scyl, nil];
                
                NSString *pskmc = [[fsInfoDic objectForKey:@"PWKMC120_"] length] > 0 ? [fsInfoDic objectForKey:@"PWKMC120_"]:@"";
                NSString *npzl = [[fsInfoDic objectForKey:@"YXNPSZL120_"] length] > 0 ? [fsInfoDic objectForKey:@"YXNPSZL120_"]:@"";
                if ([npzl length] > 0)
                    npzl = [NSString stringWithFormat:@"%@ 吨",npzl];
                NSString *njyf = [[fsInfoDic objectForKey:@"NJYF120_"] length] > 0 ? [fsInfoDic objectForKey:@"NJYF120_"]:@"";
                self.valueAry_fs2 = [NSArray arrayWithObjects:pskmc,npzl,njyf, nil];
            }
        }
        else if ([key isEqualToString:@"废气信息"])
        {
            NSArray *fqInfoAry = [resultDic objectForKey:key];
            if(fqInfoAry.count > 0)
            {
                NSDictionary *fqInfoDic = [fqInfoAry objectAtIndex:0];
                
                NSString *pqkbh = [[fqInfoDic objectForKey:@"PWKBH"] length] > 0 ? [fqInfoDic objectForKey:@"PWKBH"]:@"";
                NSString *npql = [[fqInfoDic objectForKey:@"NPQL117_"] length] > 0 ? [fqInfoDic objectForKey:@"NPQL117_"]:@"";
                if ([npql length] > 0)
                    npql = [NSString stringWithFormat:@"%@ 升",npql];
                
                self.valueAry_fq1 = [NSArray arrayWithObjects:pqkbh,npql, nil];
                
                
                NSString *pqkmc = [[fqInfoDic objectForKey:@"PWKMC117_"] length] > 0 ? [fqInfoDic objectForKey:@"PWKMC117_"]:@"";
                NSString *lgmhd = [[fqInfoDic objectForKey:@"LGMHD117_"] length] > 0 ? [fqInfoDic objectForKey:@"LGMHD117_"]:@"";
                self.valueAry_fq2 = [NSArray arrayWithObjects:pqkmc,lgmhd, nil];
            }
        }
        else if ([key isEqualToString:@"噪声信息"])
        {
            NSArray *zsInfoAry = [resultDic objectForKey:key];
            if(zsInfoAry.count > 0)
            {
                NSDictionary *zsInfoDic = [zsInfoAry objectAtIndex:0];
                
                NSString *zsymc = [[zsInfoDic objectForKey:@"ZSYMC126_"] length] > 0 ? [zsInfoDic objectForKey:@"ZSYMC126_"]:@"";
                NSString *pfrxz = [[zsInfoDic objectForKey:@"PFZSRXZ126_"] length] > 0 ? [zsInfoDic objectForKey:@"PFZSRXZ126_"]:@"";
                if ([pfrxz length] > 0)
                    pfrxz = [NSString stringWithFormat:@"%@ 分贝",pfrxz];
                NSString *qyrxz = [[zsInfoDic objectForKey:@"QYZSRXZ126_"] length] > 0 ? [zsInfoDic objectForKey:@"QYZSRXZ126_"]:@"";
                if ([qyrxz length] > 0)
                    qyrxz = [NSString stringWithFormat:@"%@ 分贝",qyrxz];
                self.valueAry_zs1 = [NSArray arrayWithObjects:zsymc,pfrxz,qyrxz, nil];
                
                NSString *yxpfsj = [[zsInfoDic objectForKey:@"YXPFSJ126_"] length] > 0 ? [zsInfoDic objectForKey:@"YXPFSJ126_"]:@"";
                NSString *pfyxz = [[zsInfoDic objectForKey:@"PFZSYXZ126_"] length] > 0 ? [zsInfoDic objectForKey:@"PFZSYXZ126_"]:@"";
                if ([pfyxz length] > 0)
                    pfyxz = [NSString stringWithFormat:@"%@ 分贝",pfyxz];
                NSString *qyyxz = [[zsInfoDic objectForKey:@"QYZSYXZ126_"] length] > 0 ? [zsInfoDic objectForKey:@"QYZSYXZ126_"]:@"";
                if ([qyyxz length] > 0)
                    qyyxz = [NSString stringWithFormat:@"%@ 分贝",qyyxz];
                self.valueAry_zs2 = [NSArray arrayWithObjects:yxpfsj,pfyxz,qyyxz, nil];
            }
        }
        else if ([key isEqualToString:@"固废信息"])
        {
            NSArray *gfInfoAry = [resultDic objectForKey:key];
            if(gfInfoAry.count > 0)
            {
                NSDictionary *gfInfoDic = [gfInfoAry objectAtIndex:0];
                
                NSString *czdd = [[gfInfoDic objectForKey:@"CZDD123_"] length] > 0 ? [gfInfoDic objectForKey:@"CZDD123_"]:@"";
                NSString *zdlyla = [[gfInfoDic objectForKey:@"ZDZHLYLA123_"] length] > 0 ? [gfInfoDic objectForKey:@"ZDZHLYLA123_"]:@"";
                if ([zdlyla length] > 0)
                    zdlyla = [NSString stringWithFormat:@"%@ 千克",zdlyla];
                NSString *zdczla = [[gfInfoDic objectForKey:@"ZDCZLA123_"] length] > 0 ? [gfInfoDic objectForKey:@"ZDCZLA123_"]:@"";
                if ([zdczla length] > 0)
                    zdczla = [NSString stringWithFormat:@"%@ 千克",zdczla];
                self.valueAry_gf1 = [NSArray arrayWithObjects:czdd,zdlyla,zdczla, nil];
                
                NSString *ccl = [[gfInfoDic objectForKey:@"CCL123_"] length] > 0 ? [gfInfoDic objectForKey:@"CCL123_"]:@"";
                if ([ccl length] > 0)
                    ccl = [NSString stringWithFormat:@"%@ 千克",ccl];
                NSString *zdlylv = [[gfInfoDic objectForKey:@"ZDZHLYLV123_"] length] > 0 ? [gfInfoDic objectForKey:@"ZDZHLYLV123_"]:@"";
                NSString *zdczlv = [[gfInfoDic objectForKey:@"ZDCZLV123_"] length] > 0 ? [gfInfoDic objectForKey:@"ZDCZLV123_"]:@"";
                self.valueAry_gf2 = [NSArray arrayWithObjects:ccl,zdlylv,zdczlv, nil];
            }
            
        }
    }
    
    [self.tableView reloadData];
}

- (NSString *)getShortDateString:(NSString *)str
{
    if(str.length > 0 && str != nil)
    {
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *d = [df dateFromString:str];
        [df setDateFormat:@"yyyy-MM-dd"];
        NSString *s = [df stringFromDate:d];
        [df release];
        return s;
    }
    return @"";
}

@end
