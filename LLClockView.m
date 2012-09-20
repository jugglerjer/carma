//
//  LLClockView.m
//  Carma
//
//  Created by Jeremy Lubin on 7/29/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "LLClockView.h"
#import "LLClockBigHand.h"

#define hoursToDegrees(x) (360 * x / 12)
#define minutesToDegrees(x) (360.0 * x / 60)
#define degreesToRadians(x) (M_PI * x / 180.0)

@implementation LLClockView

@synthesize bigHand;
@synthesize littleHand;

- (id)initWithFrame:(CGRect)frame andTime:(NSDate *)time
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.backgroundColor = [UIColor clearColor];
        CGRect frame = CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10);
        
        // Add the clock face (numbers)
        UIImageView *clockFace = [[UIImageView alloc] initWithFrame:frame];
        clockFace.image = [UIImage imageNamed:@"LLClockFace.png"];
        clockFace.alpha = 0.75;
        [self addSubview:clockFace];
        
        // Add the big hand
        self.bigHand = [[LLClockBigHand alloc] initWithFrame:frame];
        bigHand.backgroundColor = [UIColor clearColor];
        [self addSubview:bigHand];
        
        // Add the little hand
        self.littleHand = [[LLClockLittleHand alloc] initWithFrame:frame];
        littleHand.backgroundColor = [UIColor clearColor];
        [self addSubview:littleHand];
        
        [self setClockWithTime:time];
    }
    return self;
}

- (void)setClockWithTime:(NSDate *)time
{
    // Get the time's minute value
    NSDateFormatter *minuteFormatter = [[NSDateFormatter alloc] init];
    [minuteFormatter setDateFormat:@"m"];
    int minute = [[minuteFormatter stringFromDate:time] intValue];
    
    // Get the time's hour value
    NSDateFormatter *hourFormatter = [[NSDateFormatter alloc] init];
    [hourFormatter setDateFormat:@"h"];
    int hour = [[hourFormatter stringFromDate:time] intValue];
    
    // Get the angle to which to rotate the minute hand
    int minuteAngle = minutesToDegrees(minute);
    [self rotateClockHand:bigHand withAngle:minuteAngle];
    
    // Get the angle to which to rotate the hour hand
    int hourAngle = hoursToDegrees(hour);
    [self rotateClockHand:littleHand withAngle:hourAngle];
    
}

- (void)rotateClockHand:(UIView *)hand withAngle:(int)angle
{
    [UIView beginAnimations:@"rotateClockHand" context:nil];
    [UIView setAnimationDuration:0.2];
    hand.transform = CGAffineTransformMakeRotation(degreesToRadians(angle));
    [UIView commitAnimations];
}

/*
- (void)drawRect:(CGRect)rect
{
    
}
*/

@end
