//
//  CarmaRootViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 5/26/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarmaNavigationViewController.h"
#import "CarmaSignInViewController.h"
#import "CarmaSignUpViewController.h"
#import "LLDataDownloader.h"
#import "LLSwipePanel.h"

@class CarmaCalendarViewController;
@class CarmaSearchViewController;
@class CarmaUserViewController;
@class CarmaSettingsViewController;

@interface CarmaRootViewController : UIViewController <UIScrollViewDelegate, LLDataDownloaderDelegate, CLLocationManagerDelegate, CarmaNavigationViewControllerDelegate, UIActionSheetDelegate> {
    
    UINavigationController *navigationController;
    CarmaNavigationViewController *navPanel;
    CarmaCalendarViewController *calendar;
    CarmaSearchViewController *search;
    CarmaUserViewController *profile;
    CarmaSettingsViewController *settings;
    UIViewController *signView;
    CarmaSignInViewController *signinView;
    CarmaSignUpViewController *signupView;
    int currentView;
    LLSwipePanel *swipePanel;
    NSDictionary *drivers;
    CLLocationManager *locManager;
    UIButton *signinButton;
    UIButton *signupButton;
    
}

@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) CarmaNavigationViewController *navPanel;
@property (strong, nonatomic) CarmaCalendarViewController *calendar;
@property (strong, nonatomic) CarmaSearchViewController *search;
@property (strong, nonatomic) CarmaUserViewController *profile;
@property (strong, nonatomic) CarmaSettingsViewController *settings;
@property (strong, nonatomic) UIViewController *signView;
@property (strong, nonatomic) CarmaSignInViewController *signinView;
@property (strong, nonatomic) CarmaSignUpViewController *signupView;
@property int currentView;
@property (strong, nonatomic) LLSwipePanel *swipePanel;
@property (strong, nonatomic) NSDictionary *drivers;
@property (strong, nonatomic) CLLocationManager *locManager;
@property (strong, nonatomic) UIButton *signinButton;
@property (strong, nonatomic) UIButton *signupButton;

- (void)registerRegionWithOrigin:(CLLocationCoordinate2D)center radius:(CLLocationDegrees)radius andIdentifier:(NSString*)identifier;
- (void)showSignUpView;
- (void)showSwipePanel;
- (void)nudgeSwipePanel;

@end
