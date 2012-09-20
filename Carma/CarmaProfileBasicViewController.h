//
//  CarmaProfileBasicViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"

@protocol CarmaProfileBasicViewControllerDelegate;

@interface CarmaProfileBasicViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LLDataDownloaderDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
{
    UITableView *table;
    UITextField *firstNameField;
    UITextField *lastNameField;
    UITextField *usernameField;
    UITextField *passwordField;
    NSData *imageData;
    id<CarmaProfileBasicViewControllerDelegate> delegate;
    
}

@property (strong, nonatomic) UITableView *table;
@property (strong, nonatomic) UITextField *firstNameField;
@property (strong, nonatomic) UITextField *lastNameField;
@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) id<CarmaProfileBasicViewControllerDelegate> delegate;

@end

@protocol CarmaProfileBasicViewControllerDelegate <NSObject>

- (void)basicProfileCreationSucceededWithDictionary:(NSDictionary *)dict;

@end
