//
//  CarmaCalendarDayDetailViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 5/27/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaCalendarDayDetailViewController.h"
#import "CarmaDriver.h"
#import "CarmaDriverLocationAnnotation.h"
#import "AppDelegate.h"
#import "CarmaRootViewController.h"

static CGFloat kPanelGripSpace = 51;
static CGFloat kTableViewWidth = 320;

@implementation CarmaCalendarDayDetailViewController

@synthesize map;
@synthesize detailTable;
@synthesize day;
@synthesize users;
@synthesize panel;
@synthesize rolesTable;

- (id)initWithDay:(CarmaDay *)newDay;
{
    self = [super init];
    if (self) {        
        
        self.day = newDay;
        
        // Add map view
        self.map = [[MKMapView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                               0,
                                                               self.view.frame.size.width,
                                                               self.view.frame.size.height)];
        map.delegate = self;
        
        // Add annotations for each users's home and work locations        
        if (newDay.driver != nil) {
            
            // Add home location
            CarmaDriverLocationAnnotation *annotationDriverHome = [[CarmaDriverLocationAnnotation alloc]
                                                                   initWithUser:newDay.driver
                                                                   forRole:CarmaCalendarDayRoleDriver
                                                                   andType:CarmaDriverLocaionAnnotationTypeHome];
            [map addAnnotation:annotationDriverHome];
            
            // Add work location
            CarmaDriverLocationAnnotation *annotationDriverWork = [[CarmaDriverLocationAnnotation alloc]
                                                                   initWithUser:newDay.driver
                                                                   forRole:CarmaCalendarDayRoleDriver
                                                                   andType:CarmaDriverLocaionAnnotationTypeWork];
            [map addAnnotation:annotationDriverWork];
 
        }
        
        for (CarmaDriver *user in newDay.passengers) {
            
            // Add home location
            CarmaDriverLocationAnnotation *annotationPassengerHome = [[CarmaDriverLocationAnnotation alloc]
                                                                   initWithUser:user
                                                                   forRole:CarmaCalendarDayRolePassenger
                                                                   andType:CarmaDriverLocaionAnnotationTypeHome];
            [map addAnnotation:annotationPassengerHome];
            
            // Add work location
            CarmaDriverLocationAnnotation *annotationPassengerWork = [[CarmaDriverLocationAnnotation alloc]
                                                                   initWithUser:user
                                                                   forRole:CarmaCalendarDayRolePassenger
                                                                   andType:CarmaDriverLocaionAnnotationTypeWork];
            [map addAnnotation:annotationPassengerWork];

        }
        
        for (CarmaDriver *user in newDay.inactives) {
            
            // Add home location
            CarmaDriverLocationAnnotation *annotationInactiveHome = [[CarmaDriverLocationAnnotation alloc]
                                                                      initWithUser:user
                                                                      forRole:CarmaCalendarDayRoleInactive
                                                                      andType:CarmaDriverLocaionAnnotationTypeHome];
            [map addAnnotation:annotationInactiveHome];
            
            // Add work location
            CarmaDriverLocationAnnotation *annotationInactiveWork = [[CarmaDriverLocationAnnotation alloc]
                                                                      initWithUser:user
                                                                      forRole:CarmaCalendarDayRoleInactive
                                                                      andType:CarmaDriverLocaionAnnotationTypeWork];
            [map addAnnotation:annotationInactiveWork];

        }
        
        // Position map around the annotation coordinates
        CLLocationCoordinate2D points[[[map annotations] count]];
        int i = 0;
        for (CarmaDriverLocationAnnotation *annotation in [map annotations]) {
            points[i] = annotation.coordinate;
            i++;
        }
        
        MKPolygon *polygon = [MKPolygon polygonWithCoordinates:points count:[[map annotations] count]];
        MKMapRect rect = [polygon boundingMapRect];
        //NSLog(@"%f", rect.size.width);
        rect.size.width += 100000;
        rect.size.height += 100000;
        //NSLog(@"%f", rect.size.width);
        [map setRegion:MKCoordinateRegionForMapRect(rect)];
        
        map.showsUserLocation = YES;
        
        AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        CarmaRootViewController *rootView = delegate.rootViewController;
        NSArray *regions = [[rootView.locManager monitoredRegions] allObjects];
        
        for (CLRegion *region in regions) {
            MKCircle *circle = [MKCircle circleWithCenterCoordinate:region.center radius:region.radius];
            [map addOverlay:circle];
        }
        
        [self.view addSubview:map];
        
        // Create swipe panel for user table
        int space = self.view.frame.size.width - kPanelGripSpace;
        
        CGRect frame = CGRectMake(self.view.frame.origin.x,
                                  0,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);
        
        CGSize contentSize = CGSizeMake(self.view.frame.size.width + space,
                                        self.view.frame.size.height);
        
        self.panel = [[LLSwipePanel alloc] initWithFrame:frame];
        panel.contentSize = contentSize;
        panel.pagingEnabled = YES;
        panel.showsHorizontalScrollIndicator = NO;
        panel.panelGripSpace = kPanelGripSpace;
        panel.direction = LLScrollViewScrollDirectionHorizontal;
        panel.delegate = self;        
        
        // Set up table
        self.rolesTable = [[CarmaCalendarDayRolesViewController alloc] initWithStyle:UITableViewStyleGrouped andDay:day];
        rolesTable.view.frame = CGRectMake(panel.frame.origin.x + space,
                                           0,
                                           kTableViewWidth,
                                           panel.frame.size.height);
        panel.panel = rolesTable.view;
        [panel addSubview:rolesTable.view];
        
        [self.view addSubview:panel];

        
    }
    return self;
}

-(MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    circleView.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.3];
    circleView.strokeColor = [UIColor greenColor];
    circleView.lineWidth = 2;
    return circleView;
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

#pragma mark - Scroll view delegate methods

- (void)determinePositionForPanel {
    
    if (panel.isPanelVisible) {
        [panel setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [panel setContentOffset:CGPointMake(0, self.view.frame.size.width - kPanelGripSpace) animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)givenScrollView {
    
    if (givenScrollView == panel) {
        if (givenScrollView.contentOffset.x == self.view.frame.size.width - kPanelGripSpace) {
            panel.panel.userInteractionEnabled = YES;
            panel.isPanelVisible = YES;
        } 
        else { 
            panel.panel.userInteractionEnabled = NO;
            panel.isPanelVisible = NO;
        }
    }
}

@end
