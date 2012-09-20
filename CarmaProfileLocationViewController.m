//
//  CarmaProfileLocationnViewController.m
//  Carma
//
//  Created by Jeremy Lubin on 7/4/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaProfileLocationViewController.h"
#import "LocationAnnotation.h"
#import <AddressBook/AddressBook.h>
#import <QuartzCore/QuartzCore.h>

#define kAddressSection     0
#define kMapSection         1
#define kRadiusSection      2

#define kStreetRow          0
#define kCityRow            1
#define kStateRow           2
#define kZipRow             3

#define kMapRow             0
#define kRadiusRow          1

@interface CarmaProfileLocationViewController ()

@end

@implementation CarmaProfileLocationViewController

@synthesize signupTable;
@synthesize streetField;
@synthesize cityField;
@synthesize stateField;
@synthesize zipField;
@synthesize coordinates;
@synthesize mapView;
@synthesize attributes; // Allows the edit view to pass in existing values for the address fields
@synthesize locationType;
@synthesize delegate;

// ------------------------------------------------------
// Validate address
// ------------------------------------------------------
- (void)validateAddress
{
    BOOL error = NO;
    NSString *errorMsg = @"You forgot your: \n\n";
    
    if ([streetField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"Street\n"];
        error = YES;
    }
    
    if ([cityField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"City\n"];
        error = YES;
    }
    
    if ([stateField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"State\n"];
        error = YES;
    }
    
    if ([zipField.text isEqualToString:@""]) {
        errorMsg = [errorMsg stringByAppendingString:@"Zip code\n"];
        error = YES;
    }
    
    errorMsg = [errorMsg stringByAppendingString:@"\nMind trying again?"];
    
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Whoops"
                                                        message:errorMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure!"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    else
    {
        // Move to next screen and store values        
        if (locationType == CarmaProfileLocationTypeOrigin)
        {
            NSDictionary *attributesNew = [NSDictionary dictionaryWithObjectsAndKeys:streetField.text, @"originStreet",
                                               cityField.text, @"originCity",
                                               stateField.text, @"originState",
                                               zipField.text, @"originZip",
                                               [[NSNumber numberWithDouble:coordinates.latitude] stringValue], @"originLatitude",
                                               [[NSNumber numberWithDouble:coordinates.longitude] stringValue], @"originLongitude", nil];
            if ([delegate respondsToSelector:@selector(locationProfileCreationSucceededWithDictionary:)]) {
                [delegate locationProfileCreationSucceededWithDictionary:attributesNew];
            }
        }
        
        else if (locationType == CarmaProfileLocationTypeDestination)
        {
            NSDictionary *attributesNew = [NSDictionary dictionaryWithObjectsAndKeys:streetField.text, @"destinationStreet",
                                               cityField.text, @"destinationCity",
                                               stateField.text, @"destinationState",
                                               zipField.text, @"destinationZip" ,
                                               [[NSNumber numberWithDouble:coordinates.latitude] stringValue], @"destinationLatitude",
                                               [[NSNumber numberWithDouble:coordinates.longitude] stringValue], @"destinationLongitude", nil];
            if ([delegate respondsToSelector:@selector(locationProfileCreationSucceededWithDictionary:)]) {
                [delegate locationProfileCreationSucceededWithDictionary:attributesNew];
            }
        }
        
        
    }
}

- (void)updateMap
{
    NSDictionary *locationDictionary = [NSDictionary dictionaryWithObjectsAndKeys:streetField.text, kABPersonAddressStreetKey,
                                                                    cityField.text, kABPersonAddressCityKey,
                                                                    stateField.text, kABPersonAddressStateKey,
                                                                    zipField.text, kABPersonAddressZIPKey, nil];
    
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressDictionary:locationDictionary
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     CLPlacemark *mark = [placemarks objectAtIndex:0];
                     [self addAnnotationWithPlacemark:mark];
                 }];
}

- (void)addAnnotationWithPlacemark:(CLPlacemark *)placemark
{
    //NSString *address = [NSString stringWithFormat:@"%@, %@, %@ %@", streetField.text, cityField.text, stateField.text, zipField.text];
    
    if (placemark != nil)
    {
        self.coordinates = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        
        LocationAnnotation *annotation = [[LocationAnnotation alloc] init];
        annotation.coordinate = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude, placemark.location.coordinate.longitude);
        //annotation.title = @"Home";
        //annotation.subtitle = address;
        [mapView addAnnotation:annotation];
        
        MKMapPoint point = MKMapPointForCoordinate(coordinates);
        MKMapSize size = MKMapSizeMake(1000, 1000);
        
        MKMapRect rect;
        rect.origin = point;
        rect.size = size;
        
        [self.mapView setVisibleMapRect:rect animated:YES];
        mapView.centerCoordinate = coordinates;
    }
    
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"We can't find you"
                                                        message:@"Any chance you can provide a more specific address?"
                                                       delegate:nil
                                              cancelButtonTitle:@"Sure!"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

// ------------------------------------------------------
// Load the subviews
// ------------------------------------------------------
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add sign in table        
    int tableOffset = 20;   
    
    CGRect tableFrame = CGRectMake(tableOffset,
                                   0,
                                   self.view.frame.size.width - (tableOffset * 2),
                                   self.view.frame.size.height);
    
    self.signupTable = [[UITableView alloc] initWithFrame:tableFrame style:UITableViewStyleGrouped];
    signupTable.backgroundColor = [UIColor clearColor];
    signupTable.delegate = self;
    signupTable.dataSource = self;
    [self.view addSubview:signupTable];
    [self performSelector:@selector(updateMap) withObject:nil afterDelay:0];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == kAddressSection) return 4;
    else return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CGRect textFieldFrame = CGRectMake(20,
                                       12,
                                       cell.frame.size.width - 80,
                                       cell.frame.size.height - 20);
    
    if (indexPath.section == kAddressSection)
    {
        if (indexPath.row == kStreetRow)
        {
            if (self.streetField == nil)
            {
                self.streetField = [[UITextField alloc] initWithFrame:textFieldFrame];
                streetField.text = (attributes && ![[attributes objectForKey:@"street"] isEqual:[NSNull null]]) ? [attributes objectForKey:@"street"] : @"";
                //streetField.text = @"";
                streetField.placeholder = @"Street";
                streetField.returnKeyType = UIReturnKeyNext;
                streetField.clearButtonMode = UITextFieldViewModeWhileEditing;
                streetField.delegate = self;
                
                [cell addSubview:streetField];
            }
        }
        
        else if (indexPath.row == kCityRow)
        {
            if (self.cityField == nil)
            {
                self.cityField = [[UITextField alloc] initWithFrame:textFieldFrame];
                cityField.text = (attributes && ![[attributes objectForKey:@"city"] isEqual:[NSNull null]]) ? [attributes objectForKey:@"city"] : @"";
                //cityField.text = @"";
                cityField.placeholder = @"City";
                cityField.returnKeyType = UIReturnKeyNext;
                cityField.clearButtonMode = UITextFieldViewModeWhileEditing;
                cityField.delegate = self;
                
                [cell addSubview:cityField];
            }
        }
        
        else if (indexPath.row == kStateRow)
        {
            if (self.stateField == nil)
            {
                self.stateField = [[UITextField alloc] initWithFrame:textFieldFrame];
                stateField.text = (attributes && ![[attributes objectForKey:@"state"] isEqual:[NSNull null]]) ? [attributes objectForKey:@"state"] : @"";
                //stateField.text = @"";
                stateField.placeholder = @"State";
                stateField.returnKeyType = UIReturnKeyNext;
                stateField.clearButtonMode = UITextFieldViewModeWhileEditing;
                stateField.delegate = self;
                
                [cell addSubview:stateField];
            }
        }
        
        else if (indexPath.row == kZipRow)
        {
            if (self.zipField == nil)
            {
                self.zipField = [[UITextField alloc] initWithFrame:textFieldFrame];
                zipField.text = (attributes && ![[attributes objectForKey:@"zip"] isEqual:[NSNull null]]) ? [attributes objectForKey:@"zip"] : @"";
                //zipField.text = @"";
                zipField.placeholder = @"Zip code";
                zipField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
                zipField.returnKeyType = UIReturnKeyDone;
                zipField.clearButtonMode = UITextFieldViewModeWhileEditing;
                zipField.delegate = self;
                
                [cell addSubview:zipField];
            }
        }
    }
    
    else if (indexPath.section == kMapSection)
    {
        if (indexPath.row == kMapRow)
        {
            // Add map view
            if (self.mapView == nil)
            {
                int mapOffset = 10;
                self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(cell.frame.origin.x + mapOffset,
                                                                           1,
                                                                           cell.frame.size.width - (mapOffset * 2) - 40,
                                                                           self.view.frame.size.height - (tableView.rowHeight * 4) - 45 - 1)];
                mapView.delegate = self;
                mapView.layer.masksToBounds = YES;
                mapView.layer.cornerRadius = 9.0f;
                mapView.showsUserLocation = YES;
                cell.clipsToBounds = YES;
                [cell addSubview:mapView];
                
            }
        }
        
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == kMapSection && indexPath.row == kMapRow)
    {
        return self.view.frame.size.height - (tableView.rowHeight * 4) - 45;
    }
    
    else return 44;
}

#pragma mark -
#pragma mark Text Field Methods


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField == self.streetField)
    {
        [cityField becomeFirstResponder];
    }
    
    else if (textField == self.cityField)
    {
        [stateField becomeFirstResponder];
    }
    
    else if (textField == self.stateField)
    {
        [zipField becomeFirstResponder];
    }
    
    else if (textField == self.zipField)
    {
        [zipField resignFirstResponder];
    }
    
    [self updateMap];
    return YES;
    
}

// ------------------------------------------------------
// Rounds certain corners of views
// ------------------------------------------------------
static inline UIImage* MTDContextCreateRoundedMask( CGRect rect, CGFloat radius_tl, CGFloat radius_tr, CGFloat radius_bl, CGFloat radius_br ) {  
    
    CGContextRef context;
    CGColorSpaceRef colorSpace;
    
    colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a bitmap graphics context the size of the image
    context = CGBitmapContextCreate( NULL, rect.size.width, rect.size.height, 8, 0, colorSpace, kCGImageAlphaPremultipliedLast );
    
    // free the rgb colorspace
    CGColorSpaceRelease(colorSpace);    
    
    if ( context == NULL ) {
        return NULL;
    }
    
    // cerate mask
    
    CGFloat minx = CGRectGetMinX( rect ), midx = CGRectGetMidX( rect ), maxx = CGRectGetMaxX( rect );
    CGFloat miny = CGRectGetMinY( rect ), midy = CGRectGetMidY( rect ), maxy = CGRectGetMaxY( rect );
    
    CGContextBeginPath( context );
    CGContextSetGrayFillColor( context, 1.0, 0.0 );
    CGContextAddRect( context, rect );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    CGContextSetGrayFillColor( context, 1.0, 1.0 );
    CGContextBeginPath( context );
    CGContextMoveToPoint( context, minx, midy );
    CGContextAddArcToPoint( context, minx, miny, midx, miny, radius_bl );
    CGContextAddArcToPoint( context, maxx, miny, maxx, midy, radius_br );
    CGContextAddArcToPoint( context, maxx, maxy, midx, maxy, radius_tr );
    CGContextAddArcToPoint( context, minx, maxy, minx, midy, radius_tl );
    CGContextClosePath( context );
    CGContextDrawPath( context, kCGPathFill );
    
    // Create CGImageRef of the main view bitmap content, and then
    // release that bitmap context
    CGImageRef bitmapContext = CGBitmapContextCreateImage( context );
    CGContextRelease( context );
    
    // convert the finished resized image to a UIImage 
    UIImage *theImage = [UIImage imageWithCGImage:bitmapContext];
    // image is retained by the property setting above, so we can 
    // release the original
    CGImageRelease(bitmapContext);
    
    // return the image
    return theImage;
} 

@end
