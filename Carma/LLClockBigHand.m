//
//  LLClockBigHand.m
//  Carma
//
//  Created by Jeremy Lubin on 7/30/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "LLClockBigHand.h"

@implementation LLClockBigHand

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing the big hand
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGFloat red[4] = {1.0f, 0.0f, 0.0f, 1.0f};
    CGContextSetStrokeColor(c, red);
    CGContextBeginPath(c);
    CGContextMoveToPoint(c, rect.size.width / 2, rect.size.height / 2);
    CGContextAddLineToPoint(c, rect.size.width / 2, rect.size.height / 2 * 0.25);
    CGContextStrokePath(c);
}


@end
