//
//  CarmaPoolRotationSettingsViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/15/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmaPool.h"

@protocol CarmaPoolRotationSettingsViewControllerDelegate;

@interface CarmaPoolRotationSettingsViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource>
{
    UITableView *table;
    UIPickerView *picker;
    NSIndexPath *selectedMethodIndexPath;
    CarmaPool *pool;
    
    NSString *oldMethod;
    NSNumber *oldLength;
    NSNumber *oldDay;
    
    id<CarmaPoolRotationSettingsViewControllerDelegate> delegate;
}

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UIPickerView *picker;
@property (strong, nonatomic) NSIndexPath *selectedMethodIndexPath;
@property (strong, nonatomic) CarmaPool *pool;

@property (strong, nonatomic) NSString *oldMethod;
@property (strong, nonatomic) NSNumber *oldLength;
@property (strong, nonatomic) NSNumber *oldDay;

@property (strong, nonatomic) id<CarmaPoolRotationSettingsViewControllerDelegate> delegate;

@end

@protocol CarmaPoolRotationSettingsViewControllerDelegate <NSObject>
        
- (void)rotationSettingsDidChangeForPool:(CarmaPool *)pool;

@end
