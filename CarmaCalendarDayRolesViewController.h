//
//  CarmaCalendarDayRolesViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 6/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmaDay.h"

@interface CarmaCalendarDayRolesViewController : UITableViewController {
    
    CarmaDay *day;
    NSArray *users;
    
}

@property (strong, nonatomic) CarmaDay *day;
@property (strong, nonatomic) NSArray *users;

- (id)initWithStyle:(UITableViewStyle)style andDay:(CarmaDay *)newDay;

@end
