//
//  SearchViewController.m
//  SearchEngine
//
//  Created by Rahul kumar on 3/25/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchNextViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "SearchResultViewController.h"
#import "Connection.h"
#import "MapViewController.h"
#import "AboutViewController.h"
@interface SearchViewController ()

@end

@implementation SearchViewController
@synthesize contentsArray,lat,lon,mycuraddress,mycor,title1;
@synthesize scrollView, pageControl;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"SEARCH";
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
    UIButton* infoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
	[infoButton addTarget:self action:@selector(infoButtonAction) forControlEvents:UIControlEventTouchUpInside];
	UIBarButtonItem *modalButton = [[UIBarButtonItem alloc] initWithCustomView:infoButton];
	[self.navigationItem setRightBarButtonItem:modalButton animated:YES];
//	[modalButton release];
    
    srchTitlLbl.userInteractionEnabled = NO;
    srchTitlStr = [[NSString alloc]init];
	// Do any additional setup after loading the view, typically from a nib.
    pageControlBeingUsed = NO;
	
	self.scrollView.contentSize = CGSizeMake(self.scrollView.frame.size.width*4 , self.scrollView.frame.size.height);
	self.pageControl.currentPage = 0;
	self.pageControl.numberOfPages = 4;
}

-(void)infoButtonAction{
    
    AboutViewController *abt = [[AboutViewController alloc]initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:abt animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)sender {
	if (!pageControlBeingUsed) {
		// Switch the indicator when more than 50% of the previous/next page is visible
		CGFloat pageWidth = self.scrollView.frame.size.width;
		int page = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
		self.pageControl.currentPage = page;
	}
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
	pageControlBeingUsed = NO;
}

- (IBAction)changePage {
	// Update the scroll view to the appropriate page
	CGRect frame;
	frame.origin.x = self.scrollView.frame.size.width * self.pageControl.currentPage;
	frame.origin.y = 0;
	frame.size = self.scrollView.frame.size;
	[self.scrollView scrollRectToVisible:frame animated:YES];

	pageControlBeingUsed = YES;
}


-(IBAction)dropDown:(id)sender{
    tableArray = [[NSMutableArray alloc] initWithObjects:@"Petrol Bunk",@"Hospitals",@"ATM's",@"Hotels",@"Cinema Halls",@"School",@"Restaurant",@"Medical Shop",@"Coffee", nil];
    tableView1.frame = CGRectMake(80, 122, 181, 240);
    //mealDishingView.frame = CGRectMake(238, 42, 774, 662);
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFromTop; //choose your animation
    [tableView1.layer addAnimation:transition forKey:nil];
    //mealScroll.contentSize = CGSizeMake(700, 880);
    [self.view addSubview:tableView1];
}
-(IBAction)selectSearch:(id)sender{
    if ([srchTitlLbl.text length]==0) {
        UIAlertView *alrt = [[UIAlertView alloc]initWithTitle:@"Message" message:@"Please select item to search" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alrt show];
    }else{
        //////
        NSStringEncoding enc;
        NSError *error;
        NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] usedEncoding:&enc error:&error];
        if (connected == nil) {
            NSString * infoString = [NSString stringWithFormat:@"Please check your internet connection and try again."];
            UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [infoAlert show];
        } else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        HUD.delegate = self;
        HUD.labelText = @"Searching...";
        //HUD.detailsLabelText = @"updating data";
        HUD.square = YES;
        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        [self.view addSubview:HUD];
        //[self search];
    }
    }
}

-(void)search:(id)sender{
    
    MapViewController *srch = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [srch setSrchTxtStr:srchTxtStr];
    [srch setMycuraddress:mycuraddress];
    [srch setTitleStr:sender];
    [self.navigationController pushViewController:srch animated:YES];
    
}

-(void)soapResult:(id)_result{
    NSLog(@"%@",_result);
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"Distance"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedArray = [_result sortedArrayUsingDescriptors:sortDescriptors];
    NSLog(@"Sorted%@",sortedArray);
    
    contentsArray = [sortedArray copy];
    
    [HUD hide:YES];
     MapViewController *srch = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
     //[srch setDataArray:contentsArray];
    [srch setTitle:srchTitlLbl.text];
    [self.navigationController pushViewController:srch animated:YES];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    NSStringEncoding enc;
    NSError *error;
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] usedEncoding:&enc error:&error];
    if (connected == nil) {
        NSString * infoString = [NSString stringWithFormat:@"Please check your internet connection and try again."];
        UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [infoAlert show];
    } else {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    
    HUD.delegate = self;
    HUD.labelText = @"Getting loc...";
    //HUD.detailsLabelText = @"updating data";
    HUD.square = YES;
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:HUD];
    srchTitlLbl.userInteractionEnabled = NO;
    [addressBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
    [locationBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
    [freetextBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
    [self currentLoc];
    }
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [tableArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [myTable dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [tableArray objectAtIndex:indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    srchTitlLbl.text = [tableArray objectAtIndex:indexPath.row];
    CATransition *transition = [CATransition animation];
    transition.duration = 0.5;
    transition.type = kCATransitionFade; //choose your animation
    [tableView1.layer addAnimation:transition forKey:nil];
    [tableView1 removeFromSuperview];

}

-(IBAction) selectButtonAction : (id) sender
{
 	UIButton *btn = (UIButton *) sender;
    NSStringEncoding enc;
    NSError *error;
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] usedEncoding:&enc error:&error];
    if (connected == nil) {
        NSString * infoString = [NSString stringWithFormat:@"Please check your internet connection and try again."];
        UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [infoAlert show];
    } else {
        
//        HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:HUD];
//        
//        HUD.delegate = self;
//        HUD.labelText = @"Searching";
//        //HUD.detailsLabelText = @"updating data";
//        HUD.square = YES;
//        
//        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        if(btn.tag == 1)
        {
            srchTxtStr = @"atm";
            [self search:srchTxtStr];
        }
        if(btn.tag==2)
        {
            srchTxtStr = @"airport";
            [self search:srchTxtStr];
        }
        if(btn.tag == 3)
        {
            srchTxtStr = @"bank";
            [self search:srchTxtStr];
        }
        if(btn.tag==4)
        {
            srchTxtStr = @"department_store";
            [self search:srchTxtStr];
        }
        if(btn.tag == 5)
        {
            srchTxtStr = @"hospital";
            [self search:srchTxtStr];
        }
        if(btn.tag==6)
        {
            srchTxtStr = @"book_store";
            [self search:srchTxtStr];
        }
        if(btn.tag == 7)
        {
            
            srchTxtStr = @"bus_station";
            [self search:srchTxtStr];
        }
        if(btn.tag==8)
        {
            srchTxtStr = @"cafe";
            [self search:srchTxtStr];
        }
        if(btn.tag == 9)
        {
            
            srchTxtStr = @"grocery_or_supermarket";
            [self search:srchTxtStr];
        }
        if(btn.tag==10)
        {
            srchTxtStr = @"movie_theater";
            [self search:srchTxtStr];
        }
        if(btn.tag == 11)
        {
            srchTxtStr = @"restaurant";
            [self search:srchTxtStr];
        }
        if(btn.tag==12)
        {
            srchTxtStr = @"doctor";
            [self search:srchTxtStr];
        }
        if(btn.tag == 13)
        {
            srchTxtStr = @"dentist";
            [self search:srchTxtStr];
        }
        if(btn.tag==14)
        {
            srchTxtStr = @"cafe";
            [self search:srchTxtStr];
        }
        if(btn.tag == 15)
        {
            srchTxtStr = @"clothing_store";
            [self search:srchTxtStr];
        }
        if(btn.tag==16)
        {
            srchTxtStr = @"electronics store";
            [self search:srchTxtStr];
        }
        if(btn.tag == 17)
        {
            srchTxtStr = @"food";
            [self search:srchTxtStr];
        }
        if(btn.tag==18)
        {
            srchTxtStr = @"beauty_salon";
            [self search:srchTxtStr];
        }
        if(btn.tag == 19)
        {
            srchTxtStr = @"car_rental";
            [self search:srchTxtStr];
        }
        if(btn.tag==20)
        {
            srchTxtStr = @"Car Repair";
            [self search:srchTxtStr];
        }
        if(btn.tag == 21)
        {
            srchTxtStr = @"car_wash";
            [self search:srchTxtStr];
        }
        if(btn.tag==22)
        {
            srchTxtStr = @"hotel";
            [self search:srchTxtStr];
        }
        if(btn.tag == 23)
        {
            srchTxtStr = @"gas_station";
            [self search:srchTxtStr];
        }
        if(btn.tag==24)
        {
            srchTxtStr = @"florist";
            [self search:srchTxtStr];
        }
        if(btn.tag == 25)
        {
            srchTxtStr = @"hindu_temple";
            [self search:srchTxtStr];
        }
        if(btn.tag==26)
        {
            srchTxtStr = @"church";
            [self search:srchTxtStr];
        }
        if(btn.tag == 27)
        {
            srchTxtStr = @"library";
            [self search:srchTxtStr];
        }
        if(btn.tag==28)
        {
            srchTxtStr = @"lodging";
            [self search:srchTxtStr];
        }
        if(btn.tag == 29)
        {
            srchTxtStr = @"museum";
            [self search:srchTxtStr];
        }
        if(btn.tag==30)
        {
            srchTxtStr = @"park";
            [self search:srchTxtStr];
        }
        if(btn.tag == 31)
        {
            srchTxtStr = @"parking";
            [self search:srchTxtStr];
        }
        if(btn.tag==32)
        {
            srchTxtStr = @"pharmacy";
            [self search:srchTxtStr];
        }
        if(btn.tag ==33)
        {
            srchTxtStr = @"pizza";
            [self search:srchTxtStr];
        }
        if(btn.tag==34)
        {
            srchTxtStr = @"police";
            [self search:srchTxtStr];
        }
        if(btn.tag == 35)
        {
            srchTxtStr = @"shopping_mall";
            [self search:srchTxtStr];
        }
        if(btn.tag== 36)
        {
            srchTxtStr = @"grocery_or_supermarket";
            [self search:srchTxtStr];
        }
        if(btn.tag == 37)
        {
            srchTxtStr = @"train_station";
            [self search:srchTxtStr];
        }
        if(btn.tag==38)
        {
            srchTxtStr = @"taxi_stand";
            [self search:srchTxtStr];
        }
        if(btn.tag == 39)
        {
            srchTxtStr = @"post_office";
            [self search:srchTxtStr];
        }
        if(btn.tag==40)
        {
            srchTxtStr = @"stadium";
            [self search:srchTxtStr];
        }
        if(btn.tag == 41)
        {
            srchTxtStr = @"spa";
            [self search:srchTxtStr];
        }
        if(btn.tag==42)
        {
            srchTxtStr = @"wifi";
            [self search:srchTxtStr];
        }
        if(btn.tag == 43)
        {
            srchTxtStr = @"travel_agency";
            [self search:srchTxtStr];
        }
        if(btn.tag==44)
        {
            srchTxtStr = @"zoo";
            [self search:srchTxtStr];
        }
        if(btn.tag == 45)
        {
            srchTxtStr = @"night_club";
            [self search:srchTxtStr];
        }
        if(btn.tag==46)
        {
            srchTxtStr = @"night_club";
           [self search:srchTxtStr];
        }
        if(btn.tag == 47)
        {
            srchTxtStr = @"liquor_store";
            [self search:srchTxtStr];
        }
        if(btn.tag==48)
        {
            srchTxtStr = @"bar";
            [self search:srchTxtStr];
        }

    }
   
}

-(IBAction)freeTextButtonAction : (id) sender
{
 	//UIButton *btn = (UIButton *) sender;
    if(freetextBtn.tag==3)
    {
        freetextBtn.tag = 4;
        srchTitlLbl.userInteractionEnabled = YES;
        freetextBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [freetextBtn setImage:[UIImage imageNamed:@"active_radio.png"] forState:UIControlStateNormal];
        //[addrssBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
    }
 	else if(freetextBtn.tag==4)
	{
        freetextBtn.tag = 3;
        freetextBtn.imageView.contentMode = UIViewContentModeScaleToFill;
        [freetextBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
        //[addrssBtn setImage:[UIImage imageNamed:@"radio_btn.png"] forState:UIControlStateNormal];
        srchTitlLbl.userInteractionEnabled = NO;
    }
    
}



- (void)myTask {
      sleep(10000);
 }

-(void)currentLoc{
    locationManager = [[CLLocationManager alloc] init];
	locationManager.delegate = self;
	locationManager.distanceFilter = kCLDistanceFilterNone; // whenever we move
	locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters; // 100 m
	[locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
	NSLog(@"in core location delegate");
	
	NSLog(@"the current location lat=%f, lon=%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
	
	lat=[NSString stringWithFormat:@"%f",newLocation.coordinate.latitude];
	lon=[NSString stringWithFormat:@"%f",newLocation.coordinate.longitude];
	
	NSLog(@"LAT %@ lONG %@",lat,lon);
    
	[locationManager stopUpdatingLocation];
    
	[[NSUserDefaults standardUserDefaults]setObject:lat forKey:@"Latitude"];
    [[NSUserDefaults standardUserDefaults]setObject:lon forKey:@"Longitude"];
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
    [HUD hide:YES];
     [locationManager stopUpdatingLocation];
	
 }
-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	NSLog(@"ENTREREING PARSE FUN");
			//NSLog(@" the value of the i=%d",i);
        
    if([elementName isEqualToString:@"long_name"]){
        
    }
        
	
	
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}


-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	
			[mycuraddress appendString:string];
			[mycuraddress appendString:@","];
            NSLog(@"the value =%@",string);
            
		
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
	
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
