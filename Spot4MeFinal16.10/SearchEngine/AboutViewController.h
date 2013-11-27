//
//  AboutViewController.h
//  doleApplicationSupport
//
//  Created by Rahul kumar on 12/4/12.
//  Copyright (c) 2012 Vmoksha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface AboutViewController : UIViewController<UIWebViewDelegate,MBProgressHUDDelegate>{
    UIWebView *web;
    MBProgressHUD *HUD;
    IBOutlet UITextField *mytextField;
}

-(IBAction)webLoad:(id)sender;

@end
