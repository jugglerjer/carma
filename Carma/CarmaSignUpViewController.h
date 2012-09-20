//
//  CarmaSignUpViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CarmaProfileBasicViewController.h"
#import "CarmaProfileLocationViewController.h"
#import "LLDataDownloader.h"

@interface CarmaSignUpViewController : UIViewController <UIScrollViewDelegate, CarmaProfileBasicViewControllerDelegate, CarmaProfileLocationViewControllerDelegate, LLDataDownloaderDelegate>
{
    UIToolbar *navBar;
    UIBarButtonItem *leftButton;
    UIBarButtonItem *rightButton;
    UIScrollView *scrollView;
    NSMutableArray *viewControllers;
    NSMutableDictionary *attributes;
}

@property (strong, nonatomic) UIToolbar *navBar;
@property (strong, nonatomic) UIBarButtonItem *leftButton;
@property (strong, nonatomic) UIBarButtonItem *rightButton;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (strong, nonatomic) NSMutableArray *viewControllers;
@property (strong, nonatomic) NSMutableDictionary *attributes;

@end
