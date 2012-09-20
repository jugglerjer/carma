//
//  CarmaUserViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaUserViewController.h"
#import "CarmaUserProfileCell.h"
#import <QuartzCore/QuartzCore.h>
#import "SBJSON.h"
#import "CarmaPool.h"
#import "CarmaProfileEditViewController.h"

static NSString* const UserIDKey = @"UserID";

#define kNumberOfRows       6
#define kUserRow            0
#define kHomeRow            1
#define kMorningRow         2
#define kWorkRow            3
#define kEveningRow         4
#define kCarRow             5

#define kAccountPhotoDownloader     0
#define kCarpoolInfoDownloader      1

static NSString *const UserImageURLPrefix = @"http://carma.io/styles/images/";

@interface CarmaUserViewController ()

@end

@implementation CarmaUserViewController

@synthesize visibleViewController;
@synthesize user;
@synthesize profileTable;
@synthesize icons;
@synthesize buttons;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.icons = [NSMutableArray arrayWithCapacity:kNumberOfRows];
        self.buttons = [NSMutableArray arrayWithCapacity:kNumberOfRows];
        isEditing = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the background
    //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueprint_background_verylight.png"]];
    //UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smooth_background_white.png"]];
    //[self.view addSubview:background];
    
    // Add an edit button
    // if we're viewing the user's own profile
    if ([user.uID isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey]])
    {
        UIBarButtonItem *edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(switchEditMode)];
        self.navigationItem.rightBarButtonItem = edit;
    }
	
    // Load the user's info table
    self.profileTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, 
                                                                       0,
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height)
                                                      style:UITableViewStylePlain];
    profileTable.delegate = self;
    profileTable.dataSource = self;
    profileTable.rowHeight = (profileTable.frame.size.height - 44) / kNumberOfRows;
    profileTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    //profileTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:profileTable];
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
    return kNumberOfRows;
}

// ------------------------------------------------------
// Build a transparent cell with top and bottom shading
// ------------------------------------------------------
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"UserProfileCell";
    CarmaUserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
    {
        cell = [[CarmaUserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    if (user)
    {
        if (indexPath.row == kUserRow)
        {
            UIView *backgroundView = [[UIView alloc] initWithFrame:cell.frame];
            backgroundView.backgroundColor = [UIColor colorWithRed:192/255 green:221/255 blue:232/255 alpha:1];
            //backgroundView.backgroundColor = [UIColor colorWithRed:197/255. green:243/255. blue:216/255. alpha:1];
            //backgroundView.backgroundColor = [UIColor blueColor];
            //cell.contentView.backgroundColor = [UIColor colorWithRed:191/256 green:221/256 blue:223/256 alpha:1];
            //cell.backgroundView.backgroundColor = [UIColor colorWithRed:191/256 green:221/256 blue:223/256 alpha:1];
            //cell.backgroundView.backgroundColor = [UIColor blueColor];
            //cell.backgroundView = backgroundView;
            
            //cell.contextLabel.text = @"Carma";
            //cell.dataLabel.text = @"24";
            cell.contextImage.image = [UIImage imageNamed:@"profile_icon.png"];
            
            // Load the cell image
            LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
            downloader.delegate = self;
            downloader.identifier = kAccountPhotoDownloader;
            NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, user.imageURL];
            if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
            
            // Download the other users in the carpool
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
            [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            [dateFormat setDateFormat:@"YYYY/MM/dd H:mm:ss"];
            NSString *date = [dateFormat stringFromDate:[NSDate date]];
            
            LLDataDownloader *carpoolInfoDownloader = [[LLDataDownloader alloc] init];
            carpoolInfoDownloader.delegate = self;
            carpoolInfoDownloader.identifier = kCarpoolInfoDownloader;
            NSString *infoURL = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_pool.php?id=%@&date=%@", user.uID, date];
            infoURL = [infoURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            if (![carpoolInfoDownloader getDataWithURL:infoURL]) {NSLog(@"Couldn't download %@", infoURL);}
            
            // Add button for applying to / inviting a user to join a carpool
//            UIImage *signinButtonImageNormal = [UIImage imageNamed:@"nav_button.png"];
//            UIImage *stretchableSigningButtonImageNormal = [signinButtonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:8];
//            
//            UIImage *signinButtonImagePressed = [UIImage imageNamed:@"nav_button_pressed.png"];
//            UIImage *stretchableSigningButtonImagePressed = [signinButtonImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:8];
//            
//            UIButton *applyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//            applyButton.frame = CGRectMake(230, 19, 80, 30);
//            [applyButton setBackgroundImage:stretchableSigningButtonImageNormal forState:UIControlStateNormal];
//            [applyButton setBackgroundImage:stretchableSigningButtonImagePressed forState:UIControlStateHighlighted];
//            [applyButton setTitle:@"Join!" forState:UIControlStateNormal];
//            [applyButton setTitle:@"Joining..." forState:UIControlStateDisabled];
//            applyButton.titleLabel.font = [UIFont fontWithName:@"Heiti TC" size:14.0];
//            //[applyButton addTarget:self action:@selector(validateSignIn) forControlEvents:UIControlEventTouchUpInside];
//            
//            int height = applyButton.frame.size.height - 1;
//            UIView *buttonBackground = [[UIView alloc] initWithFrame:CGRectMake(applyButton.frame.origin.x,
//                                                                                applyButton.frame.origin.y,
//                                                                                applyButton.frame.size.width,
//                                                                                height)];
//            buttonBackground.layer.cornerRadius = 4.0f;
//            buttonBackground.backgroundColor = [UIColor colorWithRed:144/255. green:233/255. blue:179/255. alpha:1]; // Dark green
//            //buttonBackground.backgroundColor = [UIColor colorWithRed:197/255. green:243/255. blue:216/255. alpha:1]; // Light green
//            
//            [cell addSubview:buttonBackground];
//            [cell addSubview:applyButton];
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == kHomeRow)
        {
            cell.contextLabel.text = @"Lives in";
            cell.dataLabel.text = user.originCity;
            cell.contextImage.image = [UIImage imageNamed:@"home_icon.png"];
            [icons addObject:cell.contextImage.image];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == kMorningRow)
        {
            cell.contextLabel.text = @"Leaves for work between";
            cell.dataLabel.text = @"9:00 am and 9:30 am";
            cell.contextImage.image = [UIImage imageNamed:@"sun_icon.png"];
            [icons addObject:cell.contextImage.image];
        }
        else if (indexPath.row == kWorkRow)
        {
            cell.contextLabel.text = @"Works in";
            cell.dataLabel.text = user.destinationCity;
            cell.contextImage.image = [UIImage imageNamed:@"work_icon.png"];
            [icons addObject:cell.contextImage.image];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        else if (indexPath.row == kEveningRow)
        {
            cell.contextLabel.text = @"Heads home between";
            cell.dataLabel.text = @"5:00 pm and 5:30 pm";
            cell.contextImage.image = [UIImage imageNamed:@"moon_icon.png"];
            [icons addObject:cell.contextImage.image];
        }
        else if (indexPath.row == kCarRow)
        {
            cell.contextLabel.text = @"Drives a";
            cell.dataLabel.text = @"2004 Honda Civic";
            cell.contextImage.image = [UIImage imageNamed:@"wheel_icon.png"];
            [icons addObject:cell.contextImage.image];
        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    if (downloader.identifier == kAccountPhotoDownloader)
    {
        UIImage *imageTemp = [UIImage imageWithData:data];
        if (imageTemp != nil)
        {
            //UIImage *image = [self imageWithImage:imageTemp scaledToSize:CGSizeMake(45, 45)];
            CarmaUserProfileCell *cell = (CarmaUserProfileCell *)[profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kUserRow inSection:0]];
            cell.contextImage.image = imageTemp;
            cell.contextImage.frame = CGRectMake(12, 12, 45, 45);
            cell.contextImage.layer.cornerRadius = 6.0f;
            cell.contextImage.layer.masksToBounds = YES;
        }
    }
    
    else if (downloader.identifier == kCarpoolInfoDownloader)
    {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", responseString);
        SBJSON *jsonParser = [SBJSON new];	
        NSDictionary *daysData = [jsonParser objectWithString:responseString];
        CarmaPool *pool = [[CarmaPool alloc] initWithDictionary:daysData];
                
        int i = kCarpoolInfoDownloader + 1;
        for (NSString *driverID in pool.drivers)
        {
            CarmaDriver *driver = [pool.drivers objectForKey:driverID];
            if (![user.uID isEqualToString:driver.uID])
            {
                // Load the user's profile image
                LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
                downloader.delegate = self;
                downloader.identifier = i;
                NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, driver.imageURL];
                if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
                i++;
            }
            CarmaUserProfileCell *cell = (CarmaUserProfileCell *)[profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kUserRow inSection:0]];
            cell.contextLabel.text = [NSString stringWithFormat:@"Carpools with %d others", [pool.drivers count] - 1];
        }
    }
    else
    {
        UIImage *imageTemp = [UIImage imageWithData:data];
        if (imageTemp == nil)
        {
            imageTemp = [UIImage imageNamed:@"mini_profile.png"];
        }
        UIImageView *imageView = [[UIImageView alloc] initWithImage:imageTemp];
        imageView.frame = CGRectMake(69 + ((downloader.identifier-2)*(23+6)), (12+69-(23*2)), 23, 23);
        imageView.layer.cornerRadius = 4.0f;
        imageView.layer.masksToBounds = YES;
        CarmaUserProfileCell *cell = (CarmaUserProfileCell *)[profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:kUserRow inSection:0]];
        [cell addSubview:imageView];
    }
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

# pragma mark Proflie Editing Methods

- (void)switchEditMode
{
    if (isEditing)
    {
        isEditing = NO;
        self.navigationItem.rightBarButtonItem.title = @"Edit";
        [self hideEditButtons];
    }
    else
    {
        isEditing = YES;
        [self showEditButtons];
        self.navigationItem.rightBarButtonItem.title = @"Done";
    }
}

// ------------------------------------------------------
// Animate the edit buttons either into or out of view
// ------------------------------------------------------
- (void)showEditButtons
{
    /*NSArray *buttonNames = [NSArray arrayWithObjects:@"home_button.png",
                            @"sun_button.png",
                            @"work_button.png",
                            @"moon_button.png",
                            @"wheel_button.png", nil];*/
    for (int i = 0 ; i < [icons count] ; i++)
    {
        CarmaUserProfileCell *cell = (CarmaUserProfileCell *)[profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        int buttonWidth = 50;
        int buttonHeight = 50;
        button.frame = CGRectMake(((cell.contextImage.frame.size.width - buttonWidth) / 2) * -1,
                                  (cell.contextImage.frame.size.height - buttonHeight) / 2,
                                  buttonWidth,
                                  buttonHeight);
        [button setBackgroundImage:[UIImage imageNamed:@"edit_button.png"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(editProfileInfoForCell:) forControlEvents:UIControlEventTouchUpInside];
        button.contentMode = UIViewContentModeCenter;
        button.alpha = 0;
        button.tag = i+1;
        
        [cell addSubview:button];
        [buttons insertObject:button atIndex:i];
        
        [UIView animateWithDuration:0.2
                         animations:^
        {
            button.frame = CGRectMake((cell.contextImage.frame.size.width - buttonWidth) / 2,
                                      (cell.contextImage.frame.size.height - buttonHeight) / 2,
                                      buttonWidth,
                                      buttonHeight);
            button.alpha = 1;
            cell.contextImage.alpha = 0;
        } completion:^(BOOL finished)
        {
            cell.contextImage.image = nil;
        }];
        
    }
}

- (void)hideEditButtons
{
    for (int i = 0 ; i < [icons count] ; i++)
    {
        CarmaUserProfileCell *cell = (CarmaUserProfileCell *)[profileTable cellForRowAtIndexPath:[NSIndexPath indexPathForRow:i+1 inSection:0]];
        UIButton *button = [buttons objectAtIndex:i];
        cell.contextImage.image = [icons objectAtIndex:i];
        
        [UIView animateWithDuration:0.2 animations:^
         {
             button.frame = CGRectMake(button.frame.origin.x * -1,
                                       button.frame.origin.y,
                                       button.frame.size.width,
                                       button.frame.size.height);
             button.alpha = 0;
             cell.contextImage.alpha = 1;
         }
         completion:^(BOOL finished)
         {
             [button removeFromSuperview];
         }];
        
    }
}

- (void)editProfileInfoForCell:(UIButton *)sender
{    
    // Build toolbar
    CarmaProfileEditViewController *backgroundView = [[CarmaProfileEditViewController alloc] initWithEditView:sender.tag andDriver:user];
    backgroundView.delegate = self;
    self.visibleViewController = backgroundView;
//    UIToolbar *bar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
//    [bar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
//    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] init];
//    leftButton.style = UIBarButtonItemStyleBordered;
//    leftButton.title = @"Cancel";
//    leftButton.target = self;
//    leftButton.action = @selector(cancelEditModalView);
//    
//    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
//    rightButton.style = UIBarButtonItemStyleBordered;
//    rightButton.title = @"Done"; // This button's selector will be set by the 
//    
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
//    title.textAlignment = UITextAlignmentCenter;
//    title.backgroundColor = [UIColor clearColor];
//    title.textColor = [UIColor whiteColor];
//    title.font = [UIFont boldSystemFontOfSize:20.0];
//    title.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//    UIBarButtonItem *titleButton = [[UIBarButtonItem alloc] initWithCustomView:title];
//    
//    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    
//    if (sender.tag == kHomeRow)
//    {
//        CarmaProfileLocationViewController *controller = [[CarmaProfileLocationViewController alloc] init];
//        controller.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
//        controller.delegate = self;
//        controller.locationType = CarmaProfileLocationTypeOrigin;
//        rightButton.target = controller;
//        rightButton.action = @selector(validateAddress);
//        title.text = @"Home Address";
//        
//        [backgroundView.view addSubview:controller.view];
//        self.visibleViewController = (UIViewController *)controller;
//    }
//    
//    else if (sender.tag == kWorkRow)
//    {
//        CarmaProfileLocationViewController *controller = [[CarmaProfileLocationViewController alloc] init];
//        controller.view.frame = CGRectMake(0, 44, self.view.frame.size.width, self.view.frame.size.height);
//        controller.delegate = self;
//        controller.locationType = CarmaProfileLocationTypeDestination;
//        rightButton.target = controller;
//        rightButton.action = @selector(validateAddress);
//        title.text = @"Work Address";
//        
//        [backgroundView.view addSubview:controller.view];
//        self.visibleViewController = (UIViewController *)controller;
//    }
//    
//    else
//    {
//        return;
//    }
//    
//    NSArray *buttonsToPlace = [[NSArray alloc] initWithObjects:leftButton, space, titleButton, space, rightButton, nil];
//    [bar setItems:buttonsToPlace];
//    
//    [backgroundView.view addSubview:bar];
    
    //[self presentModalViewController:backgroundView animated:YES];
    [self presentViewController:backgroundView animated:YES completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalViewControllerPresented" object:backgroundView];
    
}

- (void)cancelEditModalView
{
    [self dismissModalViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ModalViewControllerDismissed" object:visibleViewController];
}

// ------------------------------------------------------
// Delegate method called when done editing location info
// ------------------------------------------------------
- (void)locationProfileCreationSucceededWithDictionary:(NSDictionary *)dict
{
    [user updateDriverWithAttributes:dict];
    [self cancelEditModalView];
}

@end
