//
//  CarmaDriverLocationAnnotation.m
//  Carma
//
//  Created by Jeremy Lubin on 6/7/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import "CarmaDriverLocationAnnotation.h"

@implementation CarmaDriverLocationAnnotation

@synthesize driver;
@synthesize role;
@synthesize locationType;
@synthesize title;
@synthesize subtitle;
@synthesize coordinate;

- (id)initWithUser:(CarmaDriver *)user forRole:(CarmaCalendarDayRole)newRole andType:(CarmaDriverLocaionAnnotationType)newType
{
    self = [super init];
    if (self) {
    
        self.driver = user;
        self.role = newRole;
        self.locationType = newType;
        
        self.title = driver.firstName;
        
//        NSDictionary *locationDictionary;
        switch (locationType) {
            case CarmaDriverLocaionAnnotationTypeHome:
                self.subtitle = @"Home";
                self.coordinate = CLLocationCoordinate2DMake(driver.originLatitude, driver.originLongitude);
                
                // Fetch the user's home location and set the coordinate
//                locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                    driver.originStreet, kABPersonAddressStreetKey,
//                                                    driver.originCity, kABPersonAddressCityKey,
//                                                    driver.originState, kABPersonAddressStateKey,
//                                                    /*driver.originZip, kABPersonAddressZIPKey,*/
//                                                    nil];

                break;
                
           case CarmaDriverLocaionAnnotationTypeWork:
                self.subtitle = @"Work";
                self.coordinate = CLLocationCoordinate2DMake(driver.destinationLatitude, driver.destinationLongitude);
                
                // Fetch the user's work location and set the coordinate
//                locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
//                                                    driver.destinationStreet, kABPersonAddressStreetKey,
//                                                    driver.destinationCity, kABPersonAddressCityKey,
//                                                    driver.destinationState, kABPersonAddressStateKey,
//                                                    /*driver.destinationZip, kABPersonAddressZIPKey,*/
//                                                    nil];
                break;
        }
        
        // Code to execute once the location has been geocoded -- adds the place's coordinates to the annotation object
//        CLGeocodeCompletionHandler wat = ^(NSArray *placemark, NSError *error) {
//            CLPlacemark *mark = [placemark objectAtIndex:0];
//            self.coordinate = CLLocationCoordinate2DMake(mark.location.coordinate.latitude, mark.location.coordinate.longitude);
//            NSLog(@"%@, %@, %f, %f", driver.firstName, subtitle, mark.location.coordinate.latitude, mark.location.coordinate.longitude);
//        };
//        
//        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//        [geocoder geocodeAddressDictionary:locationDictionary completionHandler:wat];
        
    }
    
    return self;
    
}

@end
