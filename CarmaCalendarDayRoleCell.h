//
//  CarmaCalendarDayRoleCell.h
//  Carma
//
//  Created by Jeremy Lubin on 6/6/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"
#import "CarmaDriver.h"

@interface CarmaCalendarDayRoleCell : UITableViewCell <LLDataDownloaderDelegate> {
    
    CarmaDriver *driver;
    
}

@property (strong, nonatomic) CarmaDriver *driver;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andUser:(CarmaDriver *)user;

@end
