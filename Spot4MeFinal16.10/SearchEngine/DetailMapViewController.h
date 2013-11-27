//
//  DetailMapViewController.h
//  SearchEngine
//
//  Created by Rahul kumar on 4/24/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface DetailMapViewController : UIViewController<MKMapViewDelegate>{
    NSMutableArray *mapAnnotationArray;
   IBOutlet MKMapView *myMap;
    NSString *latStr;
    NSString *longStr;
    NSString *addrsStr;
    NSString *titleStr;
}
@property(nonatomic,retain)NSString *latStr;
@property(nonatomic,retain)NSString *longStr;
@property(nonatomic,retain)NSString *addrsStr;
@property(nonatomic,retain)NSString *titleStr;
@property(nonatomic,retain)IBOutlet MKMapView *myMap;
@property(nonatomic,retain)IBOutlet UISegmentedControl *segmentedControl;

@end
