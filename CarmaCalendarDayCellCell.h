//
//  CarmaCalendarDayCellCell.h
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"
#import "CarmaDriver.h"

@interface CarmaCalendarDayCellCell : UITableViewCell <LLDataDownloaderDelegate> {
    
    NSDictionary *day; // TODO Change to a CarmaDay
    UIImage *image;
    CarmaDriver *curentDriver;
    
}

@property (strong, nonatomic) NSDictionary *day;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) CarmaDriver *currentDriver;

- (void)configureCellWithDate:(NSDate *)newDate andDriver:(CarmaDriver *)newDriver;

@end
