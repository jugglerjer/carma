//
//  CarmaMapView.h
//  Carma
//
//  Created by Jeremy Lubin on 5/24/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <MapKit/MapKit.h>

@protocol CarmaMapViewDelegate;

@interface CarmaMapView : MKMapView {
    
    UIButton *grip;
    BOOL isVisible;
    //id <CarmaMapViewDelegate> delegate;
    
}

@property (strong, nonatomic) UIButton *grip;
//@property (assign, nonatomic) id <CarmaMapViewDelegate> delegate;
@property BOOL isVisible;

@end

@protocol CarmaMapViewDelegate <MKMapViewDelegate>

- (void)determinePositionForMap:(CarmaMapView *)map;

@end
