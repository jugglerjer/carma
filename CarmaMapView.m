//
//  CarmaMapView.m
//  Carma
//
//  Created by Jeremy Lubin on 5/24/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaMapView.h"
#import "LLSwipePanel.h"

@implementation CarmaMapView

static CGFloat kMapScrollViewGripSpace = 44;

@synthesize grip;
@synthesize isVisible;
//@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       
        // ------------------------
        // Add upper bar shadow to map
        // ------------------------
        /*int barWidth = self.frame.size.width;
         
         UIImage *barImage = [UIImage imageNamed:@"upper_bar_shadow.png"];
         UIImage *stretchableBarImage = [barImage stretchableImageWithLeftCapWidth:1 topCapHeight:0];
         
         UIImageView *barView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, barWidth, 2)];
         barView.image = stretchableBarImage;
         [mapView addSubview:barView];*/
        
        // ------------------------
        // Add grip to map
        // ------------------------    
        int gripWidth = 60;
        
        UIImage *gripImage = [UIImage imageNamed:@"grip.png"];
        UIImage *stretchableGripImage = [gripImage stretchableImageWithLeftCapWidth:1 topCapHeight:0];
        
        UIButton *gripView = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat x = (self.frame.size.width - gripWidth) / 2;
        CGFloat y = (kMapScrollViewGripSpace - 18) / 2;
        gripView.frame = CGRectMake(x, y, gripWidth, 18);
        [gripView setBackgroundImage:stretchableGripImage forState:UIControlStateNormal];
        [gripView setBackgroundImage:stretchableGripImage forState:UIControlStateHighlighted];
        [gripView addTarget:self action:@selector(determinePosition) forControlEvents:UIControlEventTouchUpInside];
        self.grip = gripView;
        [self addSubview:grip];
        // ------------------------
        // ------------------------
        
    }
    return self;
}

- (void)determinePosition {
    
    if ([self.delegate respondsToSelector:@selector(determinePositionForMap:)]) {
        [(id)self.delegate determinePositionForMap:self];
    }
    
}

@end
