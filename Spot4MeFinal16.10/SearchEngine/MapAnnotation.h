//
//  MapAnnotation.h
//  AppMaker
//
//  Created by Rahul kumar on 3/12/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject<MKAnnotation>{
    CLLocationCoordinate2D coordinate;
    NSNumber *latitude;
    NSNumber *longitude;
    NSString *mapaddr;
    NSString *distStr;
}
@property (nonatomic, retain) NSNumber *latitude;
@property (nonatomic, retain) NSNumber *longitude;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, retain) NSString *mapaddr;
@property (nonatomic, retain) NSString *distStr;

-(id)initWithCoordinate:(CLLocationCoordinate2D)coordinate;

@end
