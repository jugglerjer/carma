//
//  AppDelegate.h
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "CarmaRootViewController.h"
#import "LLDataDownloader.h"
#import "LLSwipePanel.h"

#define ServerApiURL @"http://10.0.1.7:44447/api.php"

@interface AppDelegate : UIResponder <UIApplicationDelegate, LLDataDownloaderDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) CarmaRootViewController *rootViewController;

@end
