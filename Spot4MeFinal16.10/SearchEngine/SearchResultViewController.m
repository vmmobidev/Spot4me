//
//  SearchResultViewController.m
//  SearchEngine
//
//  Created by Rahul kumar on 3/26/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import "SearchResultViewController.h"
#import "SearchdetailsViewController.h"
#import "MapViewController.h"
#import "Connection.h"
@interface SearchResultViewController ()

@end

@implementation SearchResultViewController
@synthesize dataArray;
@synthesize titlStr;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)nextPageToken:(NSString *)nextPageToken
{
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    btn1.enabled = NO;
    self.navigationController.title = titlStr;
    srchStr = [[NSString alloc]init];
    addrsStr = [[NSString alloc]init];
    srchStr =  [[NSUserDefaults standardUserDefaults] valueForKey:@"srchText"];
    BOOL adddrss = [[NSUserDefaults standardUserDefaults] boolForKey:@"Address"];
    if (adddrss) {
        addrsStr=[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"AddrsStr"]];
    }else{
    addrsStr = [[NSUserDefaults standardUserDefaults] valueForKey:@"address"];
    }
    anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"NEXT" style:UIBarButtonItemStylePlain target:self action:@selector(buttonPressedAct:)];
    self.navigationItem.rightBarButtonItem = anotherButton;
    // Do any additional setup after loading the view from its nib.
}

-(void)next{
    
}

-(IBAction)buttonPressedAct:(id) sender{
     UIBarButtonItem *button = (UIBarButtonItem *)sender;
    //NSLog(@"button clicked = %@",[button currentTitle]);
    if ([button.title isEqualToString:@"NEXT"]) {
        [button setTitle:@"Page2"];
        [self button2:0];
        NSLog(@"page2222...");
    } else if ([button.title isEqualToString:@"Page2"]) {
        [button setTitle:@"Page3"];
        [self button3:0];
        NSLog(@"page333333...");
    } else if ([button.title isEqualToString:@"Page3"]) {
        [button setTitle:@"Page4"];
        [self button4:0];
        NSLog(@"page44444...");
    }else if ([button.title isEqualToString:@"Page4"]) {
        [button setTitle:@"NEXT"];
        [self button1:0];
        NSLog(@"page44444...");
    }
}


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
//    cell.textLabel.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"title"];
//    cell.textLabel.backgroundColor = [UIColor clearColor];
//    cell.textLabel.font = [UIFont boldSystemFontOfSize:13];
    
//    cell.detailTextLabel.text = [[dataArray objectAtIndex:indexPath.row] valueForKey:@"Address"];
//    cell.detailTextLabel.numberOfLines = 2;
//    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
//    cell.detailTextLabel.font = [UIFont boldSystemFontOfSize:13];
//    cell.detailTextLabel.textColor = [UIColor grayColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


-(void)soapResult:(id)_result{
    NSLog(@"%@",_result);
    NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"Distance"
                                                                 ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
    NSArray *sortedArray = [_result sortedArrayUsingDescriptors:sortDescriptors];
    NSLog(@"%@",sortedArray);
    dataArray = [sortedArray copy];
    [myTable reloadData];
    [HUD hide:YES];
   
}
-(IBAction)button1:(id)sender{
    btn1.enabled = NO;
    btn2.enabled = YES;
    btn3.enabled = YES;
    btn4.enabled = YES;
   // contentsArray = [NSMutableArray new];
    // NSMutableString *query =[[NSMutableString alloc]initWithString:@"https://maps.googleapis.com/maps/api/place/search/json?location="];
    //for (int i=0; i<4; i++) {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelText = @"Searching...";
    //HUD.detailsLabelText = @"updating data";
    HUD.square = YES;
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:HUD];
    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    
    [query appendString:[NSString stringWithFormat:@"&start=%d",0]];
    //[query appendString:srchTitlLbl.text];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchStr,addrsStr]];
    //[query appendString:@"&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ"];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
}

-(IBAction)button2:(id)sender{
    btn1.enabled = YES;
    btn2.enabled = NO;
    btn3.enabled = YES;
    btn4.enabled = YES;
   // contentsArray = [NSMutableArray new];
    // NSMutableString *query =[[NSMutableString alloc]initWithString:@"https://maps.googleapis.com/maps/api/place/search/json?location="];
    //for (int i=0; i<4; i++) {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    
    HUD.delegate = self;
    HUD.labelText = @"Searching...";
    //HUD.detailsLabelText = @"updating data";
    HUD.square = YES;
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:HUD];
    
    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    
    [query appendString:[NSString stringWithFormat:@"&start=%d",8]];
    //[query appendString:srchTitlLbl.text];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchStr,addrsStr]];
    //[query appendString:@"&hasNextPage=true&nextPage()=true&sensor=false"];
    //[query appendString:@"&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ"];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
}

-(IBAction)button3:(id)sender{
    btn1.enabled = YES;
    btn2.enabled = YES;
    btn3.enabled = NO;
    btn4.enabled = YES;
    //contentsArray = [NSMutableArray new];
    // NSMutableString *query =[[NSMutableString alloc]initWithString:@"https://maps.googleapis.com/maps/api/place/search/json?location="];
    //for (int i=0; i<4; i++) {
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    
    
    HUD.delegate = self;
    HUD.labelText = @"Searching...";
    //HUD.detailsLabelText = @"updating data";
    HUD.square = YES;
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:HUD];
    
    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    
    [query appendString:[NSString stringWithFormat:@"&start=%d",16]];
    //[query appendString:srchTitlLbl.text];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchStr,addrsStr]];
    //[query appendString:@"&hasNextPage=true&nextPage()=true&sensor=false"];
    //[query appendString:@"&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ"];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
}

-(IBAction)button4:(id)sender{
    //contentsArray = [NSMutableArray new];
    // NSMutableString *query =[[NSMutableString alloc]initWithString:@"https://maps.googleapis.com/maps/api/place/search/json?location="];
    //for (int i=0; i<4; i++) {
    btn1.enabled = YES;
    btn2.enabled = YES;
    btn3.enabled = YES;
    btn4.enabled = NO;
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    HUD.delegate = self;
    HUD.labelText = @"Searching...";
    //HUD.detailsLabelText = @"updating data";
    HUD.square = YES;
    
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:nil animated:YES];
    [self.view addSubview:HUD];
    NSMutableString *query =[[NSMutableString alloc]initWithString:@"http://ajax.googleapis.com/ajax/services/search/local?v=1.0&rsz=large"];
    
    [query appendString:[NSString stringWithFormat:@"&start=%d",24]];
    //[query appendString:srchTitlLbl.text];
    [query appendString:[NSString stringWithFormat:@"&q=%@,%@",srchStr,addrsStr]];
    //[query appendString:@"&hasNextPage=true&nextPage()=true&sensor=false"];
    //[query appendString:@"&key=AIzaSyC8r7rPJTCM19kyQspu5ZRtAbKzMrhmFZQ"];
    [query replaceOccurrencesOfString:@" " withString:@"%20" options:NSLiteralSearch
								range:NSMakeRange(0, [query length])];
    NSLog(@"QUeryyyy iss %@",query);
    Connection *connection = [[Connection alloc] init];
    [connection setDelegate:self];
    [connection getMethod:query];
}

- (void)myTask {
    sleep(10000);
}



-(void)buttonPressed:(id)sender{
   // NSLog(@"%d",[sender tag]);
    MapViewController *sr = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil];
    [sr setLatStr:[[dataArray objectAtIndex:[sender tag]] valueForKey:@"latitude"]];
    [sr setLongStr:[[dataArray objectAtIndex:[sender tag]] valueForKey:@"longitude"]];
    [sr setAddrsStr:[[dataArray objectAtIndex:[sender tag]] valueForKey:@"Address"]];
    [self.navigationController pushViewController:sr animated:YES];
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    SearchdetailsViewController *sr = [[SearchdetailsViewController alloc] initWithNibName:@"SearchdetailsViewController" bundle:nil];
//    [sr setDetails:[dataArray objectAtIndex:indexPath.row]];
//    [self.navigationController pushViewController:sr animated:YES];
//    srchTitlLbl.text = [tableArray objectAtIndex:indexPath.row];
//    CATransition *transition = [CATransition animation];
//    transition.duration = 0.5;
//    transition.type = kCATransitionFromTop; //choose your animation
//    [tableView1.layer addAnimation:transition forKey:nil];
//    [tableView1 removeFromSuperview];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
