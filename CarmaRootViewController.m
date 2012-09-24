//
//  CarmaRootViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 5/26/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaRootViewController.h"
#import "CarmaUserViewController.h"
#import "CarmaCalendarViewController.h"
#import "CarmaSearchViewController.h"
#import "CarmaSettingsViewController.h"
#import "CarmaSignInViewController.h"
#import "CarmaSignUpViewController.h"
#import "CarmaDriver.h"
#import "CarmaPool.h"
#import "SBJSON.h"

#define kAccountDownloader      1
#define kCarpoolInfoDownloader  2
#define kAccountPoster          3

#define kAccountView            0
#define kDashboardView          1
#define kCalendarView           2
#define kSearchView             3
#define kSettingsView           4
#define kSignOutView            5

static NSString* const DeviceTokenKey = @"DeviceToken";
static NSString* const UserIDKey = @"UserID";
static NSString* const UsernameKey = @"Username";
static NSString* const PasswordKey = @"Password";
static NSString* const FirstNameKey = @"FirstName";
static CGFloat kPanelGripSpace = 51;

@interface CarmaRootViewController ()

@end

@implementation CarmaRootViewController

@synthesize navigationController;
@synthesize navPanel;
@synthesize calendar;
@synthesize search;
@synthesize profile;
@synthesize settings;
@synthesize signinView;
@synthesize signupView;
@synthesize signView;
@synthesize currentView;
@synthesize swipePanel;
@synthesize drivers;
@synthesize locManager;
@synthesize signinButton;
@synthesize signupButton;

- (id)init {
    
    self = [super init];
    
    if (self) {
        
        // Register for notifications when the user signs in
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSignIn:) name:@"CarmaUserLoggedInNotification" object:nil];
        
        [self attemptSignIn];
        
        int space = self.view.frame.size.width - kPanelGripSpace;
        
        CGRect frame = CGRectMake(self.view.frame.origin.x,
                                  0,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);
        
        CGSize contentSize = CGSizeMake(self.view.frame.size.width + space,
                                        self.view.frame.size.height);
        
        self.view.backgroundColor = [UIColor colorWithRed:.12 green:.38 blue:.51 alpha:1]; // Dark blue
        //self.view.backgroundColor = [UIColor colorWithRed:.36 green:.65 blue:.79 alpha:1]; // Dark green
        //self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gingham_background_dark.png"]];
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueprint_background_dark.png"]];
        //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smooth_background_dark.png"]];
        [self.view addSubview:background];
        
        self.swipePanel = [[LLSwipePanel alloc] initWithFrame:frame];
        swipePanel.contentSize = contentSize;
        swipePanel.pagingEnabled = YES;
        swipePanel.showsHorizontalScrollIndicator = NO;
        swipePanel.panelGripSpace = kPanelGripSpace;
        swipePanel.direction = LLScrollViewScrollDirectionHorizontal;
        swipePanel.delegate = self;
        
//        UIImage *signinButtonImageNormal = [UIImage imageNamed:@"nav_button.png"];
//        UIImage *stretchableSigningButtonImageNormal = [signinButtonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:8];
//        
//        UIImage *signinButtonImagePressed = [UIImage imageNamed:@"nav_button_pressed.png"];
//        UIImage *stretchableSigningButtonImagePressed = [signinButtonImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:8];
//        
//        self.signinButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        signinButton.frame = CGRectMake(26, 128, 214, 30);
//        [signinButton setBackgroundImage:stretchableSigningButtonImageNormal forState:UIControlStateNormal];
//        [signinButton setBackgroundImage:stretchableSigningButtonImagePressed forState:UIControlStateHighlighted];
//        [signinButton setTitle:@"Switch users" forState:UIControlStateNormal];
//        [signinButton setTitle:@"Signing in..." forState:UIControlStateDisabled];
//        signinButton.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:17.0];
//        [signinButton addTarget:self action:@selector(showSignInView) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:signinButton];
//        
//        self.signupButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        signupButton.frame = CGRectMake(26, 178, 214, 30);
//        [signupButton setBackgroundImage:stretchableSigningButtonImageNormal forState:UIControlStateNormal];
//        [signupButton setBackgroundImage:stretchableSigningButtonImagePressed forState:UIControlStateHighlighted];
//        [signupButton setTitle:@"Sign up" forState:UIControlStateNormal];
//        [signupButton setTitle:@"Signing up..." forState:UIControlStateDisabled];
//        signupButton.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:17.0];
//        [signupButton addTarget:self action:@selector(showSignUpView) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:signupButton];
        
        // Create navigation panel
        self.navPanel = [[CarmaNavigationViewController alloc] init];
        navPanel.view.frame = frame;
        navPanel.delegate = self;
        [self.view addSubview:navPanel.view];
        
//        // Add settings button
//        UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 44, 44)];
//        [settingsButton setImage:[UIImage imageNamed:@"gear_button_icon.png"] forState:UIControlStateNormal];
//        settingsButton.showsTouchWhenHighlighted = YES;
//        [settingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:settingsButton];
//        
//        // Add sign out button
//        UIButton *powerButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width - kPanelGripSpace - 10 - 44, self.view.frame.size.height - 44, 44, 44)];
//        [powerButton setImage:[UIImage imageNamed:@"power_button_icon.png"] forState:UIControlStateNormal];
//        powerButton.showsTouchWhenHighlighted = YES;
//        [powerButton addTarget:self action:@selector(confirmSignOut) forControlEvents:UIControlEventTouchUpInside];
//        [self.view addSubview:powerButton];
        
        // Create the user's account view
        self.profile = [[CarmaUserViewController alloc] init];
        
        // Create calendar view with navigation controller and add it to the scroll view
        self.calendar = [[CarmaCalendarViewController alloc] init];
        
        // Create search view
        self.search = [[CarmaSearchViewController alloc] init];
        
        // Create the settings page
        self.settings = [[CarmaSettingsViewController alloc] init];
        
        //self.navigationController = [[UINavigationController alloc] initWithRootViewController:calendar];
        self.navigationController = [[UINavigationController alloc] init];
        navigationController.view.frame = CGRectMake(swipePanel.frame.origin.x + space,
                                                     0,
                                                     swipePanel.frame.size.width,
                                                     swipePanel.frame.size.height);
        
        [navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
        [self switchNavigationViewToRow:[NSNumber numberWithInt:kCalendarView]];
        
        // ------------------------
        // Add side shadows to panel
        // ------------------------
        UIImage *leftShadowImage = [UIImage imageNamed:@"left_panel_shadow.png"];
        UIImage *stretchableLeftShadowImage = [leftShadowImage stretchableImageWithLeftCapWidth:0 topCapHeight:1];
        
        UIImageView *leftShadow = [[UIImageView alloc] initWithFrame:CGRectMake(swipePanel.frame.origin.x + space - 19,
                                                                                0,
                                                                                20,
                                                                                swipePanel.frame.size.height)];
        leftShadow.image = stretchableLeftShadowImage;
        [swipePanel addSubview:leftShadow];
        
        UIImage *rightShadowImage = [UIImage imageNamed:@"right_panel_shadow.png"];
        UIImage *strechableRightShadowImage = [rightShadowImage stretchableImageWithLeftCapWidth:0 topCapHeight:1];
        
        UIImageView *rightShadow = [[UIImageView alloc]
                                    initWithFrame:CGRectMake(swipePanel.frame.origin.x + space + swipePanel.frame.size.width - 1,
                                                             0,
                                                             20,
                                                             swipePanel.frame.size.height)];
        rightShadow.image = strechableRightShadowImage;
        [swipePanel addSubview:rightShadow];
        
        swipePanel.panel = navigationController.view;
        [swipePanel addSubview:navigationController.view];
        [self.view addSubview:swipePanel];
        
        [swipePanel setContentOffset:CGPointMake(self.view.frame.size.width - kPanelGripSpace, 0) animated:NO];
        
        self.locManager = [[CLLocationManager alloc] init];
        locManager.delegate = self;        
    }   
    
    return self;
}

// ------------------------------------------------------
// Show settings panel
// ------------------------------------------------------
- (void)showSettings
{
    UINavigationController *controller = [[UINavigationController alloc] initWithRootViewController:settings];
    [controller.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self presentViewController:controller animated:YES completion:nil];
    
    //[self hideSwipePanel];
}


// ------------------------------------------------------
// Switch panel subviews
// ------------------------------------------------------
- (void)navigationView:(CarmaNavigationViewController *)navView userDidSelectNewRow:(int)row
{
    
    if (row == kSettingsView)
    {
        //[self hideSwipePanel];
        [self showSettings];
    }
    
    else if (row == kSignOutView)
    {
        //[self hideSwipePanel];
        [self confirmSignOut];
    }
    
    else if (currentView == row)
    {
        [self showSwipePanel];
    }
    
    else
    {
        [self hideSwipePanel];
        [self performSelector:@selector(switchNavigationViewToRow:) withObject:[NSNumber numberWithInt:row] afterDelay:0.3];
        [self performSelector:@selector(showSwipePanel) withObject:nil afterDelay:0.4]; 
    }
}

- (void)switchNavigationViewToRow:(NSNumber *)row
{
    search.searchBar.hidden = YES;
    [search.searchBar resignFirstResponder];
    self.navigationItem.titleView = nil;
    
    if ([row intValue] == kAccountView)
    {
        NSArray *viewControllers = [NSArray arrayWithObject:profile];
        [self.navigationController setViewControllers:viewControllers animated:NO];
        profile.title = [NSString stringWithFormat:@"%@ %@", profile.user.firstName, profile.user.lastName];
    }
    else if ([row intValue] == kCalendarView)
    {
        NSArray *viewControllers = [NSArray arrayWithObject:calendar];
        [self.navigationController setViewControllers:viewControllers animated:NO];
        
    }
    
    else if ([row intValue] == kSearchView)
    {
        search.searchBar.hidden = NO;
        NSArray *viewControllers = [NSArray arrayWithObject:search];
        [self.navigationController setViewControllers:viewControllers animated:NO];
    }
    
    else if ([row intValue] == kSettingsView)
    {
//        NSArray *viewControllers = [NSArray arrayWithObject:settings];
//        [self.navigationController setViewControllers:viewControllers animated:NO];
    }
    
    else if ([row intValue] == kSignOutView)
    {
        
    }
    
    else
    {
        UIViewController *viewContoller = [[UIViewController alloc] init];
        viewContoller.view.backgroundColor = [UIColor whiteColor];
        NSArray *viewControllers = [NSArray arrayWithObject:viewContoller];
        [self.navigationController setViewControllers:viewControllers animated:NO];
    }
    
    currentView = [row intValue];
    [self addListButton];
}

- (void)hideSwipePanel
{
    [swipePanel setContentOffset:CGPointMake(-kPanelGripSpace, 0) animated:YES];
}

- (void)showSwipePanel
{
    [swipePanel setContentOffset:CGPointMake(self.view.frame.size.width - kPanelGripSpace, 0) animated:YES];
}

- (void)nudgeSwipePanel
{
    [swipePanel setContentOffset:CGPointMake(0, 0) animated:YES];
}

// ------------------------------------------------------
// Add list button to currently shown view controller
// -----------------------------------------------------
- (void)addListButton
{
    UIImage *buttonImageNormal = [UIImage imageNamed:@"nav_button.png"];
    UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    UIImage *buttonImagePressed = [UIImage imageNamed:@"nav_button_pressed.png"];
    UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:8];
    
    UIButton *listButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
    listButtonView.frame = CGRectMake(0, 0, 41, 30);
    [listButtonView setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
    [listButtonView setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted];
    [listButtonView setImage:[UIImage imageNamed:@"list_icon.png"] forState:UIControlStateNormal];
    [listButtonView addTarget:self action:@selector(determinePositionForPanel) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *list = [[UIBarButtonItem alloc] initWithCustomView:listButtonView];
    listButtonView.adjustsImageWhenHighlighted = NO;
    
    [[[[navigationController viewControllers] objectAtIndex:0] navigationItem] setLeftBarButtonItem:list];
}
     

// ------------------------------------------------------
// Signing in methods
// ------------------------------------------------------

- (void)confirmSignOut
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Would you like to sign out?"
                                                       delegate:self
                                              cancelButtonTitle:@"Whoopsie daisy"
                                         destructiveButtonTitle:@"Yep, I'm out"
                                              otherButtonTitles:nil];
    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != actionSheet.cancelButtonIndex)
    {
        [self signOut];
        [self showSignInView];
    }
}

- (void)showSignInView
{
    //[[UIScreen mainScreen] bounds].size.height - [[UIApplication sharedApplication] statusBarFrame].size.height - self.view.frame.size.height
    CGRect frame = CGRectMake(0,
                              0,
                              self.view.frame.size.width,
                              self.view.frame.size.height);
    
    self.signView = [[UIViewController alloc] init];
    self.signinView = [[CarmaSignInViewController alloc] init];
    self.signupView = [[CarmaSignUpViewController alloc] init];
    signView.view.frame = frame;
    signinView.view.frame = frame;
    signupView.view.frame = frame;
    [signView.view addSubview:signinView.view];
    [signupView.view removeFromSuperview];
    
    [self presentViewController:signView animated:YES completion:NULL];
    //[self.view addSubview:signinView.view];
}

- (void)showSignUpView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    
    if ([signinView.view superview]) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:signView.view cache:YES];
        [signinView.view removeFromSuperview];
        [signView.view addSubview:signupView.view];
    }
    else if ([signupView.view superview])
    {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:signView.view cache:YES];
        [signupView.view removeFromSuperview];
        [signView.view addSubview:signinView.view];
    }
    
    [UIView commitAnimations];
    
    //CarmaSignUpViewController *signupView = [[CarmaSignUpViewController alloc] init];
    
    //[self presentViewController:signupView animated:YES completion:NULL];
}

- (void)attemptSignIn
{
    NSString *username = [[NSUserDefaults standardUserDefaults] objectForKey:UsernameKey];
    NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:PasswordKey];
    
    if (username == nil || password == nil)
    {
        [self performSelector:@selector(showSignInView) withObject:nil afterDelay:0];
        //[self showSignInView];
        return;
    }
    
    LLDataDownloader *signIn = [[LLDataDownloader alloc] init];
    signIn.delegate = self;
    signIn.identifier = kAccountDownloader;
    
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_sign_in.php"];
    NSString *params = [NSString stringWithFormat:@"username=%@&password=%@",
                        username, password];
    if (![signIn postDataWithURL:url andParams:params]) {NSLog(@"Couldn't download %@", url);}
}

- (void)signOut
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserIDKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:UsernameKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:FirstNameKey];
    
    LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
    downloader.delegate = self;
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_sign_out.php"];
    if (![downloader getDataWithURL:url]) {NSLog(@"Couldn't download %@", url);}
    
    //[self attemptSignIn];
}

- (void)userDidSignIn:(NSNotification *)notification
{
    CarmaDriver *driver = [notification object];
    
    // Add the driver to the account view
    self.profile = [[CarmaUserViewController alloc] init];
    self.profile.user = driver;
    self.profile.title = [NSString stringWithFormat:@"%@ %@", driver.firstName, driver.lastName];
    if (currentView == kAccountView)
    {
        [self switchNavigationViewToRow:[NSNumber numberWithInt:currentView]];
    }
    //[profile.profileTable reloadData];
    
    // Register user for push notifications
    // by sending device token to server
    NSString *token = [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey];
    if (![driver.deviceToken isEqualToString:token])
    {
        LLDataDownloader *pushRegister = [[LLDataDownloader alloc] init];
        pushRegister.delegate = self;
        pushRegister.identifier = kAccountPoster;
        
        NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/update_user.php"];
        NSString *params = [NSString stringWithFormat:@"table=%@&field=%@&value=%@",
                            @"Users", @"deviceToken", [[NSUserDefaults standardUserDefaults] stringForKey:DeviceTokenKey]];
        if (![pushRegister postDataWithURL:url andParams:params]) {NSLog(@"Couldn't download %@", url);}
    }
    
    // Set up geofences around driver's home and office and register them with the OS
    if ( [CLLocationManager regionMonitoringAvailable] &&
        [CLLocationManager regionMonitoringEnabled] )
    {
        
        NSArray *regions = [[locManager monitoredRegions] allObjects];
        
        for (CLRegion *region in regions)
        {
            [locManager stopMonitoringForRegion:region];
        }
        
        CLLocationDistance radius = 50;
        
        CLLocationCoordinate2D originCenter = CLLocationCoordinate2DMake(driver.originLatitude, driver.originLongitude);
        NSString *originIdentifier = [NSString stringWithFormat:@"%@_origin", driver.uID];
        [self registerRegionWithOrigin:originCenter radius:radius andIdentifier:originIdentifier];
        
        CLLocationCoordinate2D destinationCenter = CLLocationCoordinate2DMake(driver.destinationLatitude, driver.destinationLongitude);
        NSString *destinationIdentifier = [NSString stringWithFormat:@"%@_destination", driver.uID];
        [self registerRegionWithOrigin:destinationCenter radius:radius andIdentifier:destinationIdentifier];
        
        //NSArray *newRegions = [[locManager monitoredRegions] allObjects];
        //NSLog(@"%@", newRegions);
        
    }
    
    // Download user's carpool info
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [dateFormat setDateFormat:@"YYYY/MM/dd H:mm:ss"];
    NSString *date = [dateFormat stringFromDate:[NSDate date]];
    
    LLDataDownloader *carpoolInfoDownloader = [[LLDataDownloader alloc] init];
    carpoolInfoDownloader.delegate = self;
    carpoolInfoDownloader.identifier = kCarpoolInfoDownloader;
    NSString *infoURL = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_pool.php?id=%@&date=%@", driver.uID, date];
    infoURL = [infoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (![carpoolInfoDownloader getDataWithURL:infoURL]) {NSLog(@"Couldn't download %@", infoURL);}
    
    // Slide the view into place
    [swipePanel setContentOffset:CGPointMake(self.view.frame.size.width - kPanelGripSpace, 0) animated:YES];

}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data {
    
    // Parse the JSON data returned
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	
    switch (downloader.identifier)
    {
        case kAccountDownloader:
            
            if ([responseString isEqualToString:@"-1"] || [responseString isEqualToString:@"0"])
            {
                [self showSignInView];
            }
            
            else
            {
                SBJSON *jsonParser = [SBJSON new];	
                NSDictionary *driverData = [jsonParser objectWithString:responseString];
                
                if (![[driverData objectForKey:@"id"] isEqual:[NSNull null]])
                {
                    // Save the user's data in our data model
                    CarmaDriver *driver = [[CarmaDriver alloc] initWithDictionary:driverData];
                    
                    // Save the user's data so they don't need to log in next time
                    [[NSUserDefaults standardUserDefaults] setObject:driver.uID forKey:UserIDKey];
                    
                    // Tell the system that we've successfully logged in
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"CarmaUserLoggedInNotification" object:driver];
                }
            }
            break;
            
        case kCarpoolInfoDownloader:
            
            NSLog(@"I don't know why this needs to be logged");
            SBJSON *jsonParser = [SBJSON new];	
            NSDictionary *daysData = [jsonParser objectWithString:responseString];
            CarmaPool *pool = [[CarmaPool alloc] initWithDictionary:daysData];
            
            if ([pool.poolID isEqual:[NSNull null]])
            {
                pool = nil;
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CarmaPoolInfoDownloadedNotification" object:pool];
              
            break;
        
        default:
            //NSLog(@"%@", responseString);
            break;
    }
}

- (void)registerRegionWithOrigin:(CLLocationCoordinate2D)center radius:(CLLocationDegrees)radius andIdentifier:(NSString*)identifier
{
    
    // If the radius is too large, registration fails automatically,
    // so clamp the radius to the max value.
    if (radius > self.locManager.maximumRegionMonitoringDistance)
        radius = self.locManager.maximumRegionMonitoringDistance;
    
    // Create the region and start monitoring it.
    CLRegion* region = [[CLRegion alloc] initCircularRegionWithCenter:center
                                                               radius:radius identifier:identifier];
    [self.locManager startMonitoringForRegion:region
                              desiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    
}

- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region
{
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Entered" message:@"You're the man." delegate:nil cancelButtonTitle:@"Move on" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Region entered";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
    // Temporarily send a push notification
    LLDataDownloader *push = [[LLDataDownloader alloc] init];
    push.delegate = self;
    push.identifier = 3;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y/MM/dd"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    NSString *urlPush = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_notify.php?date=%@&type=%@", date, region.identifier];
    if (![push getDataWithURL:urlPush]) {NSLog(@"Couldn't download %@", urlPush);}
    
}

- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region
{
    
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Region Exited" message:@"You're the man." delegate:nil cancelButtonTitle:@"Move on" otherButtonTitles:nil];
        [alert show];
    }
    else {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = @"Region exited";
        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    }
    
    // Temporarily send a push notification
    LLDataDownloader *push = [[LLDataDownloader alloc] init];
    push.delegate = self;
    push.identifier = 3;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"y/MM/dd"];
    NSString *date = [formatter stringFromDate:[NSDate date]];
    
    NSString *urlPush = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_notify.php?date=%@&type=%@", date, region.identifier];
    if (![push getDataWithURL:urlPush]) {NSLog(@"Couldn't download %@", urlPush);}
    
}

- (void)locationManager:(CLLocationManager *)manager monitoringDidFailForRegion:(CLRegion *)region withError:(NSError *)error
{
    NSLog(@"Region monitoring failed with error: %@", [error localizedDescription]);
}

- (void)determinePositionForPanel {
    
    if (swipePanel.isPanelVisible) {
        [swipePanel setContentOffset:CGPointMake(0, 0) animated:YES];
    } else {
        [swipePanel setContentOffset:CGPointMake(self.view.frame.size.width - kPanelGripSpace, 0) animated:YES];
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)givenScrollView {
    
    if (givenScrollView == swipePanel) {
        if (givenScrollView.contentOffset.x == self.view.frame.size.width - kPanelGripSpace) {
            swipePanel.panel.userInteractionEnabled = YES;
            swipePanel.isPanelVisible = YES;
        } 
        else { 
            swipePanel.panel.userInteractionEnabled = NO;
            swipePanel.isPanelVisible = NO;
        }
        
        [navPanel animateIconWithScrollView:(LLSwipePanel *)givenScrollView];
    }
}

@end
