//
//  CarmaDriver.h
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "LLDataDownloader.h"

@interface CarmaDriver : NSObject <LLDataDownloaderDelegate> {
    
    NSString *uID;
    NSString *firstName;
    NSString *lastName;
    NSString *imageURL;
    UIImage *image;
    NSString *position; // 1 = driver, 0 = passenger, -1 = inactive
    
    // Address variables
    NSString *originStreet;
    NSString *originCity;
    NSString *originState;
    NSString *originZip;
    CLLocationDegrees originLatitude;
    CLLocationDegrees originLongitute;
    
    NSString *destinationStreet;
    NSString *destinationCity;
    NSString *destinationState;
    NSString *destinationZip;
    CLLocationDegrees destinationLatitude;
    CLLocationDegrees destinationLongitute;
    
    // Push Notifications
    NSString *deviceToken;
    
}

@property (strong, nonatomic) NSString *uID;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSString *position;

// Address variables
@property (strong, nonatomic) NSString *originStreet;
@property (strong, nonatomic) NSString *originCity;
@property (strong, nonatomic) NSString *originState;
@property (strong, nonatomic) NSString *originZip;
@property CLLocationDegrees originLatitude;
@property CLLocationDegrees originLongitude;

@property (strong, nonatomic) NSString *destinationStreet;
@property (strong, nonatomic) NSString *destinationCity;
@property (strong, nonatomic) NSString *destinationState;
@property (strong, nonatomic) NSString *destinationZip;
@property CLLocationDegrees destinationLatitude;
@property CLLocationDegrees destinationLongitude;

// Push Notifications
@property (strong, nonatomic) NSString *deviceToken;

- (id)initWithDictionary:(NSDictionary *)dict;
- (CarmaDriver *)driverWithDictionary:(NSDictionary *)dict;
- (void)updateDriverWithAttributes:(NSDictionary *)attributes;

@end
