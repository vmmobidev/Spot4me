//
//  SearchdetailsViewController.h
//  SearchEngine
//
//  Created by Rahul kumar on 3/26/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchdetailsViewController : UIViewController{
    IBOutlet UILabel *titlLbl;
    IBOutlet UILabel *addrsLbl;
    NSMutableArray *details;
    
 }

@property(nonatomic,retain)NSMutableArray *details;

@end
