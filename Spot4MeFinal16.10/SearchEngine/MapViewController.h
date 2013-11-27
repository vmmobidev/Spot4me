//
//  MapViewController.h
//  SearchEngine
//
//  Created by Rahul kumar on 4/2/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MBProgressHUD.h"
#import <CoreLocation/CoreLocation.h>
#import "ConnectionDelegate.h"

@interface MapViewController : UIViewController<MKMapViewDelegate,MBProgressHUDDelegate,CLLocationManagerDelegate,UITableViewDataSource,UITableViewDelegate,ConnectionDelegate>{
    NSMutableArray *mapAnnotationArray;
    IBOutlet MKMapView *myMap;
    NSString *latStr;
    NSString *longStr;
    NSString *addrsStr;
    NSString *srchTxtStr;
    NSString *mycuraddress;
    MBProgressHUD *HUD;
    IBOutlet UISegmentedControl *segmentedControl;
    NSMutableArray *contentArray;
    BOOL srchBool1;
    BOOL srchBool2;
    BOOL srchBool3;
    BOOL srchBool4;
    UIButton *barBtn;
    MKPinAnnotationView *annView;
    CLLocationCoordinate2D locationNw;
    CLLocationManager *locationManager;
    UIBarButtonItem *anotherButton;
    IBOutlet  UIView *detailVw;
    IBOutlet UITableView *myTable;
    NSMutableArray *dataArray;
    NSString *titleStr;
    IBOutlet UIActivityIndicatorView *activity;
    IBOutlet UILabel *titleLbl;
    IBOutlet UILabel *subTitleLble,*botmLbl1,*botmLbl2;
    IBOutlet UIView *detailPopView;
}
@property(nonatomic,retain)IBOutlet UISegmentedControl *segmentedControl;
@property(nonatomic,retain)NSString *latStr;
@property(nonatomic,retain)NSString *longStr;
@property(nonatomic,retain)NSString *addrsStr;
@property(nonatomic,retain)IBOutlet MKMapView *myMap;
@property(nonatomic,retain)NSString *srchTxtStr;
@property(nonatomic,retain)NSString *mycuraddress;
@property(nonatomic,retain)NSString *titleStr;
@property (nonatomic, strong) NSString *nextPageToken;


@end
