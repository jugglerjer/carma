//
//  CarmaCalendarDayCellCell.m
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaCalendarDayCellCell.h"

static NSString *const UserImageURLPrefix = @"http://carma.io/styles/images/";

@implementation CarmaCalendarDayCellCell

@synthesize day;
@synthesize image;
@synthesize currentDriver;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)configureCellWithDate:(NSDate *)newDate andDriver:(CarmaDriver *)newDriver {
    
    // Check whether the user is the driver
    BOOL isYou = NO;
    if ([newDriver.uID isEqualToString:@"1"]) {
        isYou = YES;
    }
    
    // Set up cell styling
    // -----------------------
    self.textLabel.font = [UIFont systemFontOfSize:17];
    self.textLabel.textColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:1];
    self.textLabel.highlightedTextColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:1];
    
    UIView *greenBackground = [[UIView alloc] init];
    [greenBackground setBackgroundColor:[UIColor colorWithRed:197/255. green:243/255. blue:216/255. alpha:1]];
    self.selectedBackgroundView = greenBackground;
    
    if (isYou) { // Change later to reflect the user's ID
        self.detailTextLabel.textColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
        self.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
    } else {
        self.detailTextLabel.textColor = [UIColor colorWithRed:163/255. green:163/255. blue:163/255. alpha:1];
        self.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:163/255. green:163/255. blue:163/255. alpha:1];
    }
    
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    // -----------------------
    
    // Format NSDate to look like "Thursday, May 1"
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM d"];
    self.textLabel.text = [dateFormat stringFromDate:newDate];
    
    // Set the detail to inactive if there is no driver for the day
    if (newDriver == nil) {
        
        self.detailTextLabel.text = @"No carpool today";
        self.imageView.image = [UIImage imageNamed:@"day_off@2x.png"];
        
    } else {
        
        self.currentDriver = newDriver;
        
        if (isYou) {
            self.detailTextLabel.text = @"You";
        } else {
            self.detailTextLabel.text = currentDriver.firstName;
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
    }
    
}

- (void)dataHasFinishedDownloadingWithResult:(BOOL)result andData:(NSData *)data {
    
    UIImage *imageTemp = [UIImage imageWithData:data];
    currentDriver.image = imageTemp;
    self.imageView.image = imageTemp;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
