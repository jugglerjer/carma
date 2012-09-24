//
//  CarmaProfileTimeViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 8/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaProfileTimeViewController.h"

@interface CarmaProfileTimeViewController ()

@end

@implementation CarmaProfileTimeViewController

@synthesize datePicker;
@synthesize timeTable;
@synthesize earlyClock;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.view.backgroundColor = [UIColor clearColor];
        
        // Add table view
        int tableOffset = 20;
        
        CGRect tableFrame = CGRectMake(tableOffset,
                                       0,
                                       self.view.frame.size.width - (tableOffset * 2),
                                       self.view.frame.size.height);
        self.timeTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
        timeTable.dataSource = self;
        timeTable.delegate = self;
        timeTable.backgroundColor = [UIColor clearColor];
        [self.view addSubview:timeTable];
        
        // Add date picker
        CGRect pickerFrame = CGRectMake(0, self.view.frame.size.height - 216 - 44, self.view.frame.size.width, 216);
        self.datePicker = [[UIDatePicker alloc] initWithFrame:pickerFrame];
        datePicker.datePickerMode = UIDatePickerModeTime;
        [datePicker addTarget:self action:@selector(updateClockTimeForDatePicker:) forControlEvents:UIControlEventValueChanged];
        [self.view addSubview:datePicker];
        
    }
    return self;
}

- (void)updateClockTimeForDatePicker:(UIDatePicker *)sender
{
    [earlyClock setClockWithTime:sender.date];
}

#pragma mark UITableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if (indexPath.row == 0)
    {
        // Add the early clock
        self.earlyClock = [[LLClockView alloc] initWithFrame:CGRectMake(10, 0, cell.frame.size.height, cell.frame.size.height) andTime:[NSDate date]];
        [cell addSubview:earlyClock];
    }
    
    
    return cell;
}

@end
