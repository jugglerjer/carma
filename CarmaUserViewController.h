//
//  CarmaUserViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmaDriver.h"
#import "LLDataDownloader.h"
#import "CarmaProfileLocationViewController.h"
#import "CarmaProfileEditViewController.h"

@interface CarmaUserViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LLDataDownloaderDelegate, CarmaProfileLocationViewControllerDelegate>
{
    CarmaDriver *user;
    UITableView *profileTable;
    NSMutableArray *icons;
    NSMutableArray *buttons;
    CarmaProfileEditViewController *visibleViewController;
    
    BOOL isEditing;
}

@property (strong, nonatomic) CarmaProfileEditViewController *visibleViewController;
@property (strong, nonatomic) CarmaDriver *user;
@property (strong, nonatomic) UITableView *profileTable;
@property (strong, nonatomic) NSMutableArray *icons;
@property (strong, nonatomic) NSMutableArray *buttons;

@end
