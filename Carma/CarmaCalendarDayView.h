//
//  CarmaCalendarDayView.h
//  Carma
//
//  Created by Jeremy Lubin on 5/21/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmaDriver.h"
#import "LLDataDownloader.h"

@interface CarmaCalendarDayView : UIViewController <LLDataDownloaderDelegate> {
    
    UIImageView *imageView;
    UIView      *backgroundView;
    UILabel     *weekdayLabel;
    UILabel     *dayLabel;
    UILabel     *monthLabel;
    
    NSDate      *date;
    CarmaDriver *currentDriver;
    
}

@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UIView *backgroundView;
@property (strong, nonatomic) IBOutlet UILabel *weekdayLabel;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) CarmaDriver *currentDriver;

- (void)configureView;

@end
