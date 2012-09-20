//
//  CarmaProfileLocationViewController.h
//  Carma
//
//  Created by Jeremy Lubin on 7/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol CarmaProfileLocationViewControllerDelegate;

typedef enum
{
    CarmaProfileLocationTypeOrigin,
    CarmaProfileLocationTypeDestination
} CarmaProfileLocationType;

@interface CarmaProfileLocationViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, MKMapViewDelegate>
{
    UITableView *signupTable;
    UITextField *streetField;
    UITextField *cityField;
    UITextField *stateField;
    UITextField *zipField;
    CLLocationCoordinate2D coordinates;
    MKMapView *mapView;
    NSDictionary *attributes;
    CarmaProfileLocationType locationType;
    id<CarmaProfileLocationViewControllerDelegate> delegate;
}

@property (strong, nonatomic) UITableView *signupTable;
@property (strong, nonatomic) UITextField *streetField;
@property (strong, nonatomic) UITextField *cityField;
@property (strong, nonatomic) UITextField *stateField;
@property (strong, nonatomic) UITextField *zipField;
@property CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSDictionary *attributes;
@property CarmaProfileLocationType locationType;
@property (strong, nonatomic) id<CarmaProfileLocationViewControllerDelegate> delegate;

@end

@protocol CarmaProfileLocationViewControllerDelegate <NSObject>

- (void)locationProfileCreationSucceededWithDictionary:(NSDictionary *)dict;

@end
