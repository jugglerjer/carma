//
//  CarmaCalendarDayView.m
//  Carma
//
//  Created by Jeremy Lubin on 5/21/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaCalendarDayView.h"

//static CGFloat kUserImageWidth = 62;
//static CGFloat kUserImageHeight = 62;
//static CGFloat kUserImageSpace = 1;

static NSString *const UserImageURLPrefix = @"http://carma.io/styles/images/";

@implementation CarmaCalendarDayView

@synthesize imageView;
@synthesize backgroundView;
@synthesize weekdayLabel;
@synthesize dayLabel;
@synthesize monthLabel;

@synthesize date;
@synthesize currentDriver;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    self.backgroundView = nil;
    self.weekdayLabel = nil;
    self.dayLabel = nil;
    self.monthLabel = nil;
    self.currentDriver = nil;
}

- (void)configureView {
    
    // Format NSDateFormatters to look like "Thursday, March 1"
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"EEEE, MMMM d"];
    
    // Check whether it's today
    BOOL isToday = [[dateFormat stringFromDate:date] isEqualToString:[dateFormat stringFromDate:[NSDate date]]];
    
    // Set blue background if day is today
    if (isToday) {
        self.backgroundView.backgroundColor = [UIColor colorWithRed:211/255. green:231/255. blue:240/255. alpha:1];
    } else {
        self.backgroundView.backgroundColor = [UIColor whiteColor];
    }
    
    if (currentDriver == nil) {
        //self.detailTextLabel.text = @"No carpool today";
        self.imageView.image = [UIImage imageNamed:@"day_off@2x.png"];
    }
    
    else {
        // Check whether the user is the driver
        BOOL isYou = NO;
        if ([currentDriver.uID isEqualToString:@"1"]) {
            isYou = YES;
        }
        
        // Set up cell styling
        // -----------------------         
        //UIView *greenBackground = [[UIView alloc] init];
        //[greenBackground setBackgroundColor:[UIColor colorWithRed:197/255. green:243/255. blue:216/255. alpha:1]];
        //self.selectedBackgroundView = greenBackground;
         
        //if (isYou) { // Change later to reflect the user's ID
        //self.detailTextLabel.textColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
        //self.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:51/255. green:51/255. blue:51/255. alpha:1];
        //} else {
        //self.detailTextLabel.textColor = [UIColor colorWithRed:163/255. green:163/255. blue:163/255. alpha:1];
        //self.detailTextLabel.highlightedTextColor = [UIColor colorWithRed:163/255. green:163/255. blue:163/255. alpha:1];
        //}
         
        //self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;*/
        // -----------------------
        
        // Set the weekday label with format "Thu"
        [dateFormat setDateFormat:@"EEE"];
        self.weekdayLabel.text = [dateFormat stringFromDate:date];
        
        // Set the day label with format "1"
        [dateFormat setDateFormat:@"d"];
        self.dayLabel.text = [dateFormat stringFromDate:date];
        
        // Set the month label with format "Mar"
        //[dateFormat setDateFormat:@"MMM"];
        //self.monthLabel.text = [dateFormat stringFromDate:date];
        
        if (isYou) {
            //self.detailTextLabel.text = @"You";
        } else {
            //self.detailTextLabel.text = currentDriver.firstName;
        }
        
        if (currentDriver.image == nil) {
            
            self.imageView.image = [UIImage imageNamed:@"user_placeholder@2x.png"];
            
            // Load the cell image
            LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
            downloader.delegate = self;
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, currentDriver.imageURL];
            if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
            
        } 
        
        else {
            
            self.imageView.image = currentDriver.image;
            
        }

    }
        
}

#pragma mark - LLDataDownloader delegate

- (void)dataHasFinishedDownloadingWithResult:(BOOL)result andData:(NSData *)data {
    
    UIImage *imageTemp = [UIImage imageWithData:data];
    currentDriver.image = imageTemp;
    self.imageView.image = imageTemp;
    
}

@end
