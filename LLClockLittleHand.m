//
//  LLClockLittleHand.m
//  Carma
//
//  Created by Jeremy Lubin on 8/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "LLClockLittleHand.h"

@implementation LLClockLittleHand

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    // Drawing the little hand
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    float red = 30/255;
    float green = 98/255;
    float blue = 131/255;
    
    CGFloat color[4] = {red, green, blue, 1.0f};
    CGContextSetStrokeColor(c, color);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, rect.size.width / 2, rect.size.height / 2);
    CGContextAddLineToPoint(c, rect.size.width / 2, rect.size.height / 2 * 0.6);
    CGContextStrokePath(c);
}

@end
