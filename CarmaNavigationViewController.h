//
//  CarmaNavigationViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"
#import "CarmaDriver.h"
#import "LLSwipePanel.h"

@protocol CarmaNavigationViewControllerDelegate;

@interface CarmaNavigationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LLDataDownloaderDelegate>
{
    id<CarmaNavigationViewControllerDelegate> delegate;
    UITableView *navTable;
    CarmaDriver *driver;
    
    UIButton *powerButton;
    NSMutableArray *navButtons;
}

@property (strong, nonatomic) id<CarmaNavigationViewControllerDelegate> delegate;
@property (strong, nonatomic) UITableView *navTable;
@property (strong, nonatomic) CarmaDriver *driver;

@property (strong, nonatomic) UIButton *powerButton;
@property (strong, nonatomic) NSMutableArray *navButtons;

- (id)init;
- (void)animateIconWithScrollView:(LLSwipePanel *)scrollView;

@end

@protocol CarmaNavigationViewControllerDelegate <NSObject>

- (void)navigationView:(CarmaNavigationViewController *)navView userDidSelectNewRow:(int)row;

@end
