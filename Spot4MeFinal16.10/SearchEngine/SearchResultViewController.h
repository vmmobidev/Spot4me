//
//  SearchResultViewController.h
//  SearchEngine
//
//  Created by Rahul kumar on 3/26/13.
//  Copyright (c) 2013 Rahul kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "ConnectionDelegate.h"

@interface SearchResultViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,ConnectionDelegate>{
    IBOutlet UITableView *myTable;
    NSMutableArray *dataArray;
    NSString *titlStr;
    MBProgressHUD *HUD;
    NSString *srchStr;
    NSString *addrsStr;
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    IBOutlet UIButton *btn4;
    UIBarButtonItem *anotherButton;
}
@property(nonatomic,retain) NSMutableArray *dataArray;
@property(nonatomic,retain)  NSString *titlStr;
@end
