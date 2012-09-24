//
//  CarmaProfileEditViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/23/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaProfileEditViewController.h"
#import "CarmaUserViewController.h"

#define kNumberOfRows       6
#define kUserRow            0
#define kHomeRow            1
#define kMorningRow         2
#define kWorkRow            3
#define kEveningRow         4
#define kCarRow             5

@interface CarmaProfileEditViewController ()

@end

@implementation CarmaProfileEditViewController

@synthesize visibleViewController;
@synthesize delegate;
@synthesize driver;

- (id)initWithEditView:(int)v andDriver:(CarmaDriver *)d
{
    self = [super init];
    if (self)
    {        
        view = v;
        self.driver = d;
    }
    return self;
}

- (void)viewDidLoad
{
    // Load the background
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueprint_background_verylight.png"]];
    //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smooth_background_white.png"]];
    [self.view addSubview:background];
    
    // Add a toolbar with done and cancel buttons
    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, 44)];
    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [self.view addSubview:bar];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] init];
    leftButton.style = UIBarButtonItemStyleBordered;
    leftButton.title = @"Cancel";
    leftButton.target = self;
    leftButton.action = @selector(cancel);
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    rightButton.style = UIBarButtonItemStyleBordered;
    rightButton.title = @"Done"; // This button's selector will be set by the
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    title.textAlignment = UITextAlignmentCenter;
    title.backgroundColor = [UIColor clearColor];
    title.textColor = [UIColor whiteColor];
    title.font = [UIFont boldSystemFontOfSize:20.0];
    title.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    if (view == kHomeRow)
    {
        CarmaProfileLocationViewController *controller = [[CarmaProfileLocationViewController alloc] init];
        controller.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
        controller.delegate = delegate;
        controller.locationType = CarmaProfileLocationTypeOrigin;
        
        // Send the controller the values with which to pre-populate the text fields
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:4];
        [attributes setObject:driver.originStreet forKey:@"street"];
        [attributes setObject:driver.originCity forKey:@"city"];
        [attributes setObject:driver.originState forKey:@"state"];
        [attributes setObject:driver.originZip forKey:@"zip"];
        controller.attributes = attributes;
        
        rightButton.target = controller;
        rightButton.action = @selector(validateAddress);
        title.text = @"Home Address";
        
        [self.view addSubview:controller.view];
        self.visibleViewController = (UIViewController *)controller;
    }
    
    else if (view == kWorkRow)
    {
        CarmaProfileLocationViewController *controller = [[CarmaProfileLocationViewController alloc] init];
        controller.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
        controller.delegate = delegate;
        controller.locationType = CarmaProfileLocationTypeDestination;
        
        // Send the controller the values with which to pre-populate the text fields
        NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithCapacity:4];
        [attributes setObject:driver.destinationStreet forKey:@"street"];
        [attributes setObject:driver.destinationCity forKey:@"city"];
        [attributes setObject:driver.destinationState forKey:@"state"];
        [attributes setObject:driver.destinationZip forKey:@"zip"];
        controller.attributes = attributes;
        
        rightButton.target = controller;
        rightButton.action = @selector(validateAddress);
        title.text = @"Work Address";
        
        [self.view addSubview:controller.view];
        self.visibleViewController = (UIViewController *)controller;
    }
    
    else if (view == kMorningRow)
    {
        CarmaProfileTimeViewController *controller = [[CarmaProfileTimeViewController alloc] init];
        controller.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height - 44);
        
        [self.view addSubview:controller.view];
        self.visibleViewController = (UIViewController *)controller;
    }
    
    NSArray *buttonsToPlace = [[NSArray alloc] initWithObjects:leftButton, space, titleButton, space, rightButton, nil];
    [bar setItems:buttonsToPlace];
}

- (void)cancel
{
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalViewControllerDismissed" object:self];
}

@end
