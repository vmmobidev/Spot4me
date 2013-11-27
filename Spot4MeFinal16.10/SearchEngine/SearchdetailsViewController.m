//
//  SearchdetailsViewController.m
//  SearchEngine
//
//  Created by Rahul kumar on 3/26/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import "SearchdetailsViewController.h"

@interface SearchdetailsViewController ()

@end

@implementation SearchdetailsViewController
@synthesize details;
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
    titlLbl.text = [self.details valueForKey:@"title"];
    
    addrsLbl.text = [self.details valueForKey:@"Address"];
    
    
    
//    addrsLbl.text=[NSString stringWithFormat:@"%@\n%@\n%@\n%@",[self.details valueForKey:@"Address"],[self.details valueForKey:@"city"],[self.details valueForKey:@"region"],[self.details valueForKey:@"country"]];
  
    
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
