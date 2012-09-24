//
//  CarmaProfilePhotoViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/18/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaProfilePhotoViewController.h"

@interface CarmaProfilePhotoViewController ()

@end

@implementation CarmaProfilePhotoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Add sign in table        
    int tableOffset = 20;   
    
    CGRect tableFrame = CGRectMake(tableOffset,
                                   0,
                                   self.view.frame.size.width - (tableOffset * 2),
                                   self.view.frame.size.height);
    
    UITableView *photoTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    photoTable.backgroundColor = [UIColor clearColor];
    photoTable.delegate = self;
    photoTable.dataSource = self;
    [self.view addSubview:photoTable];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

@end
