//
//  CarmaCalendarView.m
//  Carma
//
//  Created by Jeremy Lubin on 5/24/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaCalendarView.h"

@implementation CarmaCalendarView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
    return self.superview;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
