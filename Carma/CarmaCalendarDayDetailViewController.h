//
//  CarmaCalendarDayDetailViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 5/27/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarmaDay.h"
#import "LLSwipePanel.h"
#import "CarmaCalendarDayRolesViewController.h"

@interface CarmaCalendarDayDetailViewController : UIViewController <MKMapViewDelegate, UIScrollViewDelegate> {
    
    MKMapView *map;
    UITableView *detailTable;
    CarmaDay *day;
    NSArray *users;
    LLSwipePanel *panel;
    CarmaCalendarDayRolesViewController *rolesTable;
    
}

@property (strong, nonatomic) MKMapView *map;
@property (strong, nonatomic) UITableView *detailTable;
@property (strong, nonatomic) CarmaDay *day;
@property (strong, nonatomic) NSArray *users;
@property (strong, nonatomic) LLSwipePanel *panel;
@property (strong, nonatomic) CarmaCalendarDayRolesViewController *rolesTable;

- (id)initWithDay:(CarmaDay *)newDay;

@end
