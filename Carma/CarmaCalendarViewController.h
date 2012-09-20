//
//  CarmaCalendarViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 5/21/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarmaRootViewController.h"
#import "CarmaCalendarView.h"
#import "LLDataDownloader.h"
#import "LLSwipePanel.h"

@interface CarmaCalendarViewController : UITableViewController <LLDataDownloaderDelegate> {
    
    NSMutableArray *days;
    NSMutableDictionary *drivers;
    UIBarButtonItem *todayButton;
    LLSwipePanel *mapPanel;
    NSIndexPath *todayIndex;
    NSString *userID;
    
}

@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSMutableDictionary *drivers;
@property (strong, nonatomic) UIBarButtonItem *todayButton;
@property (strong, nonatomic) LLSwipePanel *mapPanel;
@property (strong, nonatomic) NSIndexPath *todayIndex;
@property (strong, nonatomic) NSString *userID;

- (void)scrollToToday;
- (void)userDidSignIn:(NSNotification *)notification;

@end
