//
//  CarmaDriverLocationAnnotation.h
//  Carma
//
//  Created by Jeremy Lubin on 6/7/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import "CarmaDriver.h"

typedef enum
{
    CarmaCalendarDayRoleDriver,
    CarmaCalendarDayRolePassenger,
    CarmaCalendarDayRoleInactive
} CarmaCalendarDayRole;

typedef enum
{
    CarmaDriverLocaionAnnotationTypeHome,
    CarmaDriverLocaionAnnotationTypeWork
} CarmaDriverLocaionAnnotationType;

@interface CarmaDriverLocationAnnotation : NSObject <MKAnnotation> {
    
    CarmaDriver *driver;
    CarmaCalendarDayRole role;
    CarmaDriverLocaionAnnotationType locationType;
    CLLocationCoordinate2D coordinate;
}

@property (strong, nonatomic) CarmaDriver *driver;
@property CarmaCalendarDayRole role;
@property CarmaDriverLocaionAnnotationType locationType;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithUser:(CarmaDriver *)user forRole:(CarmaCalendarDayRole)newRole andType:(CarmaDriverLocaionAnnotationType)newType;

@end
