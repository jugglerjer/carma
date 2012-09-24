//
//  CarmaSearchViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaSearchViewController.h"
#import "CarmaUserViewController.h"
#import "AppDelegate.h"
#import "CarmaRootViewController.h"
#import "CarmaDriver.h"
#import "SBJSON.h"

static NSString* const UserIDKey = @"UserID";

@interface CarmaSearchViewController ()

@end

@implementation CarmaSearchViewController

@synthesize searchBar;
@synthesize searchTable;
@synthesize searchResults;
@synthesize latestSearch;
@synthesize selectedIndex;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        latestSearch = 0;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Add Search bar
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(self.view.frame.origin.x + 50,
                                                                           0,
                                                                           self.view.frame.size.width - 50,
                                                                           44)];
    searchBar.delegate = self;
    searchBar.backgroundImage = [UIImage imageNamed:@"nav_bar.png"];
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CarmaRootViewController *rootViewController = delegate.rootViewController;
    [rootViewController.navigationController.navigationBar addSubview:searchBar];
    
    // Add search results table
    searchTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.origin.x,
                                                                             0,
                                                                             self.view.frame.size.width,
                                                                             self.view.frame.size.height)
                                                            style:UITableViewStylePlain];
    searchTable.delegate = self;
    searchTable.dataSource = self;
    [self.view addSubview:searchTable];

}

- (void)viewWillDisappear:(BOOL)animated
{
    [searchBar resignFirstResponder];
    searchBar.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    searchBar.hidden = NO;
    [searchTable deselectRowAtIndexPath:selectedIndex animated:YES];
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
    return [searchResults count];
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
    
    UIView *greenBackground = [[UIView alloc] init];
    [greenBackground setBackgroundColor:[UIColor colorWithRed:197/255. green:243/255. blue:216/255. alpha:1]];
    cell.selectedBackgroundView = greenBackground;
    
    // Format text
    cell.textLabel.font = [UIFont fontWithName:@"Heiti TC" size:19.0];
    cell.textLabel.textColor = [UIColor colorWithRed:25/255. green:78/255. blue:112/255. alpha:1];
    cell.textLabel.highlightedTextColor = [UIColor colorWithRed:25/255. green:78/255. blue:112/255. alpha:1];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    CarmaDriver *driver = [searchResults objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", driver.firstName, driver.lastName];
    
    return cell;
}

// ------------------------------------------------------
// Shows the user's profile
// ------------------------------------------------------
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CarmaUserViewController *detailViewController = [[CarmaUserViewController alloc] init];
    detailViewController.user = [searchResults objectAtIndex:indexPath.row];
    detailViewController.title = [NSString stringWithFormat:@"%@ %@", detailViewController.user.firstName, detailViewController.user.lastName];
    self.selectedIndex = indexPath;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

#pragma mark - Search bar delegate methods
// ------------------------------------------------------
// Perform search using the search bar text
// ------------------------------------------------------
- (void)performSearch
{
    // Download calendar days
    latestSearch++;
    NSString *term = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_text_search.php?term=%@", term];
    LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
    downloader.delegate = self;
    downloader.identifier = latestSearch;
    if (![downloader getDataWithURL:url]) {NSLog(@"Couldn't download %@", url);}
}

// ------------------------------------------------------
// Parse the returned search data
// ------------------------------------------------------
- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    if (downloader.identifier == latestSearch)
    {
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        SBJSON *jsonParser = [SBJSON new];	
        NSArray *driversData = [jsonParser objectWithString:responseString];
        
        NSMutableArray *drivers = [NSMutableArray arrayWithCapacity:[driversData count]];
        for (NSDictionary *driverData in driversData)
        {
            CarmaDriver *driver = [[CarmaDriver alloc] initWithDictionary:driverData];
            NSString *userID = [[NSUserDefaults standardUserDefaults] objectForKey:UserIDKey];
            if (![userID isEqualToString:driver.uID]) {
                [drivers addObject:driver];
            }
        }
        
        self.searchResults = drivers;
        [searchTable reloadData];
    }
    
//    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"%@", responseString);
}

// ------------------------------------------------------
// Show the cancel button if searching is starting
// ------------------------------------------------------
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar
{
    [bar setShowsCancelButton:YES animated:YES];
    return YES;
}

// ------------------------------------------------------
// Show the cancel button if searching is starting
// ------------------------------------------------------
- (void)searchBarCancelButtonClicked:(UISearchBar *)bar
{
    [bar setShowsCancelButton:NO animated:YES];
    [bar resignFirstResponder];
}

// ------------------------------------------------------
// Refresh search term when text is changed
// ------------------------------------------------------
- (void)searchBar:(UISearchBar *)bar textDidChange:(NSString *)searchText
{
    [self performSearch];
}

// ------------------------------------------------------
// Resign first responder when  search button is pressed
// ------------------------------------------------------
- (void)searchBarSearchButtonClicked:(UISearchBar *)bar
{
    [bar resignFirstResponder];
}

@end
