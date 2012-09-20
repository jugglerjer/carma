//
//  CarmaSettingsViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/8/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaSettingsViewController.h"
#import "AppDelegate.h"

@interface CarmaSettingsViewController ()

@end

@implementation CarmaSettingsViewController

@synthesize settingsTable;
@synthesize selectedIndexPath;
@synthesize pool;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Register for notifications when the user signs in
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carpoolInfoDidDownload:) name:@"CarmaPoolInfoDownloadedNotification" object:nil];
        
        self.title = @"Settings";
        
        // Set default values
        kCarpoolSection = -1;
        kGeoSection = -1;
        kNotificationsSection = -1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Add background
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"gingham_background.png"]];
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"smooth_background_light.png"]];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueprint_background_verylight.png"]];
    [self.view addSubview:background];
    //backgroundView.frame = CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height + 44);
    //[self.view addSubview:backgroundView];
    //self.view.backgroundColor = [UIColor colorWithRed:242/255. green:247/255. blue:250/255. alpha:1];
    //self.view.backgroundColor = [UIColor clearColor];
    
//    UIView *backgroundView = [[UIView alloc] init];
//    backgroundView.frame = CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height + 44);
//    backgroundView.backgroundColor = [UIColor colorWithRed:.12 green:.38 blue:.51 alpha:1]; // Dark blue
//    [self.view addSubview:backgroundView];
    
//    UIImageView *topDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_bottom.png"]];
//    topDivet.frame = CGRectMake(self.view.frame.origin.x,
//                                1,
//                                self.view.frame.size.width,
//                                1);
//    [self.view addSubview:topDivet];
//    UIImageView *bottomDivet = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"divet_top.png"]];
//    bottomDivet.frame = CGRectMake(self.view.frame.origin.x,
//                                   0,
//                                   self.view.frame.size.width,
//                                   1);
//    [self.view addSubview:bottomDivet];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    rightButton.style = UIBarButtonItemStyleBordered;
    rightButton.target = self;
    rightButton.action = @selector(dismiss);
    rightButton.title = @"Done";
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Build the settings table
    self.settingsTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                       0,
                                                                       self.view.frame.size.width,
                                                                       self.view.frame.size.height)
                                                      style:UITableViewStyleGrouped];
    settingsTable.delegate = self;
    settingsTable.dataSource = self;
    settingsTable.backgroundColor = [UIColor clearColor];
    [self.view addSubview:settingsTable];
}

// ------------------------------------------------------
// Dismiss the view and show the swipe panel
// ------------------------------------------------------
- (void)dismiss
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    //AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //[delegate.rootViewController performSelector:@selector(nudgeSwipePanel) withObject:nil afterDelay:1];
}

- (void)viewWillAppear:(BOOL)animated
{
    [settingsTable reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [settingsTable deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

// ------------------------------------------------------
// Update the table with the user's carpool settings
// ------------------------------------------------------
- (void)carpoolInfoDidDownload:(NSNotification *)notification
{
    self.pool = [notification object];
    
    [settingsTable reloadData];
}

// ------------------------------------------------------
// Send the users updated rotation settings to the server
// ------------------------------------------------------
- (void)rotationSettingsDidChangeForPool:(CarmaPool *)newPool
{
    LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
    downloader.delegate = self;
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_update_pool.php"];
    NSString *params = [NSString stringWithFormat:@"newMethod=%@&newLength=%@&newDay=%@",
                        newPool.rotationMethod,
                        newPool.rotationLength,
                        newPool.rotationDay];
    if (![downloader postDataWithURL:url andParams:params]) {NSLog(@"Couldn't download %@", url);}
    
    [self performSelector:@selector(postSettingsChangedNotification) withObject:nil afterDelay:2];
}

- (void)postSettingsChangedNotification
{
    // Tell the system that settings have been changed
    [[NSNotificationCenter defaultCenter] postNotificationName:@"CarmaPoolSettingsChangedNotification" object:pool];
}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    //NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", responseString);
}

#pragma mark - Table view data source

// ------------------------------------------------------
// Return 1 section
// ------------------------------------------------------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (pool == nil)
    {
        kNotificationsSection = 0;
        kGeoSection = 1;
        return 2;
    }
    
    else
    {
        kCarpoolSection = 0;
        kNotificationsSection = 2;
        kGeoSection = 1;
        return 3;
    }
}

// ------------------------------------------------------
// Return number of views to choose from
// ------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kCarpoolSection)
    {
        return 1;
    }
    
    else if (section == kNotificationsSection)
    {
        return 2;
    }
    
    else /* section == kGeoSection */
    {
        return 2;
    }
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
    }
    
    cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:17.0];
    cell.textLabel.textColor = [UIColor colorWithRed:25/255. green:78/255. blue:112/255. alpha:1];
    
    if (indexPath.section == kCarpoolSection)
    {
        //cell.imageView.image = [UIImage imageNamed:@"shuffle_icon.png"];
        
        NSString *cellText = @"Rotate driver every ";
        NSString *method = pool.rotationMethod;
        if ([method isEqualToString:@"length"])
        {
            NSNumber *days = pool.rotationLength;
            if ([days intValue] > 1)
            {
                cellText = [cellText stringByAppendingFormat:@"%@ days", days];
            }
            else {
                cellText = [cellText stringByAppendingString:@"day"];
            }
        }
        else if ([method isEqualToString:@"day"])
        {
            NSNumber *day = pool.rotationDay;
            NSString *dayString;
            switch ([day intValue])
            {
                case 0:
                    dayString = @"Sunday"; break;
                case 1:
                    dayString = @"Monday"; break;
                case 2:
                    dayString = @"Tuesday"; break;
                case 3:
                    dayString = @"Wednesday"; break;
                case 4:
                    dayString = @"Thursday"; break;
                case 5:
                    dayString = @"Friday"; break;
                case 6:
                    dayString = @"Saturday"; break;
                default:
                    break;
            }
            
            cellText = [cellText stringByAppendingString:dayString];
        }
        
        cell.textLabel.text = cellText;
    }
    else if (indexPath.section == kNotificationsSection)
    {
        if (indexPath.row == 0)
        {
            cell.textLabel.text = @"When I'm on my way";
        }
        else if (indexPath.row == 1)
        {
            cell.textLabel.text = @"When my ride is on its way";
        }
    }
    
    return cell;
}

// ------------------------------------------------------
// Set the section headers
// ------------------------------------------------------
//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    if (section == kCarpoolSection)
//    {
//        return @"Carpool settings";
//    }
//    
//    else /* section == kPersonalSection */
//    {
//        return @"Personal settings";
//    }
//}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(19.0, 4.25, 320.0, 46.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:header.frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.font = [UIFont fontWithName:@"Heiti TC" size:19.0];
    
    if (section == kCarpoolSection)
    {
        label.text = @"Carpool";
    }
    
    else if (section == kNotificationsSection)
    {
        label.text = @"Notifications";
    }
    
    else /* section == kPersonalSection */
    {
        label.text = @"Location";
    }

    
    [header addSubview:label];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
//    if (section == kNotificationsSection)
//    {
//        UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(19, 4.25, 320, 50)];
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//        label.text = @"Carma will alert your passengers when you leave your home or office only on the days you're scheduled to drive and between the hours you've specified in your profile.";
//        // Colors and font
//        label.backgroundColor = [UIColor clearColor];
//        label.font = [UIFont fontWithName:@"Heiti TC" size:14.0];
//        //label.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
//        label.textColor = [UIColor whiteColor];
//        // Automatic word wrap
//        label.lineBreakMode = UILineBreakModeWordWrap;
//        label.textAlignment = UITextAlignmentCenter;
//        label.numberOfLines = 0;
//        // Autosize
//        //[label sizeToFit];
//        [footer addSubview:label];
//        [footer sizeToFit];
//        return footer;
//    }
    
    return nil;
}


#pragma mark - Table view delegate

// ------------------------------------------------------
// Show the picker when the user selects a 
// carpool settings row
// ------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CarmaPoolRotationSettingsViewController *controller = [[CarmaPoolRotationSettingsViewController alloc] init];
    controller.pool = self.pool;
    controller.title = @"Rotation";
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    
    self.selectedIndexPath = indexPath;
}


@end
