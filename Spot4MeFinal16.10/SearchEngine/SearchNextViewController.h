//
//  SearchNextViewController.h
//  SearchEngine
//
//  Created by Rahul kumar on 3/25/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ConnectionDelegate.h"

@interface SearchNextViewController : UIViewController<MBProgressHUDDelegate,ConnectionDelegate>{
    IBOutlet UITextField *streetFld;
    IBOutlet UITextField *cityFld;
    IBOutlet UITextField *stateFld;
    IBOutlet UITextField *countryFld;
    IBOutlet UICollectionView *coll;
    NSMutableArray *contentsArray;
    NSString *srchStr;
    MBProgressHUD *HUD;
}
@property(nonatomic,retain) NSMutableArray *contentsArray;
@property(nonatomic,retain)NSString *srchStr;
-(IBAction)search:(id)sender;

@end
