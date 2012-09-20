//
//  LocationAnnotation.h
//  QueueYou
//
//  Created by Jeremy Lubin on 2/12/11.
//  Copyright 2011 Lubin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface LocationAnnotation : NSObject <MKAnnotation> {
    
    NSString *title;
    NSString *subtitle;
    CLLocationCoordinate2D coordinate;
}

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;

@end
