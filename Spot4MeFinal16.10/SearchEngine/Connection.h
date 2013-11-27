//
//  Connection.h
//  PrivyText
//
//  Created by Mac Mini on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ConnectionDelegate.h"
#import "MapViewController.h"

@interface Connection : NSObject <ConnectionDelegate, NSXMLParserDelegate>{
	
	NSMutableArray *resultArray,*finalResultArray;
	NSMutableData *receiveData;
//	NSMutableDictionary *resultDictionary;
	NSMutableDictionary *soapDictionary;
	NSString *currentElementName;
 	id<ConnectionDelegate> delegate;
    NSString *finalAdd;
    NSString *trimmedStr;
    NSMutableArray *arr;
    NSMutableArray *ctyarr;
    NSMutableArray *distanceArr;
     NSMutableArray *ofrarr;
    NSURLConnection *theConnection;
    NSMutableArray *addressArray;
    NSMutableArray *locationResult1;
    NSMutableString *FinalDistanceStr;
    NSMutableArray *FinalDistanceArray;
     NSMutableArray *FinalDistanceArray2;
    BOOL searchByZip;
    NSString *zipOrigin;
    BOOL companyLoginID;
    BOOL completedata;
    NSInteger temp1;
    BOOL offer;
    NSMutableArray *offerArray;
    NSMutableDictionary *offerDic;
    NSMutableString *currentNodeContent;
   NSString *urlstring;

}
@property (nonatomic, retain) id<ConnectionDelegate> delegate;
@property (nonatomic, retain)  NSMutableArray *FinalDistanceArray2;
@property (nonatomic, retain)  NSMutableArray *FinalDistanceArray;
-(void) getMethod:(NSString *) getStr;
//-(void) postMethod:(NSString *) getStr passedURL:(NSString *) getURL;

@end


