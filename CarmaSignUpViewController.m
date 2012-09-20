//
//  CarmaSignUpViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaSignUpViewController.h"
#import "CarmaDriver.h"
#import "SBJSON.h"
#import "AppDelegate.h"

static NSString* const UserIDKey = @"UserID";
static NSString* const UsernameKey = @"Username";
static NSString* const PasswordKey = @"Password";
static NSString* const FirstNameKey = @"FirstName";

#define kNumberOfPages      3
#define kBasicProfilePage   0
#define kPhotoPage          3
#define kOriginPage         1
#define kDestinationpage    2

@interface CarmaSignUpViewController ()

@end

@implementation CarmaSignUpViewController

@synthesize navBar;
@synthesize leftButton;
@synthesize rightButton;
@synthesize scrollView;
@synthesize viewControllers;
@synthesize attributes;

// ------------------------------------------------------
// Set up signin view
// ------------------------------------------------------
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) 
    {
        
        CGRect frame = CGRectMake(self.view.frame.origin.x,
                                  0,
                                  self.view.frame.size.width,
                                  self.view.frame.size.height);
        
        // Create background
        //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"modal_background.png"]];
        UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smooth_background_normal.png"]];
        background.frame = frame;
        [self.view addSubview:background];
        //self.view.backgroundColor = [UIColor colorWithRed:.36 green:.65 blue:.79 alpha:1]; 
        
        // Create header bar and buttons
        CGRect navBarFrame = CGRectMake(self.view.frame.origin.x,
                                        0,
                                        self.view.frame.size.width,
                                        44);
        
        self.navBar = [[UIToolbar alloc] initWithFrame:navBarFrame];
        [navBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_clear.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
        //[navBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_clear.png"] forBarMetrics:UIBarMetricsDefault];
        [self.view addSubview:navBar];
        
        UIImageView *topDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_bottom.png"]];
        topDivet.frame = CGRectMake(self.view.frame.origin.x,
                                    navBarFrame.size.height + 1,
                                    self.view.frame.size.width,
                                    1);
        [self.view addSubview:topDivet];
        UIImageView *bottomDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_top.png"]];
        bottomDivet.frame = CGRectMake(self.view.frame.origin.x,
                                       navBarFrame.size.height,
                                       self.view.frame.size.width,
                                       1);
        [self.view addSubview:bottomDivet];
        
        // Create scroll view
        self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                         navBar.frame.size.height + 2,
                                                                         self.view.frame.size.width,
                                                                         self.view.frame.size.height - navBar.frame.size.height - 2)];
        scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * kNumberOfPages, scrollView.frame.size.height);
        scrollView.scrollEnabled = NO;
        scrollView.delegate = self;
        
        NSMutableArray *controllers = [[NSMutableArray alloc] init];
        for (unsigned i = 0; i < kNumberOfPages; i++) {
            [controllers addObject:[NSNull null]];
        }
        
        self.viewControllers = controllers;
        
        [self loadScrollViewWithPage:0];
        [self loadScrollViewWithPage:1];
        //[self loadScrollViewWithPage:2];
        
        [scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        [self setToolbarToPage:0];
        
        [self.view addSubview:scrollView];
        
        // Create dictionary to store all the user's data
        self.attributes = [NSMutableDictionary dictionaryWithCapacity:15];
    }
    return self;
}

// -------------------------------------------------------------
// Basic profile information was successfully input
// -------------------------------------------------------------
- (void)basicProfileCreationSucceededWithDictionary:(NSDictionary *)dict
{
    [attributes addEntriesFromDictionary:dict];
    [self scrollToNextPage];
}

// -------------------------------------------------------------
// Location profile information was successfully input
// -------------------------------------------------------------
- (void)locationProfileCreationSucceededWithDictionary:(NSDictionary *)dict
{
    [attributes addEntriesFromDictionary:dict];
    [self scrollToNextPage];
}

// -------------------------------------------------------------
// Dismiss the view controller
// -------------------------------------------------------------
- (void)cancelSignUp
{
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CarmaRootViewController *rootViewController = delegate.rootViewController;
    [rootViewController showSignUpView];
    //[self dismissModalViewControllerAnimated:YES];
}

- (void)finishSignUp
{
    //NSLog(@"%@", attributes);
    
    // Save user to database
    LLDataDownloader *signIn = [[LLDataDownloader alloc] init];
    signIn.delegate = self;
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_sign_up.php"];
    NSMutableArray *parameters = [NSMutableArray arrayWithCapacity:[attributes count]];
    for (id attribute in attributes)
    {
        if (attribute != nil)
        {
            NSString *parameter = [NSString stringWithFormat:@"%@=%@", attribute, [attributes objectForKey:attribute]];
            [parameters addObject:parameter];
        }
    }
    NSString *params = [parameters componentsJoinedByString:@"&"];
    if (![signIn postDataWithURL:url andParams:params]) {NSLog(@"Couldn't download %@", url);}
}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString);
    
    // Parse driver data
    SBJSON *jsonParser = [SBJSON new];	
    NSDictionary *driverData = [jsonParser objectWithString:responseString];
    
    // Save the user's data in our data model
    CarmaDriver *driver = [[CarmaDriver alloc] initWithDictionary:driverData];
    
    // Save the user's idea so they don't need to log in next time
    [[NSUserDefaults standardUserDefaults] setObject:driver.uID forKey:UserIDKey];
    [[NSUserDefaults standardUserDefaults] setObject:[attributes objectForKey:@"userName"] forKey:UsernameKey];
    [[NSUserDefaults standardUserDefaults] setObject:[attributes objectForKey:@"password"] forKey:PasswordKey];
    [[NSUserDefaults standardUserDefaults] setObject:driver.firstName forKey:FirstNameKey];
    
    // Tell the system that we've successfully logged in
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CarmaUserLoggedInNotification" object:driver];
    
    // Dismiss sign up viewer
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CarmaRootViewController *rootViewController = delegate.rootViewController;
    [rootViewController dismissModalViewControllerAnimated:YES];
}

#pragma mark -
#pragma mark UIScrollView Methods
// -------------------------------------------------------------
// Scrolls to a given page
// -------------------------------------------------------------
-(void)scrollToPage:(int)page
{
    [scrollView setContentOffset:CGPointMake(scrollView.frame.size.width * page, 0) animated:YES];
    [self.view endEditing:YES];
    [self setToolbarToPage:page];
}

- (void)scrollToPreviousPage
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    [self scrollToPage:page-1];
}

- (void)scrollToNextPage
{
    int page = scrollView.contentOffset.x / scrollView.frame.size.width;
    
    if (page + 1 == kNumberOfPages)
    {
        [self finishSignUp];
    }
    
    else
    {
        [self scrollToPage:page+1];
    }
}

- (void)setToolbarToPage:(int)page
{
    
    self.leftButton = [[UIBarButtonItem alloc] init];
    leftButton.style = UIBarButtonItemStyleBordered;
    leftButton.target = self;
    leftButton.enabled = YES;
    
    self.rightButton = [[UIBarButtonItem alloc] init];
    rightButton.style = UIBarButtonItemStyleBordered;
    rightButton.target = [viewControllers objectAtIndex:page];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    title.textAlignment = UITextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20.0];
    title.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    
    if (page == kBasicProfilePage)
    {
        leftButton.title = @"Cancel";
        leftButton.action = @selector(cancelSignUp);
        if ([[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey] == nil)
        {
            //leftButton.enabled = NO;
        }
        rightButton.title = @"Next";
        rightButton.action = @selector(validateSignIn);
        title.text = @"Welcome!";
    }
    
    else if (page == kPhotoPage)
    {
        leftButton.title = @"Back";
        leftButton.action = @selector(scrollToPreviousPage);
        rightButton.title = @"Next";
        //rightButton.action = @selector(validateSignIn);
        title.text = @"Pick a pic!";
    }
    
    else if (page == kOriginPage)
    {
        leftButton.title = @"Back";
        leftButton.action = @selector(scrollToPreviousPage);
        rightButton.title = @"Next";
        rightButton.action = @selector(validateAddress);
        title.text = @"Home Address";
    }
    
    else if (page == kDestinationpage)
    {
        leftButton.title = @"Back";
        leftButton.action = @selector(scrollToPreviousPage);
        rightButton.title = @"Join!";
        rightButton.action = @selector(validateAddress);
        title.text = @"Work Address";
    }
    
    NSArray *buttons = [[NSArray alloc] initWithObjects:leftButton, space, titleButton, space, rightButton, nil];
    [navBar setItems:buttons];
    //navBar.backItem.rightBarButtonItem = rightButton;
    //navBar.backItem.leftBarButtonItem = leftButton;
}

// -------------------------------------------------------------
// Loads individual scrollView pages
// -------------------------------------------------------------
- (void)loadScrollViewWithPage:(int)page
{
	if (page < 0) return;
    if (page >= kNumberOfPages) return;
	
	if (page == kBasicProfilePage)
    {
        CarmaProfileBasicViewController *controller = [viewControllers objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[CarmaProfileBasicViewController alloc] init];
            controller.delegate = self;
            [viewControllers replaceObjectAtIndex:page withObject:controller];
        }
        
        // add the controller's view to the scroll view
        if (nil == controller.view.superview) {
            CGRect frame = scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [scrollView addSubview:controller.view];
        }
    }
    
    else if (page == kOriginPage)
    {
        CarmaProfileLocationViewController *controller = [viewControllers objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[CarmaProfileLocationViewController alloc] init];
            controller.delegate = self;
            controller.locationType = CarmaProfileLocationTypeOrigin;
            [viewControllers replaceObjectAtIndex:page withObject:controller];
        }
        
        // add the controller's view to the scroll view
        if (nil == controller.view.superview) {
            CGRect frame = scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [scrollView addSubview:controller.view];
        }
    }
    
    else if (page == kDestinationpage)
    {
        CarmaProfileLocationViewController *controller = [viewControllers objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null])
        {
            controller = [[CarmaProfileLocationViewController alloc] init];
            controller.delegate = self;
            controller.locationType = CarmaProfileLocationTypeDestination;
            [viewControllers replaceObjectAtIndex:page withObject:controller];
        }
        
        // add the controller's view to the scroll view
        if (nil == controller.view.superview) {
            CGRect frame = scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [scrollView addSubview:controller.view];
        }
    }
    
    else
    {
        UIViewController *controller = [viewControllers objectAtIndex:page];
        if ((NSNull *)controller == [NSNull null]) {
            controller = [[UIViewController alloc] init];
            [viewControllers replaceObjectAtIndex:page withObject:controller];
        }
        
        // add the controller's view to the scroll view
        if (nil == controller.view.superview) {
            CGRect frame = scrollView.frame;
            frame.origin.x = frame.size.width * page;
            frame.origin.y = 0;
            controller.view.frame = frame;
            [scrollView addSubview:controller.view];
        }
    }
	
		
}

// -------------------------------------------------------------
// Changes scrollView page when it is scrolled at least 50%
// -------------------------------------------------------------
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
	// Switch the indicator when more than 50% of the previous/next page is visible
	
	CGFloat pageWidth = scrollView.frame.size.width;
	int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	
	// load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
	[self loadScrollViewWithPage:page - 1];
	[self loadScrollViewWithPage:page];
	[self loadScrollViewWithPage:page + 1];
    
    //[self setToolbarToPage:page];
}

@end
