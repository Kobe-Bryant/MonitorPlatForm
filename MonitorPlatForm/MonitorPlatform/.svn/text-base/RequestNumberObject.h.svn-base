//
//  RequestOANumberObject.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-29.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSURLConnHelper.h"
#import "WebServiceHelper.h"

@protocol RequestNumberDelegate
- (void)didFinishParsingWithCount:(NSInteger)oaCount andType:(NSInteger)type; 
@end

@interface RequestNumberObject : NSObject<NSXMLParserDelegate,NSURLConnHelperDelegate>{
    NSInteger oaCount;
    NSInteger xfCount;
    NSInteger xzcfCount;
    NSInteger zsxkCount;
    NSInteger nParserStatus;
    NSInteger requestType;
    NSURLConnHelper* urlConnHelper;
    NSURLConnHelper *chufaConnHelper;
    NSURLConnHelper *zaoShengConnHelper;
    WebServiceHelper *webservice;
}

@property(nonatomic,retain) NSMutableString *curParsedData;
@property(nonatomic,retain) id<RequestNumberDelegate> delegate;
-(void)requestOANumber;
-(void)requestXFNumber;
-(void)requestChufaNumber;
-(void)requestZaoShengNumber;

@end
