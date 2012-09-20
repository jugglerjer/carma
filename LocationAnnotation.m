//
//  LocationAnnotation.m
//  QueueYou
//
//  Created by Jeremy Lubin on 2/12/11.
//  Copyright 2011 Lubin Labs. All rights reserved.
//

#import "LocationAnnotation.h"


@implementation LocationAnnotation

@synthesize title;
@synthesize subtitle;

- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate {
    
    coordinate = newCoordinate;
}

- (CLLocationCoordinate2D)coordinate {
    
    return coordinate;
}

@end
