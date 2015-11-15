//
//  WryQueryViewController.m
//  BoandaProject
//
//  Created by PowerData on 13-10-17.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import "WryQueryViewController.h"
#import "JSONKit.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "WryJbxxController.h"
#import "SystemConfigContext.h"

@interface WryQueryViewController ()
@property (nonatomic,retain) UIPopoverController *wordsPopover;
@property (nonatomic,retain) CommenWordsViewController *wordSelectCtrl;

@property (nonatomic, retain) NSMutableArray *listDataArray;
@property (nonatomic, retain) NSString *urlString;
@property (assign) int totalCount;//总记录条数
@property (assign) BOOL isLoading;
@property (assign) int currentPage;//当前页
@property (assign) int currentTag;
@property (assign) BOOL isFrist;
@property (assign) int selectedDWLX;
@property (assign) int selectedJGJB;
@end

#define kTag_DWLX_Field 1 //单位类型
#define kTag_JGJB_Field 2 //监管级别

@implementation WryQueryViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)initQueryArea
{
    self.dwlxField.tag = kTag_DWLX_Field;
    self.dwlxField.delegate = self;
    self.jgjbField.tag = kTag_JGJB_Field;
    self.jgjbField.delegate = self;
    
    [self.searchButton addTarget:self action:@selector(searchButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.dwlxField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    [self.jgjbField addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    self.wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:self.wordSelectCtrl];
    self.wordsPopover = popCtrl;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"污染源查询";
    
    [self initQueryArea];
    self.totalCount = 0;
    self.currentPage = 1;
    self.selectedJGJB = 1;
    self.listDataArray = [[NSMutableArray alloc] init];
    self.isFrist = YES;
    self.isLoading = NO;
    [self requestData];
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewWillDisappear:(BOOL)animated
{
     //确保弹出框是隐藏起来的
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload
{
    [self setListTableView:nil];
    [self setNameLabel:nil];
    [self setNameField:nil];
    [super viewDidUnload];
}

#pragma mark - UITableView DataSource & Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listDataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *headerView = [[UILabel alloc] initWithFrame:CGRectZero];
    headerView.font = [UIFont systemFontOfSize:19.0];
    headerView.backgroundColor = [UIColor colorWithRed:170.0/255 green:223.0/255 blue:234.0/255 alpha:1.0];
    headerView.textColor = [UIColor blackColor];
    headerView.text = [NSString stringWithFormat:@"  查询结果:%d条", self.totalCount];
    return headerView;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.row];
    NSString *wrymc_value = [item objectForKey:@"WRYMC"];
    NSString *wrydz_value = [NSString stringWithFormat:@"地址：%@", [item objectForKey:@"DWDZ"]];
    NSString *wryhylx_value = [NSString stringWithFormat:@"所属区县：%@", [item objectForKey:@"SZXZQ"]];
    NSString *wryszqy_value = [NSString stringWithFormat:@"法人代表：%@", [item objectForKey:@"FRDB"]];
    NSString *wryjgjb_value = [NSString stringWithFormat:@"监管级别：%@", [item objectForKey:@"HBJGJB"]];
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:wrymc_value  andSubvalue1:wrydz_value andSubvalue2:wryhylx_value andSubvalue3:wryszqy_value  andSubvalue4:wryjgjb_value andNoteCount:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

#define ONE_PAGE_SIZE 25

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    int pages = self.totalCount%ONE_PAGE_SIZE == 0 ? self.totalCount/ONE_PAGE_SIZE : self.totalCount/ONE_PAGE_SIZE+1;
    if(self.currentPage == pages || pages == 0 || self.totalCount <= 25)
    {
        return;
    }
	if (self.isLoading)
    {
        return;
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        self.currentPage++;
        [self requestData];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *item = [self.listDataArray objectAtIndex:indexPath.row];
    
    
    WryJbxxController *childView = [[[WryJbxxController alloc] initWithNibName:@"WryJbxxController" bundle:nil] autorelease];
    childView.wrybh = [item objectForKey:@"WRYBH"];
    childView.wrymc = [item objectForKey:@"WRYMC"];
    childView.wryjc = [item objectForKey:@"WRYJC"];
    
    [self.navigationController pushViewController:childView animated:YES];
}

#pragma mark - Network Handler Methods

/**
 * 获取污染源企业数据
 * 参数1:service(这里固定为QUERY_WRY_LIST, 必选)
 * 参数2:WRYMC(污染源名称, 可选)
 * 参数3:jgjb(污染源监管级别, 可选)
 * 参数3:dwdz(污染源企业地址, 可选)
 * 参数3:hylx(污染源行业类型, 可选)
 * ...
 */
- (void)requestData
{
    self.isLoading = YES;
 
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"%d",self.currentPage] forKey:@"P_CURRENT"];
    
    if(self.nameField.text != nil && self.nameField.text.length > 0)
    {
        [params setObject:self.nameField.text forKey:@"WRYMC"];
    }
    
    //地址
    if(self.addressField.text != nil && self.addressField.text.length > 0)
    {
        [params setObject:self.addressField.text forKey:@"WRYDZ"];
    }
    //单位类型
    if(self.dwlxField.text != nil && self.dwlxField.text.length > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%d", self.selectedDWLX] forKey:@"dwlx"];
    }
    if(self.jgjbField.text != nil && self.jgjbField.text.length > 0)
    {
        [params setObject:[NSString stringWithFormat:@"%d",self.selectedJGJB] forKey:@"JGJB"];
    }
    else if (self.isFrist){
        self.isFrist = NO;
        [params setObject:[NSString stringWithFormat:@"%d",self.selectedJGJB] forKey:@"JGJB"];
    }
    
    NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:params];
    self.urlString = strUrl;
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:self.urlString andParentView:self.view delegate:self];
}

- (void)processWebData:(NSData *)webData
{
    self.isLoading = NO;
    if(webData.length <= 0)
    {
        return;
    }
    NSString *jsonStr = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSDictionary *detailDict = [jsonStr objectFromJSONString];
    BOOL bParsedError = NO;
    if(detailDict != nil)
    {
        self.totalCount = [[detailDict objectForKey:@"totalCount"] intValue];
        NSArray *tmpAry = [detailDict objectForKey:@"data"];
        if(tmpAry.count > 0)
        {
            [self.listDataArray addObjectsFromArray:tmpAry];
        }
    }
    else
    {
        bParsedError = YES;
    }
    [self.listTableView reloadData];
    if(bParsedError)
    {
        [self showAlertMessage:@"解析数据出错!"];
    }
}

- (void)processError:(NSError *)error
{
    self.isLoading = NO;
    [self showAlertMessage:@"获取数据出错!"];
}

#pragma mark - Event Handler Methods

- (IBAction)searchButtonClick:(id)sender
{
    [self.nameField resignFirstResponder];
    [self.addressField resignFirstResponder];
    
    if(self.listDataArray)
    {
        [self.listDataArray removeAllObjects];
    }
    [self.listTableView reloadData];
    
    self.totalCount = 0;
    self.currentPage = 1;
    [self requestData];
}

- (void)selectWord:(id)sender
{
    if (self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
    
    UITextField *field = (UITextField *)sender;
    field.text = @"";
    self.currentTag = field.tag;
    
    switch (self.currentTag)
    {
        case kTag_DWLX_Field:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"工业",@"三产",@"市政设施",@"医疗机构",@"其他", nil];
            break;
        case kTag_JGJB_Field:
            self.wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"国控",@"省控",@"市控",@"区控",@"非控", nil];
            break;
        default:
            break;
    }
    [self.wordSelectCtrl.tableView reloadData];
    [self.wordsPopover presentPopoverFromRect:[field bounds] inView:field permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - Words Delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    switch (self.currentTag)
    {
        case kTag_DWLX_Field:
            self.dwlxField.text = words;
            self.selectedDWLX = row;
            break;
        case kTag_JGJB_Field:
            self.jgjbField.text = words;
            if(self.jgjbField.text != nil && self.jgjbField.text.length > 0)
            {
                if([words isEqualToString:@"国控"])
                {
                    self.selectedJGJB = 1;
                }
                else if([words isEqualToString:@"省控"])
                {
                    self.selectedJGJB = 2;
                }
                else if([words isEqualToString:@"市控"])
                {
                    self.selectedJGJB = 3;
                }
                else if([words isEqualToString:@"区控"])
                {
                    self.selectedJGJB = 4;
                }
                else if([words isEqualToString:@"非控"])
                {
                    self.selectedJGJB = 9;
                }
            }
            break;
    }
    
    if(self.wordsPopover)
    {
        [self.wordsPopover dismissPopoverAnimated:YES];
    }
}

#pragma mark - UITextField Delegate Method

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;//保证可以弹出选择框，没有键盘
}

@end
