//
//  SearchNextViewController.m
//  SearchEngine
//
//  Created by Rahul kumar on 3/25/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import "SearchNextViewController.h"
#import "SearchResultViewController.h"
#import "Connection.h"
@interface SearchNextViewController ()

@end

@implementation SearchNextViewController
@synthesize srchStr,contentsArray;

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
    self.navigationItem.title = @"ADDRESS";
    // Do any additional setup after loading the view from its nib.
}

- (void)nextPageToken:(NSString *)nextPageToken
{
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
	if((textField == stateFld) || (textField == countryFld))
	{
		self.view.center = CGPointMake(160,120);
		
	}
	else {
		self.view.center = CGPointMake(160,220);
		
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	
		[textField resignFirstResponder];
		self.view.center = CGPointMake(160,220);
		
	//[textField resignFirstResponder];
    //self.image.frame = CGRectMake(0,44,320,387 );
    
	return YES;
}



-(IBAction)search:(id)sender{
    [streetFld resignFirstResponder];
    [cityFld resignFirstResponder];
    [stateFld resignFirstResponder];
    [countryFld resignFirstResponder];
    
    self.view.center = CGPointMake(160,220);
   // for (int i=0; i<4; i++) {
    NSStringEncoding enc;
    NSError *error;
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] usedEncoding:&enc error:&error];
    if (connected == nil) {
        NSString * infoString = [NSString stringWithFormat:@"Please check your internet connection and try again."];
        UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Network Connection Error" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [infoAlert show];
    } else {
        HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.delegate = self;
        HUD.labelText = @"Searching....";
        HUD.square = YES;
        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
        NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
        // [query appendString:[NSString stringWithFormat:@"%@,%@",lat,lon]];// here im appending string to the query
        //[query appendString:[NSString stringWithFormat:@"&types=%@",mycuraddress]];
        //[query appendString:@"&key="];
        [query appendString:[NSString stringWithFormat:@"&start=%d",0]];
        [query appendString:[NSString stringWithFormat:@"&q=%@",self.srchStr]];
       // [query appendString:self.srchStr];// here im appending string to the query
		[query appendString:[NSString stringWithFormat:@",%@",streetFld.text]];
		[query appendString:[NSString stringWithFormat:@",%@",cityFld.text]];
		[query appendString:[NSString stringWithFormat:@",%@",stateFld.text]];
		[query appendString:[NSString stringWithFormat:@",%@",countryFld.text]];
        [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@,%@,%@,%@",streetFld.text,cityFld.text,stateFld.text,countryFld.text] forKey:@"AddrsStr"];
    NSLog(@"QUeryyyy iss %@",query);
    contentsArray = [NSMutableArray new];
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
//	NSURL *url= [[NSURL alloc] initWithString:query]; // Create an NSuRl object
//	NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//	NSLog(@"the data=%@",data);
//        HUD = [[MBProgressHUD alloc] initWithView:self.view];
//        [self.view addSubview:HUD];
//        
//        HUD.delegate = self;
//        HUD.labelText = @"Getting Loc";
//        //HUD.detailsLabelText = @"updating data";
//        HUD.square = YES;
//        
//        [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
//	NSString *contents = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//	NSLog(@"the content=%@",contents);
//	
//	
//    NSError *er;
//	
//	//NSDictionary *accountant = [[contents JSONValue] objectForKey:@"responseData"];
//    NSDictionary *accountant = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&er];//[[NSMutableDictionary alloc] init];
//    accountant = [accountant objectForKey:@"responseData"];
//	NSArray *results = [accountant objectForKey:@"results"];
//	NSLog(@"results %@",results);
//	
// 	for(int i = 0 ; i < [results count];i++)
//	{
//		
//		NSMutableDictionary *dict = [NSMutableDictionary new];
//		NSString *lati = [[results objectAtIndex:i]objectForKey:@"lat"];
//		
//		NSString *title = [[results objectAtIndex:i]objectForKey:@"titleNoFormatting"];
//		NSString *longi = [[results objectAtIndex:i]objectForKey:@"lng"];
//		NSString *addr = [[results objectAtIndex:i]objectForKey:@"streetAddress"];
//		NSString *country = [[results objectAtIndex:i]objectForKey:@"country"];
//		NSString *city = [[results objectAtIndex:i]objectForKey:@"city"];
//		NSString *region = [[results objectAtIndex:i]objectForKey:@"region"];
//		
//		NSLog(@"addrs %@",addr);
//        @try {
//            [dict setObject:title forKey:@"title"];
//		[dict setObject:addr forKey:@"Address"];
//		[dict setObject:longi forKey:@"longitude"];
//		[dict setObject:lati forKey:@"latitude"];
//		[dict setObject:country forKey:@"country"];
//		[dict setObject:city forKey:@"city"];
//		
//		[dict setObject:region forKey:@"region"];
//		
//		NSLog(@"the dict value= %@",dict);
//		
//		[contentsArray addObject:dict];
//         }
//        @catch (NSException *exception) {
//            NSLog(@"%@",exception);
//        }
//        @finally {
//            NSLog(@"Finally");
//        }
//
//    }
//	}
// 	if([self.contentsArray count] == 0)
//	{
//		UIAlertView *alt = [[UIAlertView alloc]initWithTitle:@"Message" message:@"No Data Available" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
//		[alt show];
// 	}
//    
//    SearchResultViewController *srch = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
//    [HUD hide:YES];
//    [srch setDataArray:contentsArray];
//    [srch setTitle:self.srchStr];
//    [self.navigationController pushViewController:srch animated:YES];
    
   //  [self.mytable reloadData];
}
 
}

-(void)soapResult:(id)_result{
    NSLog(@"%@",_result);
    contentsArray = [_result copy];
    [HUD hide:YES];
    SearchResultViewController *srch = [[SearchResultViewController alloc] initWithNibName:@"SearchResultViewController" bundle:nil];
    [srch setDataArray:contentsArray];
    [srch setTitle:self.srchStr];
    [self.navigationController pushViewController:srch animated:YES];
}


- (void)myTask {
    sleep(10000);
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
