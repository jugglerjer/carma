//
//  CACalendarViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"

@interface CACalendarViewController : UITableViewController <LLDataDownloaderDelegate> {
    
    NSMutableArray *days;
    NSDictionary *drivers;
    NSIndexPath *todayIndex;
    
}

@property (strong, nonatomic) NSMutableArray *days;
@property (strong, nonatomic) NSDictionary *drivers;
@property (strong, nonatomic) NSIndexPath *todayIndex;

@end
