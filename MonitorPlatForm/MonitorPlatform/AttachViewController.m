    //
//  AttachViewController.m
//  EvePad
//
//  Created by yushang on 11-3-26.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AttachViewController.h"
#import "GTMBase64.h"
#import "MPAppDelegate.h"
#import "WebServiceHelper.h"

extern MPAppDelegate *g_appDelegate;

@implementation AttachViewController
@synthesize webView,attachName,guid;
@synthesize currentParsedData,currentTitle,webHelper;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

- (id)initWithTitle:(NSString *) szTitle andGUID:(NSString*) theGuid  isTif:(BOOL)aTifAttach
{
	if ((self = [super initWithNibName:@"AttachViewController" bundle:nil])) {
		self.attachName = szTitle;
		self.guid = theGuid;
		isTifAttach = aTifAttach;
		
	}
	return self;
}


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = attachName;
	
	self.currentParsedData = [NSMutableString string];
    
	[self getDetail];
	
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [super viewWillDisappear:animated];
}

- (void)getDetail
{	
	//guid = @"5:25056:0:2010:44";
    NSString *boolValue = (isTifAttach==YES?@"true":@"false");
    NSString *param = [WebServiceHelper createParametersWithKey:@"gwSign" 
                                                          value:guid,
                       @"isTIF",boolValue,nil];
    
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];

   // NSLog(@"param %@ URL %@",param, URL);
	self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"GetFileBase64Content" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self] autorelease];
	[webHelper runAndShowWaitingView:self.view];
    
}

-(void)processWebData:(NSData*)webData{
    nParserStatus = -1;
    /*
    NSString *theXML = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    [theXML release];
    */
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败。";
    
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




-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetFileBase64ContentResult"]) 
        nParserStatus = 1;
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
	if(nParserStatus >=0)
		[currentParsedData appendString:string];	

}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"GetFileBase64ContentResult"])
    {
        NSData *data = [currentParsedData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES]; 
       // NSString *str = [[NSString alloc] initWithBytes:[data bytes] length:100 encoding:NSUTF8StringEncoding];
       // NSLog(@"%@",str);
		data = [GTMBase64 decodeData:data]; 
        
		if([data length] <=0){
            [webView loadHTMLString:@"<html><h1 align=\"center\">下载文件失败</h1></html>" baseURL:nil];
            return;
            
        }
		NSString* tmpDirectory  = [NSHomeDirectory() 
                                   stringByAppendingPathComponent:@"tmp/"];
        NSString *tempFile = nil;
		if (!isTifAttach)
            if (self.isJPG) {
                tempFile = [tmpDirectory stringByAppendingPathComponent:@"正文.jpg"];
            }
            else{
                tempFile = [tmpDirectory stringByAppendingPathComponent:@"正文.doc"];
            }
            
		else
            tempFile = [tmpDirectory stringByAppendingPathComponent:@"tmp.pdf"];
		//NSLog(tempFile);
		NSFileManager *manager = [NSFileManager defaultManager];
		if ([manager fileExistsAtPath: tempFile]) 
			[manager removeItemAtPath:tempFile error:NULL];
		
		NSURL *url = [NSURL fileURLWithPath:tempFile];
		[data writeToURL:url atomically:NO];
		
		NSURLRequest *request = [NSURLRequest requestWithURL:url];
		[webView loadRequest:request];
    }
    nParserStatus = -1;
	[currentParsedData setString:@""];
	
}


- (void)parserDidStartDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------start--------------");
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
	[webView release];
	[guid release];
	[currentParsedData release];	
	[currentTitle release];
	[attachName release];
    [super dealloc];
}

@end
