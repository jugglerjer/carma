//
//  CarmaCalendarDayCell.m
//  Carma
//
//  Created by Jeremy Lubin on 5/26/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaCalendarDayCell.h"
#import <QuartzCore/QuartzCore.h>

static NSString *const UserImageURLPrefix = @"http://carma.io/styles/images/";

@implementation CarmaCalendarDayCell

@synthesize imageView;
@synthesize dateLabel;
@synthesize driverLabel;
@synthesize currentDriver;
@synthesize userID;
@synthesize masterCalendar;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //CGRect frame = self.frame;
        
        UILabel *dateLabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(74, 12, 212, 36)];
        dateLabelTemp.font = [UIFont fontWithName:@"Heiti TC" size:21.0];
        dateLabelTemp.textColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:1];
        dateLabelTemp.highlightedTextColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:1];
        dateLabelTemp.backgroundColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:0];
        self.dateLabel = dateLabelTemp;
        [self addSubview:dateLabel];
        
        UILabel *driverLabelTemp = [[UILabel alloc] initWithFrame:CGRectMake(74, 36, 212, 36)];
        driverLabelTemp.font = [UIFont fontWithName:@"Heiti TC" size:17.0];
        driverLabelTemp.backgroundColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:0];
        self.driverLabel = driverLabelTemp;
        [self addSubview:driverLabel];
        
        UIImageView *imageViewTemp = [[UIImageView alloc] initWithFrame:CGRectMake(6, 12, 56, 56)];
        self.imageView = imageViewTemp;
        imageView.layer.cornerRadius = 6.0f;
        imageView.layer.masksToBounds = YES;
        [self addSubview:imageView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureCellWithDate:(NSDate *)newDate andDriver:(CarmaDriver *)newDriver {
    
    // Check whether the user is the driver
    BOOL isYou = NO;
    if ([newDriver.uID isEqualToString:userID]) {
        isYou = YES;
    }
    
    // Set up cell styling
    // -----------------------    
    UIView *greenBackground = [[UIView alloc] init];
    [greenBackground setBackgroundColor:[UIColor colorWithRed:197/255. green:243/255. blue:216/255. alpha:1]];
    self.selectedBackgroundView = greenBackground;
    
    if (isYou) {
        self.driverLabel.textColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
        self.driverLabel.highlightedTextColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
    } else {
        self.driverLabel.textColor = [UIColor colorWithRed:163/255. green:163/255. blue:163/255. alpha:1];
        self.driverLabel.highlightedTextColor = [UIColor colorWithRed:163/255. green:163/255. blue:163/255. alpha:1];
    }
    
    // Add top and bottom highlighting to give the cell dimension
//    UIImageView *topShading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_bottom.png"]];
//    topShading.frame = CGRectMake(self.frame.origin.x, 0, self.frame.size.width, 2);
//    [self addSubview:topShading];
//    
//    UIImageView *bottomShading = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_top.png"]];
//    bottomShading.frame = CGRectMake(self.frame.origin.x, 78, self.frame.size.width, 2);
//    [self addSubview:bottomShading];
    
    // Format NSDate to look like "Thursday, May 1"
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEE, MMMM d"];
    self.dateLabel.text = [dateFormat stringFromDate:newDate];
    
    // Set the detail to inactive if there is no driver for the day
    if (newDriver == nil) {
        
        self.driverLabel.text = @"No carpool today";
        self.imageView.image = [UIImage imageNamed:@"day_off@2x.png"];
        
    } else {
        
        self.currentDriver = newDriver;
        
        if (isYou) {
            self.driverLabel.text = @"You";
        } else {
            self.driverLabel.text = currentDriver.firstName;
        }
        
        if (currentDriver.image == nil) {
            self.imageView.image = [UIImage imageNamed:@"user_placeholder@2x.png"];
            
            // Load the cell image
            LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
            downloader.delegate = self;
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, currentDriver.imageURL];
            
            if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
            
        } else {
            self.imageView.image = currentDriver.image;
        }
        
        imageView.backgroundColor = [UIColor whiteColor];
        
        if ([[newDate earlierDate:[NSDate date]] isEqualToDate:newDate]) {
            imageView.alpha = 0.5;
        } else {
            imageView.alpha = 1;
        }
    }
    
}

- (void)dataHasFinishedDownloadingWithResult:(BOOL)result andData:(NSData *)data {
    
    UIImage *imageTemp = [UIImage imageWithData:data];
    
    [[masterCalendar.drivers objectForKey:curentDriver.uID] setImage:[UIImage imageWithData:data]];
    
    self.imageView.image = imageTemp;
    
}

@end
