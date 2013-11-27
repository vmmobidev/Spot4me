//
//  SearchViewController.h
//  SearchEngine
//
//  Created by Rahul kumar on 3/25/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"

@interface SearchViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,NSXMLParserDelegate,MBProgressHUDDelegate,UIScrollViewDelegate>{
    NSString *srchTitlStr;
    IBOutlet UITextField *srchTitlLbl;
    IBOutlet UIView *tableView1;
    IBOutlet UITableView *myTable;
    NSMutableArray *tableArray;
    IBOutlet UIButton *addressBtn;
    IBOutlet UIButton *locationBtn;
    IBOutlet UIButton *freetextBtn;
    MBProgressHUD *HUD;
    BOOL addressBool;
    BOOL locationBool;
    NSString *lat;
	NSString *lon,*title1;
    CLLocationManager *locationManager;
	//IBOutlet UIImageView *image;
	//IBOutlet UILabel *address;
	CLLocationCoordinate2D mycor;
	NSMutableString *mycuraddress;
	//int buttonno;
	//IBOutlet UIActivityIndicatorView *act;
	//IBOutlet UIButton *butt;
    NSMutableArray *contentsArray;
    NSString *srchTxtStr;
    UIScrollView* scrollView;
	UIPageControl* pageControl;
	
	BOOL pageControlBeingUsed;
}

@property (nonatomic, retain) IBOutlet UIScrollView* scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl* pageControl;


@property (retain,nonatomic)NSMutableArray *contentsArray;
//@property (retain,nonatomic) UIButton *butt;
@property(retain,nonatomic)NSString *lat;
@property(retain,nonatomic) UIActivityIndicatorView *act;
@property(retain,nonatomic)NSString *lon,*title1;
@property(retain,nonatomic) UIImageView *image;
@property(retain,nonatomic)IBOutlet UILabel *address;
@property(nonatomic,assign)CLLocationCoordinate2D mycor;
@property(nonatomic,assign)CLLocationManager *locationManager;
@property(nonatomic,retain)NSMutableString *mycuraddress;
//@property (nonatomic)int buttonno;
//-(IBAction)cancelAction;
//-(IBAction)searchAction;
- (IBAction)changePage;

-(IBAction)dropDown:(id)sender;
-(IBAction)selectSearch:(id)sender;

@end
