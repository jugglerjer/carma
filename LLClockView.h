//
//  LLClockView.h
//  Carma
//
//  Created by Jeremy Lubin on 7/29/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLClockBigHand.h"
#import "LLClockLittleHand.h"

@interface LLClockView : UIView
{
    LLClockBigHand *bigHand;
    LLClockLittleHand *littleHand;
}

@property (strong, nonatomic) LLClockBigHand *bigHand;
@property (strong, nonatomic) LLClockLittleHand *littleHand;

- (id)initWithFrame:(CGRect)frame andTime:(NSDate *)time;
- (void)setClockWithTime:(NSDate *)time;

@end
