//
//  DetailMapViewController.m
//  SearchEngine
//
//  Created by Rahul kumar on 4/24/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import "DetailMapViewController.h"
#import "MapAnnotation.h"

enum
{
    kCityAnnotationIndex = 0,
    kBridgeAnnotationIndex
};

@interface DetailMapViewController ()

@end

@implementation DetailMapViewController
@synthesize myMap,latStr,longStr,addrsStr,segmentedControl,titleStr;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = titleStr;
    mapAnnotationArray = [[NSMutableArray alloc] init];
    //self.view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 480)];
    //myMap = [[MKMapView alloc]initWithFrame:CGRectMake(0, 40, 320, 460)];
    myMap.mapType = MKMapTypeHybrid;
    //myMap.delegate = self;
    //[self.view addSubview:myMap];
    
    float latitude=[latStr floatValue];
    float longitude=[longStr floatValue];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.05;
    span.longitudeDelta=0.05;
    CLLocationCoordinate2D location; //= [self myLocation];
    location.latitude = latitude;//40.7143528 ;
    location.longitude = longitude;//-74.0059731;
    
    //    37.339386
    //    121.894955
    
    MapAnnotation *prestloc = [[MapAnnotation alloc] initWithCoordinate:location];
    [prestloc setMapaddr:titleStr];
    [prestloc setDistStr:addrsStr];
    [mapAnnotationArray insertObject:prestloc atIndex:kCityAnnotationIndex];
    region.span=span;
    region.center=location;
    [myMap setRegion:region animated:TRUE];
    [myMap regionThatFits:region];
    [myMap addAnnotation:prestloc];
    // Do any additional setup after loading the view from its nib.
}

- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    MKPinAnnotationView *annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
    annView.pinColor = MKPinAnnotationColorRed;
    annView.animatesDrop=TRUE;
    annView.canShowCallout = YES;
    annView.calloutOffset = CGPointMake(-5, 5);
    [annView setSelected:YES animated:YES];
    return annView;
}

-(IBAction)mapTypeSelection:(id)sender{
    switch (self.segmentedControl.selectedSegmentIndex) {
            
        case 0:
            myMap.mapType = MKMapTypeStandard;
            //[self simplSrch:sender];
            break;
            
        case 1:
            myMap.mapType = MKMapTypeSatellite;
            //[self advanceSrch:sender];
            break;
        case 2:
            myMap.mapType = MKMapTypeHybrid;
            //[self locationSrch:sender];
            break;
        default:
            
            break;
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
