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
        UIImageView *clockFace = [[UIImageView alloc] initWithFrame:self.frame];
        clockFace.image = [UIImage imageNamed:@"LLClockFace.png"];
        self.backgroundColor = [UIColor clearColor];
        
        // Add the big hand
        self.bigHand = [[LLClockBigHand alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        bigHand.backgroundColor = [UIColor clearColor];
        [self addSubview:bigHand];
        
        // Add the little hand
        self.littleHand = [[LLClockLittleHand alloc] initWithFrame:CGRectMake(0 , 0, self.frame.size.width, self.frame.size.height)];
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


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Draw the clock face
    CGContextRef c = UIGraphicsGetCurrentContext();
    
    CGContextSelectFont (c,
                         "Helvetica",
                         rect.size.height / 5,
                         kCGEncodingMacRoman);
    CGContextSetCharacterSpacing (c, rect.size.height / 10);
    CGContextSetTextDrawingMode (c, kCGTextFillStroke);
    CGContextSetRGBFillColor (c, 0, 1, 0, .5);
    CGContextSetRGBStrokeColor (c, 0, 0, 1, 1);
    CGContextShowTextAtPoint( c, rect.size.width / 2, 0, "12", [@"12" length]);
}

@end
