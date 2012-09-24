//
//  CarmaProfileTimeViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 8/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLClockView.h"

@interface CarmaProfileTimeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    UIDatePicker *datePicker;
    LLClockView *earlyClock;
    UITableView *timeTable;
}

@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) UITableView *timeTable;
@property (strong, nonatomic) LLClockView *earlyClock;

@end
