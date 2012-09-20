//
//  CarmaCalendarDayCell.h
//  Carma
//
//  Created by Jeremy Lubin on 5/26/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmaDriver.h"
#import "LLDataDownloader.h"
#import "CarmaCalendarViewController.h"

@interface CarmaCalendarDayCell : UITableViewCell <LLDataDownloaderDelegate> {
    
    UIImageView *imageView;
    UILabel *dateLabel;
    UILabel *driverLabel;
    CarmaDriver *curentDriver;
    NSString *userID;
    CarmaCalendarViewController *masterCalendar;
    
    
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *driverLabel;
@property (strong, nonatomic) CarmaDriver *currentDriver;
@property (strong, nonatomic) NSString *userID;
@property (strong, nonatomic) CarmaCalendarViewController *masterCalendar;

- (void)configureCellWithDate:(NSDate *)newDate andDriver:(CarmaDriver *)newDriver;

@end
