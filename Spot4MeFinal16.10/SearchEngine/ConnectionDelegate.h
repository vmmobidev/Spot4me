//
//  ConnectionDelegate.h
//  PrivyText
//
//  Created by Mac Mini on 14/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ConnectionDelegate
//This method would be return the data as response from the server
-(void)soapResult:(id)_result;
-(void)nextPageToken:(NSString *)nextPageToken;
@end

