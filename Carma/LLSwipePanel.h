//
//  LLSwipePanel.h
//  Carma
//
//  Created by Jeremy Lubin on 5/24/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarmaMapView.h"

typedef enum  {
    LLScrollViewScrollDirectionHorizontal,
    LLScrollViewScrollDirectionVertical
} LLScrollViewScrollDirection;

@interface LLSwipePanel : UIScrollView {
    
    CarmaMapView *mapView;
    UIView *panel;
    BOOL isPanelVisible;
    BOOL isSliding;
    BOOL modalViewPresent;
    CGFloat panelGripSpace;
    LLScrollViewScrollDirection direction;
    
}

@property (strong, nonatomic) CarmaMapView *mapView;
@property (strong, nonatomic) UIView *panel;
@property BOOL isPanelVisible;
@property BOOL isSliding;
@property BOOL isModalViewPresent;
@property CGFloat panelGripSpace;
@property LLScrollViewScrollDirection direction;

@end
