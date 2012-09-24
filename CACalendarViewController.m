//
//  CACalendarViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CACalendarViewController.h"
#import "CarmaCalendarDayCellCell.h"
#import "CarmaDriver.h"
#import "JSON.h"

@implementation CACalendarViewController

@synthesize days;
@synthesize drivers;
@synthesize todayIndex;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Set the view's title
    self.navigationItem.title = @"Schedule";
  
    // Download calendar days
    int userID = 1;
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_calendar.php?id=%d", userID];
    
    LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
    downloader.delegate = self;
    if (![downloader getDataWithURL:url]) {NSLog(@"Couldn't download %@", url);}
  
}

// Calendar has finished downloading
- (void)dataHasFinishedDownloadingWithResult:(BOOL)result andData:(NSData *)data {
    
    // Parse the JSON data returned
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	SBJSON *jsonParser = [SBJSON new];	
	id object = [jsonParser objectWithString:responseString];
    
    // Put all the drivers into an array as CarmaDriver objects
    NSMutableDictionary *driversTemp = [NSMutableDictionary dictionaryWithCapacity:5];
    
    for (NSDictionary *dict in object) {
        NSDictionary *driverTemp = [dict objectForKey:@"driver"];
        
        if (![driverTemp isEqual:[NSNull null]] /*&& ![driversTemp objectForKey:[[dict objectForKey:@"driver"] objectForKey:@"id"]]*/) {
            CarmaDriver *driver = [[CarmaDriver alloc] init];
            [driver driverWithDictionary:driverTemp];
            [driversTemp setObject:driver forKey:driver.uID];
        }
    }
    
    self.drivers = driversTemp;
    self.days = object;
    
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:todayIndex atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
  
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [days count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    CarmaCalendarDayCellCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CarmaCalendarDayCellCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    NSDictionary *day = [days objectAtIndex:indexPath.row];
    NSDictionary *driverDict = [day objectForKey:@"driver"];
    
    // Convert string date into an NSDate
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    NSDate *dateFormatted = [dateFormat dateFromString:[day objectForKey:@"date"]];
    
    // Check whether the date is today's date
    BOOL isToday = [[dateFormat stringFromDate:dateFormatted] isEqualToString:[dateFormat stringFromDate:[NSDate date]]];
    if (isToday) {self.todayIndex = indexPath;}

    if (![driverDict isEqual:[NSNull null]]) {
        [cell configureCellWithDate:dateFormatted
                          andDriver:[drivers objectForKey:[driverDict objectForKey:@"id"]]];
    } else {
        [cell configureCellWithDate:dateFormatted
                          andDriver:nil];
    }
    
    
    // Load the profile images for each driver
    
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor redColor];
    
    if ([indexPath isEqual:todayIndex]) {
       cell.backgroundColor = [UIColor colorWithRed:211/255. green:231/255. blue:240/255. alpha:1];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}

@end
