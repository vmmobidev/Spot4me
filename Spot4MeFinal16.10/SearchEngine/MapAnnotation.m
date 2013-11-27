//
//  MapAnnotation.m
//  AppMaker
//
//  Created by Rahul kumar on 3/12/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation
@synthesize latitude;
@synthesize longitude;
@synthesize coordinate,mapaddr,distStr;

-(id)initWithCoordinate:(CLLocationCoordinate2D) c{
	coordinate=c;
	//NSLog(@"%f,%f",c.latitude,c.longitude);
	return self;
}



- (NSString *)title
{
    
    NSString *string = mapaddr;
    return string;
}

// optional
- (NSString *)subtitle
{
    
    NSString *string = distStr;
    return string;
}


@end
