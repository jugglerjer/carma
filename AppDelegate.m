//
//  AppDelegate.m
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "AppDelegate.h"
#import "CarmaCalendarViewController.h"
#import "CarmaDriver.h"
#import "SBJSON.h"

static NSString* const DeviceTokenKey = @"DeviceToken";

@implementation AppDelegate

@synthesize window = _window;
@synthesize rootViewController;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    // Set up the root view
    // -----------------------
    
    self.rootViewController = [[CarmaRootViewController alloc] init];
    
    [self.window addSubview:rootViewController.view];
    //self.window.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [self.window makeKeyAndVisible];
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    if (![[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:DeviceTokenKey];
    }    

    // ------------------------
    // Customize button appearance
    // ------------------------
    UIImage *backButtonImageNormal = [UIImage imageNamed:@"nav_button_back.png"];
    UIImage *stretchableBackButtonImageNormal = [backButtonImageNormal resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    
    UIImage *backButtonImagePressed = [UIImage imageNamed:@"nav_button_back_pressed.png"];
    UIImage *stretchableBackButtonImagePressed = [backButtonImagePressed resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 0, 5)];
    
    UIImage *buttonImageNormal = [UIImage imageNamed:@"nav_button.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"nav_button_pressed.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:stretchableBackButtonImageNormal
                                                      forState:UIControlStateNormal
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:stretchableBackButtonImagePressed
                                                      forState:UIControlStateHighlighted
                                                    barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:stretchableButtonImageNormal
                                            forState:UIControlStateNormal
                                          barMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setBackgroundImage:stretchableButtonImagePressed
                                            forState:UIControlStateHighlighted
                                          barMetrics:UIBarMetricsDefault];
    
    
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    
    NSString *newToken = [deviceToken description];
    newToken = [newToken stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
	newToken = [newToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    //NSLog(@"My token is: %@", newToken);
    
    [[NSUserDefaults standardUserDefaults] setObject:newToken forKey:DeviceTokenKey];
    
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
  // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
  // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
