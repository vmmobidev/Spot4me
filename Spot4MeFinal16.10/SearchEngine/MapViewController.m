//
//  MapViewController.m
//  SearchEngine
//
//  Created by Rahul kumar on 4/2/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import "MapViewController.h"
#import "MapAnnotation.h"
#import "Connection.h"
#import "SearchResultViewController.h"
#import "DetailMapViewController.h"
#import <QuartzCore/QuartzCore.h>

enum
{
    kCityAnnotationIndex = 0,
    kBridgeAnnotationIndex
};

@interface MapViewController ()

@end

@implementation MapViewController
@synthesize myMap,latStr,longStr,addrsStr,srchTxtStr,mycuraddress,segmentedControl,titleStr;

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
    contentArray = [NSMutableArray new];
    srchBool1 = FALSE;
    srchBool2 = FALSE;
    srchBool3 = FALSE;
    srchBool4 = FALSE;
//    MKCoordinateRegion region;
//    MKCoordinateSpan span;
//    span.latitudeDelta=0.009;
//    span.longitudeDelta=0.009;
//    region.span=span;
    activity.alpha = 0;
    dataArray = [[NSMutableArray alloc]init];
    locationManager=[[CLLocationManager alloc] init];
    locationManager.delegate=self;
    locationManager.desiredAccuracy=kCLLocationAccuracyNearestTenMeters;
    
    [locationManager startUpdatingLocation];
    [NSTimer scheduledTimerWithTimeInterval:3.0 target:self selector:@selector(searchingData) userInfo:nil repeats:NO];
//    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Click" style:UIBarButtonItemStylePlain target:self action:@selector(flipDeatilView)];
//    self.navigationItem.rightBarButtonItem = anotherButton;
    self.navigationItem.title = titleStr;
    barBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    barBtn.frame =CGRectMake(0, 0, 45, 40);
    [barBtn addTarget:self action:@selector(barButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [barBtn setImage:[UIImage imageNamed:@"icon1.png"] forState:UIControlStateNormal];
    anotherButton = [[UIBarButtonItem alloc] initWithCustomView:barBtn];
    [self.navigationItem setRightBarButtonItem:anotherButton];
    anotherButton.tag =3;
    
//    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(foundTap:)];
//    tapRecognizer.numberOfTapsRequired = 1;
//    tapRecognizer.numberOfTouchesRequired = 1;
//    [self.myMap addGestureRecognizer:tapRecognizer];
}

-(IBAction)foundTap:(UITapGestureRecognizer *)recognizer
{
    CGPoint point = [recognizer locationInView:self.myMap];
    CLLocationCoordinate2D tapPoint = [self.myMap convertPoint:point toCoordinateFromView:self.myMap];
    NSLog(@"myTap Location lattitude...%f",tapPoint.latitude);
    NSLog(@"myTap Location longitude...%f",tapPoint.longitude);
    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
    point1.coordinate = tapPoint;
    [self.myMap addAnnotation:point1];
    
    NSString *lat=[NSString stringWithFormat:@"%f",tapPoint.latitude];
	NSString *lon=[NSString stringWithFormat:@"%f",tapPoint.longitude];
    
    NSMutableString *query = [NSMutableString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%@,%@&sensor=true",lat,lon];
	[query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
	
	NSURL *url= [[NSURL alloc] initWithString:query];
	NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//	NSLog(@"the data=%@",data);
    
	NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSLog(@"the content=%@",contents);
    
    NSError *er;
	
	//NSDictionary *accountant = [[contents JSONValue] objectForKey:@"responseData"];
    NSDictionary *accountant = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&er];//[[NSMutableDictionary alloc] init];
    NSArray *contant = [accountant objectForKey:@"results"];
	NSString *results = [[contant objectAtIndex:1]valueForKey:@"formatted_address"];
	NSLog(@"results %@",results);
    
	mycuraddress = [results copy];
	NSLog(@" the full address %@",mycuraddress);
    [self searchingData];
}


- (void)mapViewWillStartLoadingMap:(MKMapView *)mapView{
//    HUD = [[MBProgressHUD alloc] initWithView:self.view];
//    
}
- (void)mapViewDidFinishLoadingMap:(MKMapView *)mapView{
    NSLog(@"stop loading");
    //[HUD hide:YES];
}

- (void)myTask {
    sleep(10000);
}


-(void)searchingData{
    NSStringEncoding enc;
    NSError *error;
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] usedEncoding:&enc error:&error];
    if (connected == nil) {
        NSString * infoString = [NSString stringWithFormat:@"Please check your internet connection and try again."];
        UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [infoAlert show];
    } else {
        activity.alpha = 1;
        [activity startAnimating];
        [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    srchBool1 = TRUE;
    srchBool2 = FALSE;
    srchBool3 = FALSE;
    srchBool4 = FALSE;
    [[NSUserDefaults standardUserDefaults]setObject:srchTxtStr forKey:@"srchText"];
    [[NSUserDefaults standardUserDefaults]setObject:mycuraddress forKey:@"address"];
        
        
        
        NSString *currentLongitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
        NSString *currentLatitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
        
        NSMutableString *query = [[NSMutableString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?v=1.13&"];
        
        [query appendString:[NSString stringWithFormat:@"location=%@,%@&rankby=distance&types=%@&sensor=true&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ",currentLatitude, currentLongitude, srchTxtStr]];
        
        NSLog(@"Query is %@",query);
        
/*
    NSLog(@" the full address %@",mycuraddress);
    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    [query appendString:[NSString stringWithFormat:@"&start=%d",0]];
    //[query appendString:srchTitlLbl.text];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchTxtStr,mycuraddress]];
    //[query appendString:@"&hasNextPage=true&nextPage()=true&sensor=false"];
    //[query appendString:@"&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ"];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
        
 
*/
        
        
        
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
    }
}


-(void)nextPageToken:(NSString *)nextPageToken
{
    _nextPageToken = nextPageToken;
}

-(void)soapResult:(id)_result{
//    NSLog(@"%@",_result);
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"Distance"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedArray = [_result sortedArrayUsingDescriptors:sortDescriptors];
//    NSLog(@"Sorted%@",sortedArray);
    contentArray = [sortedArray copy];
    [activity stopAnimating];
    //[HUD hide:YES];

    
    
    
    
    if (_nextPageToken)
    {
        srchBool4 = FALSE;
        
        
        NSMutableString *query = [[NSMutableString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?pagetoken="];
        
        [query appendString:[NSString stringWithFormat:@"%@&sensor=false&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ",_nextPageToken]];
        
        NSLog(@"Query is %@",query);
        
        
        
        Connection *connection = [[Connection alloc] init];
        [connection setDelegate:self];
        [connection getMethod:query];
        
    } else
    {    srchBool4 = TRUE;
        [activity stopAnimating];
        activity.alpha = 0;
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        //[HUD hide:YES];
        //[self button4:nil];
    }
    
    
    
    
    
//    if (srchBool4) {
//        [activity stopAnimating];
//        activity.alpha = 0;
//        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
//        //[HUD hide:YES];
//        //[self button4:nil];
//    }
//
//    if (srchBool3) {
//        [self button4:nil];
//    }
//    if (srchBool2) {
//        [self button3:nil];
//    }
//    if (srchBool1) {
//        [self button2:nil];
//    }

    
    
    
    
    [dataArray addObjectsFromArray:contentArray];
    [self showMapAnnotation];
    
}


- (void)getNextPageOfRequest: (NSString *)nextPageToken
{

}


-(IBAction)button2:(id)sender{
    srchBool1 = FALSE;
    srchBool2 = TRUE;
    srchBool3 = FALSE;
    srchBool4 = FALSE;
    
    
    
    NSString *currentLongitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
    NSString *currentLatitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
    
    NSMutableString *query = [[NSMutableString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?v=1.13&"];
    
    [query appendString:[NSString stringWithFormat:@"location=%@,%@&radius=5000&types=%@&sensor=true&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ",currentLatitude, currentLongitude, srchTxtStr]];
    
    NSLog(@"Query is %@",query);
    
    
    
/*    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    
    [query appendString:[NSString stringWithFormat:@"&start=%d",8]];
    //[query appendString:srchTitlLbl.text];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchTxtStr,mycuraddress]];
    //[query appendString:@"&hasNextPage=true&nextPage()=true&sensor=false"];
    //[query appendString:@"&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ"];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
    
*/
    
    
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
}

-(IBAction)button3:(id)sender{
    srchBool1 = FALSE;
    srchBool2 = FALSE;
    srchBool3 = TRUE;
    srchBool4 = FALSE;

    
    
    
    NSString *currentLongitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
    NSString *currentLatitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
    
    NSMutableString *query = [[NSMutableString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?v=1.13&"];
    
    [query appendString:[NSString stringWithFormat:@"location=%@,%@&radius=5000&types=%@&sensor=true&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ",currentLatitude, currentLongitude, srchTxtStr]];
    
    NSLog(@"Query is %@",query);
    
/*
    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    
    [query appendString:[NSString stringWithFormat:@"&start=%d",16]];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchTxtStr,mycuraddress]];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
    
    
*/
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
}

-(IBAction)button4:(id)sender{

    srchBool1 = FALSE;
    srchBool2 = FALSE;
    srchBool3 = FALSE;
    srchBool4 = TRUE;
    
    NSString *currentLongitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Longitude"];
    NSString *currentLatitude = [[NSUserDefaults standardUserDefaults] objectForKey:@"Latitude"];
    
    NSMutableString *query = [[NSMutableString alloc] initWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?v=1.13&"];
    
    [query appendString:[NSString stringWithFormat:@"location=%@,%@&radius=5000&types=%@&sensor=true&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ",currentLatitude, currentLongitude, srchTxtStr]];
    
    NSLog(@"Query is %@",query);
    
    
/*
    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    [query appendString:[NSString stringWithFormat:@"&start=%d",24]];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchTxtStr,mycuraddress]];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
 
 */
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
}






-(void)showMapAnnotation{
    for (int i=0; i<[contentArray count];i++) {
        mapAnnotationArray = [[NSMutableArray alloc] init];
        float latitude=[[[contentArray objectAtIndex:i]objectForKey:@"latitude"] floatValue];
        float longitude=[[[contentArray objectAtIndex:i]objectForKey:@"longitude"] floatValue];
    
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
        [prestloc setMapaddr:[NSString stringWithFormat:@"%@(%.2f km)",[[contentArray objectAtIndex:i]objectForKey:@"title"],[[[contentArray objectAtIndex:i]objectForKey:@"Distance"] floatValue]]];
        [prestloc setDistStr:[[contentArray objectAtIndex:i]objectForKey:@"Address"]];
        [mapAnnotationArray insertObject:prestloc atIndex:kCityAnnotationIndex];
        region.span=span;
        [myMap addAnnotation:prestloc];
        
    }


}

-(IBAction)barButtonAction : (id) sender
{
    UIBarButtonItem *button = (UIBarButtonItem *)sender;
 	//UIButton *btn = (UIButton *) sender;
    NSLog(@"Sender tag..%d",button.tag);
    if(anotherButton.tag==3)
    {
        anotherButton.tag = 4;
        barBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [barBtn setImage:[UIImage imageNamed:@"icon2.png"] forState:UIControlStateNormal];
        [self flipDeatilView];
        //[addrssBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
    }
 	else if(anotherButton.tag==4)
	{
        anotherButton.tag = 3;
        barBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [barBtn setImage:[UIImage imageNamed:@"icon1.png"] forState:UIControlStateNormal];
        [self done:nil];
        //[addrssBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
    }
    
}

-(IBAction)done:(id)sender{
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft
                           forView:self.navigationController.view cache:NO];
    // [self.navigationController pushViewController:aboutShowViewController animated:YES];
    
    [detailVw removeFromSuperview];
    [UIView commitAnimations];
}
-(void)flipDeatilView{
    //SearchResultViewController *aboutShowViewController = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
    detailVw.Frame = CGRectMake(0, 40, 320, 440);
    [UIView beginAnimations:@"View Flip" context:nil];
    [UIView setAnimationDuration:0.80];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight
                           forView:self.navigationController.view cache:NO];
    [self.view addSubview:detailVw];
   // [self.navigationController pushViewController:aboutShowViewController animated:YES];
    [UIView commitAnimations];
    [myTable reloadData];
    //[aboutShowViewController release];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
	//mStoreLocationButton.hidden=FALSE;
    NSLog(@"in core location delegate");
	locationNw=newLocation.coordinate;
	//One location is obtained.. just zoom to that location
	
	MKCoordinateRegion region;
	region.center=locationNw;
	//Set Zoom level using Span
	MKCoordinateSpan span;
	span.latitudeDelta=.05;
	span.longitudeDelta=.05;
	region.span=span;
	
	[myMap setRegion:region animated:TRUE];
    [locationManager stopUpdatingLocation];
    
}

-(IBAction)mapTypeSelection:(id)sender{
    switch (self.segmentedControl.selectedSegmentIndex) {
            
        case 0:
            myMap.mapType = MKMapTypeStandard;
            botmLbl1.textColor = [UIColor blueColor];
            botmLbl2.textColor = [UIColor blueColor];
            //[self simplSrch:sender];
            break;
            
        case 1:
            myMap.mapType = MKMapTypeSatellite;
            botmLbl1.textColor = [UIColor blackColor];
            botmLbl2.textColor = [UIColor blackColor];
            //[self advanceSrch:sender];
            break;
        case 2:
            myMap.mapType = MKMapTypeHybrid;
            botmLbl1.textColor = [UIColor blueColor];
            botmLbl2.textColor = [UIColor blueColor];
            //[self locationSrch:sender];
            break;
        default:
            
            break;
    }

}


- (MKAnnotationView *) mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>) annotation{
    annView=[[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"location"];
   // annView.pinColor = mkpi;
    
    if ([[annotation title] isEqual: @"Current Location"]) {
       annView.pinColor = MKPinAnnotationColorRed;
        annView.animatesDrop=TRUE;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        [annView setSelected:YES animated:YES];
    }else{
    annView.pinColor = MKPinAnnotationColorGreen;
        annView.animatesDrop=TRUE;
        annView.canShowCallout = YES;
        annView.calloutOffset = CGPointMake(-5, 5);
        [annView setSelected:YES animated:YES];
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        annView.rightCalloutAccessoryView = rightButton;
    }
    
    
    return annView;
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
     NSLog(@"accessory button tapped for annotation %@", view.annotation);
    // here we illustrate how to detect which annotation type was clicked on for its callout
//    id <MKAnnotation> annotation = [view annotation];
       NSLog(@"ann.title = %@", view.annotation.subtitle);
    titleLbl.text = view.annotation.title;
    subTitleLble.text = view.annotation.subtitle;
    [UIView beginAnimations:@"animation1" context:nil];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(showDetailToFullscreen)];
    detailPopView.Frame = CGRectMake(20, 50, 280, 175);
    [UIView commitAnimations];
    [UIView commitAnimations];
    
    if (view.annotation == myMap.userLocation)
        return;
    
    
}

- (void)showDetailToFullscreen {
    [self.view addSubview:detailPopView];
}

-(IBAction)okbtnPressed:(id)sender{
    detailPopView.Frame = CGRectMake(20, 80, 280, 175);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionPush; //choose your animation
    [detailPopView.layer addAnimation:transition forKey:nil];
    [detailPopView removeFromSuperview];
    [UIView commitAnimations];
    [myMap deselectAnnotation:[myMap.selectedAnnotations objectAtIndex:0] animated:YES];


}


//////list view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [myTable dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
        //cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //[phoneButton setTitle:@"Contact" forState:UIControlStateNormal];
        //[cell.contentView addSubview:phoneButton];
        UILabel *titlelbl= [[UILabel alloc]init];
        titlelbl.frame = CGRectMake(05, 05, 200, 15);
        titlelbl.font = [UIFont boldSystemFontOfSize:13];
        titlelbl.tag = 20;
        titlelbl.backgroundColor = [UIColor clearColor];
        titlelbl.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:titlelbl];
        
        UILabel *adrsLine3lbl= [[UILabel alloc]init];
        adrsLine3lbl.frame = CGRectMake(05, 23, 240, 30);
        adrsLine3lbl.font = [UIFont boldSystemFontOfSize:13];
        adrsLine3lbl.tag = 30;
        adrsLine3lbl.textColor = [UIColor grayColor];
        adrsLine3lbl.lineBreakMode = NSLineBreakByWordWrapping;
        adrsLine3lbl.numberOfLines = 3;
        adrsLine3lbl.backgroundColor = [UIColor clearColor];
        adrsLine3lbl.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:adrsLine3lbl];
        
        UILabel *distancelbl= [[UILabel alloc]init];
        distancelbl.frame = CGRectMake(255, 50, 90, 15);
        distancelbl.font = [UIFont boldSystemFontOfSize:13];
        distancelbl.tag = 40;
        distancelbl.backgroundColor = [UIColor clearColor];
        distancelbl.highlightedTextColor = [UIColor whiteColor];
        [cell.contentView addSubview:distancelbl];
        
    }
    UIButton *phoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
    phoneButton.frame = CGRectMake(257, 10, 40,40);
    phoneButton.tag = indexPath.row;
    [phoneButton setImage:[UIImage imageNamed:@"map.png"] forState:UIControlStateNormal];
    [cell.contentView addSubview:phoneButton];
    [phoneButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *titlelbl = (UILabel *)[cell.contentView viewWithTag:20];
    UILabel *adrsLine3lbl = (UILabel *)[cell.contentView viewWithTag:30];
    UILabel *distancelbl = (UILabel *)[cell.contentView viewWithTag:40];
    
    titlelbl.text= [[dataArray objectAtIndex:indexPath.row] valueForKey:@"title"];
    adrsLine3lbl.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"Address"];
    distancelbl.text =[NSString stringWithFormat:@"%.2f km",[[[dataArray objectAtIndex:indexPath.row] valueForKey:@"Distance"] floatValue]];
      return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


-(void)buttonPressed:(id)sender{
    // NSLog(@"%d",[sender tag]);
    DetailMapViewController *sr = [[DetailMapViewController alloc] initWithNibName:@"DetailMapViewController" bundle:nil];
    [sr setLatStr:[[dataArray objectAtIndex:[sender tag]] valueForKey:@"latitude"]];
    [sr setLongStr:[[dataArray objectAtIndex:[sender tag]] valueForKey:@"longitude"]];
    [sr setAddrsStr:[[dataArray objectAtIndex:[sender tag]] valueForKey:@"Address"]];
     [sr setTitleStr:[[dataArray objectAtIndex:[sender tag]] valueForKey:@"title"]];
    [self.navigationController pushViewController:sr animated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
