//
//  RequestOANumberObject.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-29.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "RequestNumberObject.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "LoginedUsrInfo.h"
#import "NSURLConnHelper.h"
#import "ServiceUrlString.h"
extern MPAppDelegate *g_appDelegate;

@implementation RequestNumberObject
@synthesize curParsedData,delegate;

-(void)dealloc{
    [curParsedData release];
    [urlConnHelper release];
    [chufaConnHelper release];
    [zaoShengConnHelper release];
    [webservice release];
    [super dealloc];
}

-(void)requestOANumber{
    xfCount = 0;
    xzcfCount = 0;
    oaCount = 0;
    
    requestType = 0;
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"user" 
                                                          value:g_appDelegate.userPinYinName,nil];
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
    
	webservice = [[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"count" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self];
	[webservice run];
}

-(void)requestXFNumber{
    
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_XFTS_COUNT" forKey:@"service"];
    [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"lcbh"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
   
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
   // NSLog(@"请求地址：%@",urlString);

    requestType = 1;
    
    urlConnHelper = [[NSURLConnHelper alloc] initWithUrl:urlString andParentView:nil delegate:self];
    
}

-(void)requestChufaNumber{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_COMPLAINTS_COUNT" forKey:@"service"];
    [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    
    NSString *urlString = [ServiceUrlString generateXZCFUrlByParameters:param];

    requestType = 2;
    
    chufaConnHelper = [[NSURLConnHelper alloc] initWithUrl:urlString andParentView:nil delegate:self];
}


-(void)requestZaoShengNumber
{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_XFTS_COUNT" forKey:@"service"];
    [param setObject:@"44030100006" forKey:@"lcbh"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    
    requestType = 3;
    zaoShengConnHelper = [[NSURLConnHelper alloc] initWithUrl:urlString andParentView:nil delegate:self];
}

-(void)processWebData:(NSData*)webData{
    if (requestType == 0) {
        nParserStatus = -1;
        self.curParsedData = [NSMutableString stringWithCapacity:10];
        NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
        [xmlParser setDelegate: self];
        [xmlParser setShouldResolveExternalEntities: YES];
        [xmlParser parse];
    }
    else if(requestType == 1) {
        if([webData length] <=0 )
            return;
        NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
        NSArray *reAry = [resultJSON objectFromJSONString];
        if(reAry==nil){
            NSLog(@"requestXFNumber error1");
            return;
        }
        NSDictionary *reDic = [reAry lastObject];
        if(reDic==nil){
            NSLog(@"requestXFNumber error2");
            return;
        }

        xfCount = [[reDic objectForKey:@"COUNT"] integerValue];
            //[self requestChufaNumber];
        [delegate didFinishParsingWithCount:xfCount andType:requestType];
    }
    else if(requestType == 2){
        if([webData length] <=0 )
            return;
        NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
        
        NSArray *reAry = [resultJSON objectFromJSONString];
        if(reAry==nil){
            NSLog(@"requestChufaNumber error3");
            return;
        }
        NSDictionary *reDic = [reAry objectAtIndex:0];
        if(reDic==nil){
            NSLog(@"requestChufaNumber error4");
            return;
        }
        xzcfCount = [[reDic objectForKey:@"COUNT"] integerValue];
        [delegate didFinishParsingWithCount:xzcfCount andType:requestType];
    }
    else if(requestType == 3){
        
        if([webData length] <=0 )
            return;
        NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
        
        NSArray *reAry = [resultJSON objectFromJSONString];
        if(reAry==nil){
            NSLog(@"requestChufaNumber error5");
            return;
        }
        NSDictionary *reDic = [reAry objectAtIndex:0];
        if(reDic==nil){
            NSLog(@"requestChufaNumber error6");
            return;
        }
        zsxkCount = [[reDic objectForKey:@"COUNT"] integerValue];
        [delegate didFinishParsingWithCount:zsxkCount andType:requestType];
    }
    
}

-(void)processError:(NSError *)error{
    /*NSString *msg = @"请求数据失败。";
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];*/
    return;
}



-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	//NSLog(@"4 parser didStarElemen: namespaceURI: attributes:");
    if([elementName isEqualToString:@"countResult"])
    {
        nParserStatus = 1;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	//NSLog(@"5 parser: foundCharacters:");
	if(nParserStatus >= 0)
		[curParsedData appendString:string];
	
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
	if (nParserStatus == 1) {
        oaCount = [curParsedData integerValue];
    }	
	[curParsedData setString:@""];
	nParserStatus = -1;
}

- (void)parserDidStartDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------start--------------");
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------end--------------");
    [delegate didFinishParsingWithCount:oaCount andType:requestType];
    
}

@end
