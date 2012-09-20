//
//  CarmaProfileEditViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/23/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmaProfileLocationViewController.h"
#import "CarmaProfileTimeViewController.h"
#import "CarmaDriver.h"

@class CarmaUserViewController;

@interface CarmaProfileEditViewController : UIViewController
{
    UIViewController *visibleViewController;
    CarmaUserViewController *delegate;
    CarmaDriver *driver;
    int view;
}

@property (strong, nonatomic) UIViewController *visibleViewController;
@property (strong, nonatomic) CarmaUserViewController *delegate;
@property (strong, nonatomic) CarmaDriver *driver;

- (id)initWithEditView:(int)v andDriver:(CarmaDriver *)d;

@end
