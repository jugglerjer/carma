//
//  CarmaSettingsViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/8/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"
#import "CarmaPool.h"
#import "CarmaPoolRotationSettingsViewController.h"

@interface CarmaSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, LLDataDownloaderDelegate, CarmaPoolRotationSettingsViewControllerDelegate>
{
    UITableView *settingsTable;
    NSIndexPath *selectedIndexPath;
    CarmaPool *pool;
    int kCarpoolSection;
    int kGeoSection;
    int kNotificationsSection;
}

@property (strong, nonatomic) UITableView *settingsTable;
@property (strong, nonatomic) NSIndexPath *selectedIndexPath;
@property (strong, nonatomic) CarmaPool *pool;

- (void)carpoolInfoDidDownload:(NSNotification *)notification;

@end
