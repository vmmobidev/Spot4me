//
//  AboutViewController.m
//  doleApplicationSupport
//
//  Created by Rahul kumar on 12/4/12.
//  Copyright (c) 2012 Vmoksha. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.navigationItem.title = @"About";
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlackTranslucent];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString* proposedString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if([proposedString length] == 0) {
        return YES;
    }
    NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-"] invertedSet];
    if([proposedString stringByTrimmingCharactersInSet:nonNumberSet].length != [proposedString length]) {
        return NO;
    }
     //if there is more than 1 symbol of '.' or ',' return NO
    if([[proposedString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@".,"]] count] > 2) {
        return NO;
    }
    if ((textField.text.length == 3 )||( textField.text.length == 7)) {
        if (![string isEqualToString:@""]) {
         textField.text = [textField.text stringByAppendingString:@"-"];
        }
    }
     //finally check is ok, return YES
    return !([textField.text length]>11 && [string length] > range.length);
    //return YES;
}

-(IBAction)webLoad:(id)sender{
    NSStringEncoding enc;
    NSError *error;
    NSString *connected = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"http://www.google.com"] usedEncoding:&enc error:&error];
    if (connected == nil) {
        NSString * infoString = [NSString stringWithFormat:@"Running in Offline Mode Please Try After Some Time"];
        UIAlertView * infoAlert = [[UIAlertView alloc] initWithTitle:@"Network Connection Failed" message:infoString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [infoAlert show];
        [self loadView];
    } else {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 40, 320, 480)];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    web=[[UIWebView alloc]initWithFrame:CGRectMake(0, 40, 320,480)];
    NSString *url=@"http://vmokshagroup.com/index.php";
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [web loadRequest:nsrequest];
    web.delegate = self;
     [self.view addSubview:web];
    }
}

- (void)myTask {
	// Do something usefull in here instead of sleeping ...
	sleep(1000);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
