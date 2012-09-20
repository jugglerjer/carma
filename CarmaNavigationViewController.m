//
//  CarmaNavigationViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaNavigationViewController.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImage+Resize.h"

static NSString* const FirstNameKey = @"FirstName";
static NSString *const UserImageURLPrefix = @"http://carma.io/styles/images/";
static CGFloat kButtonSize = 50;

#define kNumberOfViews          6
#define kAccountView            0
#define kDashboardView          1
#define kCalendarView           2
#define kSearchView             3
#define kSettingsView           4
#define kSignOutView            5

@interface CarmaNavigationViewController ()

@end

@implementation CarmaNavigationViewController

@synthesize delegate;
@synthesize navTable;
@synthesize driver;

@synthesize powerButton;
@synthesize navButtons;

- (id)init
{
    self = [super init];
    if (self)
    {
        // Register for notifications when the user signs in
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSignIn:) name:@"CarmaUserLoggedInNotification" object:nil];
    }
    
    return self;
}

- (void)userDidSignIn:(NSNotification *)notification
{
    LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
    downloader.delegate = self;
    self.driver = [notification object];
    NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, driver.imageURL];
    if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
//    UIImage *image = [UIImage imageWithData:data];
//    UIImage *smallImage = [image thumbnailImage:23 transparentBorder:2 cornerRadius:6 interpolationQuality:kCGInterpolationDefault];
////    UIImage *roundedImage = [self makeRoundedImage:image radius:6.0f];
////    UIImage *smallImage = [self imageWithImage:roundedImage scaledToSize:CGSizeMake(25, 25)];
//    UITableViewCell *cell = [navTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kAccountView inSection:0]];
////    int imageSize = 30;
////    cell.imageView.frame = CGRectMake((cell.imageView.frame.size.width - imageSize) / 2,
////                                      (cell.imageView.frame.size.height - imageSize) / 2,
////                                      imageSize,
////                                      imageSize);
////    cell.imageView.layer.cornerRadius = 6.0f;
////    cell.imageView.layer.masksToBounds = YES;
//    cell.imageView.contentMode = UIViewContentModeCenter;
//    cell.imageView.image = smallImage;
}

// ------------------------------------------------------
// Resize the profile pic
// ------------------------------------------------------
- (UIImage *)imageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    return newImage;
}

-(UIImage *)makeRoundedImage:(UIImage *) image 
                      radius: (float) radius;
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    imageLayer.contents = (id) image.CGImage;
    
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = radius;
    
    UIGraphicsBeginImageContext(image.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return roundedImage;
}

// ------------------------------------------------------
// Set up navigation table
// ------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Navigation table
//    CGRect tableFrame = CGRectMake(self.view.frame.origin.x, 0, self.view.frame.size.width, self.view.frame.size.height);
//    
//    self.navTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStylePlain];
//    navTable.backgroundColor = [UIColor clearColor];
//    navTable.separatorStyle = UITableViewCellSeparatorStyleNone;
//    navTable.delegate = self;
//    navTable.dataSource = self;
//    [self.view addSubview:navTable];
    
    [self loadNavButtons];
    
    // Add settings button
//    UIButton *settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 44, 44, 44)];
//    [settingsButton setImage:[UIImage imageNamed:@"gear_button_icon.png"] forState:UIControlStateNormal];
//    settingsButton.showsTouchWhenHighlighted = YES;
//    [settingsButton addTarget:self action:@selector(showSettings) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:settingsButton];
//    
//    // Add power button
//    self.powerButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 360, 44, 44)];
//    [powerButton setImage:[UIImage imageNamed:@"power_button_icon.png"] forState:UIControlStateNormal];
//    powerButton.showsTouchWhenHighlighted = YES;
//    //[powerButton addTarget:self action:@selector(confirmSignOut) forControlEvents:UIControlEventTouchUpInside];
//    powerButton.alpha = 0;
//    [self.view addSubview:powerButton];
}

- (void)loadNavButtons
{
    int buttonSpace = (self.view.frame.size.height + 20 - (kButtonSize * kNumberOfViews)) / (kNumberOfViews + 2);
    
    NSArray *buttonNames = [NSArray arrayWithObjects:@"user_button_icon.png",
                            @"dashboard_button_icon.png",
                            @"path_button_icon.png",
                            @"search_button_icon.png",
                            @"gear_button_icon",
                            @"power_button_icon", nil];
    self.navButtons = [NSMutableArray arrayWithCapacity:[buttonNames count]];
    for (NSString *name in buttonNames)
    {
        int index = [buttonNames indexOfObject:name];
        CGRect frame = CGRectMake(0,
                                  buttonSpace + index * (buttonSpace + kButtonSize),
                                  kButtonSize,
                                  kButtonSize);
        
        UIButton *button = [[UIButton alloc] initWithFrame:frame];
        [button setImage:[UIImage imageNamed:name] forState:UIControlStateNormal];
        button.showsTouchWhenHighlighted = YES;
        [button addTarget:self action:@selector(didSelectButton:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = index;
        button.alpha = 0;
        
        [self.view addSubview:button];
        [navButtons addObject:button];
    }
}

- (void)didSelectButton:(UIButton *)sender
{    
    if ([delegate respondsToSelector:@selector(navigationView:userDidSelectNewRow:)])
    {
        [delegate navigationView:self userDidSelectNewRow:sender.tag];
    }
}

#pragma mark - Table view data source

// ------------------------------------------------------
// Return 1 section
// ------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

// ------------------------------------------------------
// Return number of views to choose from
// ------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return kNumberOfViews;
}

// ------------------------------------------------------
// Build a transparent cell with top and bottom shading
// ------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        // Add separator images to cell
        UIImageView *topDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_bottom.png"]];
        topDivet.frame = CGRectMake(cell.frame.origin.x,
                                    cell.frame.origin.y,
                                    cell.frame.size.width,
                                    1);
        [cell addSubview:topDivet];
        UIImageView *bottomDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_top.png"]];
        bottomDivet.frame = CGRectMake(cell.frame.origin.x,
                                       cell.frame.size.height - 1,
                                       cell.frame.size.width,
                                       1);
        [cell addSubview:bottomDivet];
        
        // Add highlighting when tapped
        UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        selectedBackgroundView.backgroundColor = [UIColor colorWithRed:.04 green:.24 blue:.33 alpha:1];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        // Format text
        cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:19.0];
        cell.textLabel.textColor = [UIColor whiteColor];
        
    }
    
    if (indexPath.row == kAccountView)
    {
        //cell.textLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:FirstNameKey];
        cell.textLabel.text = @"You";
        cell.imageView.image = [UIImage imageNamed:@"user_icon.png"];
        
        if (driver)
        {
            LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
            downloader.delegate = self;
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, driver.imageURL];
            if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
        }
    }
    
    else if (indexPath.row == kDashboardView)
    {
        cell.textLabel.text = @"Dashboard";
        cell.imageView.image = [UIImage imageNamed:@"dashboard_icon.png"];
    }
    
    else if (indexPath.row == kCalendarView)
    {
        cell.textLabel.text = @"Schedule";
        cell.imageView.image = [UIImage imageNamed:@"path_icon.png"];
    }
    
    else if (indexPath.row == kSearchView)
    {
        cell.textLabel.text = @"Search";
        cell.imageView.image = [UIImage imageNamed:@"search_icon.png"];
    }
    
    else if (indexPath.row == kSettingsView)
    {
        cell.textLabel.text = @"Settings";
        cell.imageView.image = [UIImage imageNamed:@"gear_icon.png"];
    }
    
    else if (indexPath.row == kSignOutView)
    {
        cell.textLabel.text = @"Sign out";
        cell.imageView.image = [UIImage imageNamed:@"power_icon.png"];
    }
    
    return cell;
}

#pragma mark - Table view delegate

// ------------------------------------------------------
// Deselect cell
// ------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([delegate respondsToSelector:@selector(navigationView:userDidSelectNewRow:)])
    {
        [delegate navigationView:self userDidSelectNewRow:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - Animation methods

// ------------------------------------------------------
// Animate the movement of an icon across the screen
// ------------------------------------------------------
- (void)animateIconWithScrollView:(LLSwipePanel *)scrollView
{
    // Create a line equation in order to calculate the distance the icon needs to travel
    // y = m(x) + b
    // y = the position of the icon
    // x = the postition of the scrollView
    double b = (self.view.frame.size.width - scrollView.panelGripSpace - kButtonSize) / 2;
    double m = (0 - b) / (self.view.frame.size.width - scrollView.panelGripSpace);
    double x = scrollView.contentOffset.x;
    
    // To eliminate the effect of bounce back, cap x at 0
    //if (x < 0) {x = 0;}
    
    double thisDistance = (m * x) + b;
    double totalDistance = 0 + (self.view.frame.size.width - kButtonSize - scrollView.panelGripSpace) / 2;
    
    // Full animation should take 0.1 seconds
    // The ratio of the duration of this animation to the full animation
    // should be equal to the ratio of the distance it needs to travel now
    // to the total distance it needs to travel    
    double duration = (0.01 * thisDistance) / totalDistance;
    
    // Full alpha should be 1.0
    // The ratio of the alpha of this of this animation to the full alpha
    // should be equal to the ratio of the distance it needs to travel now
    // to the total distance it needs to travel    
    double alpha = (1.0 * thisDistance) / totalDistance; 
    
    // The buttons should enter at slightly different times
    // with the entire animation lasting 0.2 seconds
    // Delay each animation by its order times 0.1 / the number of icons
    double increment = 0.00 / [navButtons count];
    double delay = 0;
    
    for (UIButton *button in navButtons)
    {
        // Animate Icon into view
        [UIView animateWithDuration:duration delay:delay options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear
                         animations:^{button.frame = CGRectMake(thisDistance,
                                                                     button.frame.origin.y,
                                                                     button.frame.size.width,
                                                                     button.frame.size.height);
                             button.alpha = alpha;}
                         completion:nil];
        delay = delay + increment;
    }
}

@end
