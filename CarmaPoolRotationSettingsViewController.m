//
//  CarmaPoolRotationSettingsViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/15/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaPoolRotationSettingsViewController.h"

@implementation CarmaPoolRotationSettingsViewController

@synthesize table;
@synthesize picker;
@synthesize selectedMethodIndexPath;
@synthesize pool;

@synthesize oldMethod;
@synthesize oldLength;
@synthesize oldDay;

@synthesize delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Make copies of original pool settings
    if (pool != nil)
    {
        self.oldMethod = [pool.rotationMethod copy];
        self.oldLength = [pool.rotationLength copy];
        self.oldDay = [pool.rotationDay copy];
    }
    
    // Create background
    //UIImageView *backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueprint_background.png"]];
    //backgroundView.frame = CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height + 44);
    //[self.view addSubview:backgroundView];
    UIImageView *background = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"blueprint_background_verylight.png"]];
    [self.view addSubview:background];
    
//    UIView *backgroundView = [[UIView alloc] init];
//    backgroundView.frame = CGRectMake(0, -44, self.view.frame.size.width, self.view.frame.size.height + 44);
//    backgroundView.backgroundColor = [UIColor colorWithRed:.12 green:.38 blue:.51 alpha:1]; // Dark blue
//    [self.view addSubview:backgroundView];
//    
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
    
    // Add buttons to the nav bar
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] init];
    leftButton.style = UIBarButtonItemStyleBordered;
    leftButton.target = self;
    leftButton.action = @selector(cancel);
    leftButton.title = @"Cancel";
    self.navigationItem.leftBarButtonItem = leftButton;
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] init];
    rightButton.style = UIBarButtonItemStyleBordered;
    rightButton.target = self;
    rightButton.action = @selector(save);
    rightButton.title = @"Done";
    self.navigationItem.rightBarButtonItem = rightButton;
    
    // Set up the table which will summarize the settings
    CGRect tableFrame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    self.table = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    table.dataSource = self;
    table.delegate = self;
    table.backgroundColor = [UIColor clearColor];
    
    // Set up the picker view
    CGRect pickerFrame = CGRectMake(0, self.view.frame.size.height - 216 - 44, self.view.frame.size.width, 216);
    self.picker = [[UIPickerView alloc] initWithFrame:pickerFrame];
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    
    if ([pool.rotationMethod isEqualToString:@"length"])
    {
        [picker selectRow:[pool.rotationLength intValue] - 1 inComponent:0 animated:NO];
    }
    else if ([pool.rotationMethod isEqualToString:@"day"])
    {
        [picker selectRow:[pool.rotationDay intValue] inComponent:0 animated:NO];
    }
    
    
    [self.view addSubview:table];
    [self.view addSubview:picker];
}

// ------------------------------------------------------
// Dismiss the rotation settings modal view without saving
// ------------------------------------------------------
- (void)cancel
{
    // Switch back to original settings
    pool.rotationMethod = oldMethod;
    pool.rotationLength = oldLength;
    pool.rotationDay = oldDay;
    
    [self.navigationController popViewControllerAnimated:YES];
}

// ------------------------------------------------------
// Tell the delegate we're ready to save
// and dismiss the view
// ------------------------------------------------------
- (void)save
{
    if ([delegate respondsToSelector:@selector(rotationSettingsDidChangeForPool:)])
    {
        [delegate rotationSettingsDidChangeForPool:pool];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
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
// Return number of rotation methods to choose from
// ------------------------------------------------------
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

// ------------------------------------------------------
// Build the cells
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
    
    NSString *cellText = @"";
    
    if (indexPath.row == 0)
    {
        NSNumber *days = pool.rotationLength;
        if ([days intValue] > 1)
        {
            cellText = [cellText stringByAppendingFormat:@"Every %@ days", days];
        }
        else {
            cellText = [cellText stringByAppendingString:@"Every day"];
        }
        
        if ([pool.rotationMethod isEqualToString:@"length"])
        {
            cell.textLabel.textColor = [UIColor colorWithRed:25/255. green:78/255. blue:112/255. alpha:1];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedMethodIndexPath = indexPath;
        }
        else
        {
            cell.textLabel.textColor = [UIColor colorWithRed:118/255. green:118/255. blue:118/255. alpha:1];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    else if (indexPath.row == 1)
    {
        NSNumber *day = pool.rotationDay;
        NSString *dayString;
        switch ([day intValue])
        {
            case 0:
                dayString = @"Every Sunday"; break;
            case 1:
                dayString = @"Every Monday"; break;
            case 2:
                dayString = @"Every Tuesday"; break;
            case 3:
                dayString = @"Every Wednesday"; break;
            case 4:
                dayString = @"Every Thursday"; break;
            case 5:
                dayString = @"Every Friday"; break;
            case 6:
                dayString = @"Every Saturday"; break;
            default:
                break;
        }
        
        cellText = [cellText stringByAppendingString:dayString];
        
        if ([pool.rotationMethod isEqualToString:@"day"])
        {
            cell.textLabel.textColor = [UIColor colorWithRed:25/255. green:78/255. blue:112/255. alpha:1];
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            self.selectedMethodIndexPath = indexPath;
        }
        else
        {
            cell.textLabel.textColor = [UIColor colorWithRed:118/255. green:118/255. blue:118/255. alpha:1];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    cell.textLabel.text = cellText;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(19.0, 4.25, 320.0, 46.0)];
    UILabel *label = [[UILabel alloc] initWithFrame:header.frame];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor darkGrayColor];
    label.shadowColor = [UIColor whiteColor];
    label.shadowOffset = CGSizeMake(0, 1);
    label.font = [UIFont fontWithName:@"Heiti TC" size:19.0];
    
    label.text = @"Switch to a new driver...";
    
    
    [header addSubview:label];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 46.0;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
//    label.text = @"It was a very long book with many lines...";
//    // Colors and font
//    label.backgroundColor = [UIColor clearColor];
//    label.font = [UIFont systemFontOfSize:13];
//    label.shadowColor = [UIColor colorWithWhite:0.8 alpha:0.8];
//    label.textColor = [UIColor blackColor];
//    // Automatic word wrap
//    label.lineBreakMode = UILineBreakModeWordWrap;
//    label.textAlignment = UITextAlignmentCenter;
//    label.numberOfLines = 0;
//    // Autosize
//    [label sizeToFit];
//    // Add the UILabel to the tableview
//    self.tableView.tableFooterView = label;
//}

#pragma mark - Table view delegate source

// ------------------------------------------------------
// Change the rotation method when a new row is selected
// ------------------------------------------------------
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        pool.rotationMethod = @"length";
    }
    
    else if (indexPath.row == 1)
    {
        pool.rotationMethod = @"day";
    }
    
    [tableView reloadData];
    [picker reloadAllComponents];
    
    if ([pool.rotationMethod isEqualToString:@"length"])
    {
        [picker selectRow:[pool.rotationLength intValue] - 1 inComponent:0 animated:NO];
    }
    else if ([pool.rotationMethod isEqualToString:@"day"])
    {
        [picker selectRow:[pool.rotationDay intValue] inComponent:0 animated:NO];
    }
}

#pragma mark Picker Data Source Methods

// ------------------------------------------------------
// Add one component for rotation day / length
// ------------------------------------------------------
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// ------------------------------------------------------
// Create picker rows for every day of the week / 7 days
// ------------------------------------------------------
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	return 7;
}

#pragma mark -
#pragma mark Picker Delegate Methods

// ------------------------------------------------------
// Create picker rows for every day of the week / 7 days
// ------------------------------------------------------
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	if ([pool.rotationMethod isEqualToString:@"length"])
    {
		NSArray *lengths = [NSArray arrayWithObjects:@"Every day",
                            @"Every 2 days",
                            @"Every 3 days",
                            @"Every 4 days",
                            @"Every 5 days",
                            @"Every 6 days",
                            @"Every 7 days", nil];
        return [lengths objectAtIndex:row];
    }
    
    else /* [pool.rotationMethod isEqualToString:@"day"] */
    {
        NSArray *days = [NSArray arrayWithObjects:@"Sunday",
                         @"Monday",
                         @"Tuesday",
                         @"Wednesday",
                         @"Thursday",
                         @"Friday",
                         @"Saturday", nil];
        return [days objectAtIndex:row];
    }
}

// ------------------------------------------------------
// Update the pool object and the server with the new data
// ------------------------------------------------------
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if ([pool.rotationMethod isEqualToString:@"length"])
    {
        pool.rotationLength = [NSNumber numberWithInt:row + 1];
    }
    
    else if ([pool.rotationMethod isEqualToString:@"day"])
    {
        pool.rotationDay = [NSNumber numberWithInt:row];
    }
    
    [table reloadData];
}

@end
