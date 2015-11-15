//
//  UISearchSitesController.m
//  GMEPS_HZ
//
//  Created by chen on 11-10-8.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import "UISearchSitesController.h"
#import "JSONKit.h"

#import "ServiceUrlString.h"
#import "SystemConfigContext.h"

@implementation UISearchSitesController
@synthesize dataResultArray,searchDataBar,delegate,wryTableView;
@synthesize currentPage,totalCount,urlString,isLoading;

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle
-(void)cancelSelect:(id)sender{
	[self dismissModalViewControllerAnimated:NO];
	[delegate returnSites:nil outsideComp:NO];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [searchDataBar becomeFirstResponder];
}


//查询外执法
-(IBAction)outsideDBCompany:(id)sender{
    //[searchBar becomeFirstResponder];
    if ([searchDataBar.text isEqualToString:@""]||searchDataBar.text == nil) {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"企业名称不能为空"  
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        return;

    }
    NSMutableDictionary * dic = [[NSMutableDictionary alloc ]initWithCapacity:10];
    [dic setValue:searchDataBar.text forKey:@"WRYMC"];
    
    [delegate returnSites:dic outsideComp:YES];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)searchWry:(NSString*)wrymc{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"QUERY_WRY_LIST" forKey:@"service"];
    [params setObject:wrymc forKey:@"WRYMC"];
   

    NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:params];
    self.urlString = strUrl;
    self.currentPage = 1;
    self.isLoading = YES;
    [self.dataResultArray removeAllObjects];
    self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self] ;
}

-(void)processWebData:(NSData*)webData
{
    self.isLoading = NO;
    if([webData length] <=0 )
    {
        NSString *msg = @"查询数据失败";
        [self showAlertMessage:msg];
        return;
    }
    NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];

    totalCount = 0;
    NSDictionary *dicResult = [resultJSON objectFromJSONString];
    if([dicResult isKindOfClass:[NSDictionary class]])
    {
        
        NSNumber *total = [dicResult objectForKey:@"totalCount"];
        if(total)
            totalCount = [total integerValue];
        NSArray *tmpAry = [dicResult objectForKey:@"data"];
        if(tmpAry.count > 0)
        {
            [self.dataResultArray addObjectsFromArray:tmpAry];
        }

        
    }else{
        [self showAlertMessage:@"查询数据失败"];
        return;
    }
    
    if(totalCount==0 || [dataResultArray count]==0)
        self.wryTableView.hidden = YES;        
    else
        self.wryTableView.hidden = NO;
    [wryTableView reloadData];
}

-(void)processError:(NSError *)error{
    self.isLoading = NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dataResultArray = [NSMutableArray arrayWithCapacity:10];
    
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered  
                                                             target:self action:@selector(cancelSelect:)];
	self.navigationItem.rightBarButtonItem = myBtn;
    
    self.searchDataBar.delegate = self;
    
    [self searchWry:@""];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //if(indexPath.row%2 == 0)
    //    cell.backgroundColor = LIGHT_BLUE_UICOLOR;
     
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [NSString stringWithFormat:@"查询到符合条件的污染源(%d)家",totalCount];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [dataResultArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.numberOfLines = 0;
    }
    
    NSDictionary *dic = [dataResultArray objectAtIndex:indexPath.row];
    

    cell.textLabel.text =  [dic objectForKey:@"WRYMC"];

    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    NSDictionary *dicWRY = [dataResultArray objectAtIndex:indexPath.row];
       
    [delegate returnSites:dicWRY outsideComp:NO];
    [self dismissModalViewControllerAnimated:YES];
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([searchBar.text length] > 0) {
        [self searchWry:searchBar.text];
    }
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
    if([dataResultArray count] == totalCount)
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
        NSString *strUrl = [NSString stringWithFormat:@"%@&P_CURRENT=%d",self.urlString, self.currentPage];
        self.isLoading = YES;
        
        self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self];
    }
}
@end
