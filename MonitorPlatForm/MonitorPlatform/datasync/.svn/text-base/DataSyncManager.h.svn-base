//
//  DataSyncManager.h
//  GMEPS_HZ
//
//  Created by 张仁松 on 13-5-24.
//
//

#import <Foundation/Foundation.h>
#define LastSyncTime @"LastSyncTime"
#import "WebServiceHelper.h"

@interface DataSyncManager : NSObject<NSXMLParserDelegate>
{
    NSInteger nParserStatus;
    NSMutableString *curData;
    WebServiceHelper *webService;
}

-(void)syncWryList;

@end
