//
//  CarmaCalendarViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 5/21/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaCalendarViewController.h"
#import "CarmaDriver.h"
#import "CarmaDay.h"
#import "CarmaCalendarDayView.h"
#import "CarmaCalendarDayCell.h"
#import "CarmaCalendarDayDetailViewController.h"
#import "SBJSON.h"
#import "LLDataDownloader.h"

static CGFloat kCalendarDayCellRowHeight = 80;
static NSString *const UserImageURLPrefix = @"http://carma.io/styles/images/";

//static CGFloat kCalendarDayCellWidth = 64;
//static CGFloat kCalendarDayCellHeight = 130;
//static CGFloat kCalendarDayCellSpace = 1;
//
//static CGFloat kMapScrollViewPagination = 130;
//static CGFloat kMapScrollViewGripSpace = 44;

@implementation CarmaCalendarViewController

@synthesize days;
@synthesize drivers;
@synthesize todayButton;
@synthesize mapPanel;
@synthesize todayIndex;
@synthesize userID;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {

        self.tableView.rowHeight = kCalendarDayCellRowHeight;
        //self.tableView.separatorColor = [UIColor whiteColor];
        
        // Set the view's title
        self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"carma_title.png"]];
        self.title = @"carma";
        

        // Add "go to today" button
        UIImage *buttonImageNormal = [UIImage imageNamed:@"nav_button.png"];
        UIImage *stretchableButtonImageNormal = [buttonImageNormal stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        
        UIImage *buttonImagePressed = [UIImage imageNamed:@"nav_button_pressed.png"];
        UIImage *stretchableButtonImagePressed = [buttonImagePressed stretchableImageWithLeftCapWidth:8 topCapHeight:8];
        
        UIButton *todayButtonView = [UIButton buttonWithType:UIButtonTypeCustom];
        todayButtonView.frame = CGRectMake(0, 0, 41, 30);
        [todayButtonView setBackgroundImage:stretchableButtonImageNormal forState:UIControlStateNormal];
        [todayButtonView setBackgroundImage:stretchableButtonImagePressed forState:UIControlStateHighlighted]; 
        [todayButtonView setImage:[UIImage imageNamed:@"today_icon.png"] forState:UIControlStateNormal];
        [todayButtonView addTarget:self action:@selector(scrollToToday) forControlEvents:UIControlEventTouchUpInside];
        todayButtonView.adjustsImageWhenHighlighted = NO;
        UIBarButtonItem *today = [[UIBarButtonItem alloc] initWithCustomView:todayButtonView];
        today.enabled = NO;
        self.todayButton = today;
        self.navigationItem.rightBarButtonItem = todayButton;
        
        // Register for notifications when the user signs in
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDidSignIn:) name:@"CarmaUserLoggedInNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadCalendar) name:@"CarmaPoolSettingsChangedNotification" object:nil];
    }
    
    return self;
}

- (void)reloadCalendar
{
    // Download calendar days
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_calendar.php"];
    LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
    downloader.delegate = self;
    downloader.identifier = -1;
    if (![downloader getDataWithURL:url]) {NSLog(@"Couldn't download %@", url);}
}

- (void)userDidSignIn:(NSNotification *)notification
{
    self.userID = [(CarmaDriver *)[notification object] uID];
    [self reloadCalendar];
}

// Calendar has finished downloading
- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    
    if (downloader.identifier == -1) {
        // Parse the JSON data returned
        NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        //NSLog(@"%@", responseString);
        SBJSON *jsonParser = [SBJSON new];	
        NSMutableArray *daysData = [jsonParser objectWithString:responseString];
        
        // Put the days into day objects
        int dayCount = 0;
        self.days = [NSMutableArray arrayWithCapacity:[daysData count]];
        NSMutableDictionary *driversTemp = [NSMutableDictionary dictionaryWithCapacity:5];
        for (NSDictionary *day in daysData) {
            
            // Create a new CarmaDay object
            CarmaDay *newDay = [[CarmaDay alloc] initWithDictionary:day];
            [days addObject:newDay];
            
            // Check whether the date is today's date
            if ([newDay isToday]) {self.todayIndex = [NSIndexPath indexPathForRow:dayCount inSection:0];}
            dayCount++;
            
            // Add the driver to the drivers array if not already added
            if (newDay.driver) {
                [driversTemp setObject:newDay.driver forKey:newDay.driver.uID];
                
                // Begin downloading driver's photo
//                LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
//                downloader.delegate = self;
//                downloader.identifier = [newDay.driver.uID intValue];
//                NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, newDay.driver.imageURL];
//                if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
            }
        }
        
        self.drivers = driversTemp;
        [self.tableView reloadData]; 
        
        if (todayIndex) {
            todayButton.enabled = YES;
            [self scrollToToday];
        }  

    } else {
//        CarmaDriver *driver = [drivers objectForKey:[[NSNumber numberWithInt:downloader.identifier] stringValue]];
//        driver.image = [UIImage imageWithData:data];
//        [drivers setObject:driver forKey:driver.uID];
    }
        
}

- (void)scrollToToday {
    
    [self.tableView scrollToRowAtIndexPath:todayIndex atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    CarmaCalendarDayCell *cell/* = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]*/;
    //if (cell == nil) {
        cell = [[CarmaCalendarDayCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    //}
    
    cell.userID = userID;
    cell.masterCalendar = self;
    
    CarmaDay *day = [days objectAtIndex:indexPath.row];
    CarmaDriver *driver = [drivers objectForKey:day.driver.uID];
    
    if (![driver isEqual:[NSNull null]]) {
        [cell configureCellWithDate:day.date
                          andDriver:driver];
    } else {
        [cell configureCellWithDate:day.date
                          andDriver:nil];
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    CarmaCalendarDayDetailViewController *detailViewController = [[CarmaCalendarDayDetailViewController alloc] initWithDay:[days objectAtIndex:indexPath.row]];
    detailViewController.title = @"Date";
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    
}

@end
