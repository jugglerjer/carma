//
//  CarmaSignInViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/3/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LLDataDownloader.h"

@interface CarmaSignInViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, LLDataDownloaderDelegate> {
    
    UITextField *usernameField;
    UITextField *passwordField;
    UIActivityIndicatorView *swirl;
    
}

@property (strong, nonatomic) UITextField *usernameField;
@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UIActivityIndicatorView *swirl;

@end
