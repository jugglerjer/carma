//
//  CarmaCalendarDayRolesViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 6/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaCalendarDayRolesViewController.h"
#import "CarmaDriver.h"
#import "CarmaCalendarDayRoleCell.h"

@interface CarmaCalendarDayRolesViewController ()

@end

@implementation CarmaCalendarDayRolesViewController

@synthesize day;
@synthesize users;

- (id)initWithStyle:(UITableViewStyle)style andDay:(CarmaDay *)newDay
{
    self = [super initWithStyle:style];
    if (self) {
        
        // Make background transparent
        self.view.backgroundColor = [UIColor clearColor];
        
        // Put all the users into a single array
        NSMutableArray *usersTemp = [NSMutableArray arrayWithCapacity:[newDay.passengers count] + [newDay.inactives count] + 1];
        
        if (newDay.driver != nil) {
            newDay.driver.position = @"driver";
            [usersTemp addObject:newDay.driver];
        }
        
        for (CarmaDriver *user in newDay.passengers) {
            user.position = @"passenger";
            [usersTemp addObject:user];
        }
        
        for (CarmaDriver *user in newDay.inactives) {
            user.position = @"inactive";
            [usersTemp addObject:user];
        }
        
        self.users = usersTemp;
        self.day = newDay;
        
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
    return [users count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
//    }
    
    CarmaDriver *user = [users objectAtIndex:indexPath.row];
    CarmaCalendarDayRoleCell *cell = [[CarmaCalendarDayRoleCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell" andUser:user];
    cell.textLabel.text = user.firstName;
    cell.detailTextLabel.text = user.position;
    cell.backgroundView.backgroundColor = [UIColor whiteColor];
    
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
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
