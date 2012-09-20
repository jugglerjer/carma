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
    
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, red);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, rect.size.width / 2, rect.size.height / 2);
    CGContextAddLineToPoint(c, rect.size.width / 2, rect.size.height / 2 * 0.5);
    CGContextStrokePath(c);
}

@end
