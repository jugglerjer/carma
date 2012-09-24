//
//  CarmaDriver.m
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaDriver.h"
#import "SBJSON.h"

@implementation CarmaDriver

@synthesize uID;
@synthesize firstName;
@synthesize lastName;
@synthesize imageURL;
@synthesize image;
@synthesize position;

// Address variables
@synthesize originStreet;
@synthesize originCity;
@synthesize originState;
@synthesize originZip;
@synthesize originLatitude;
@synthesize originLongitude;

@synthesize destinationStreet;
@synthesize destinationCity;
@synthesize destinationState;
@synthesize destinationZip;
@synthesize destinationLatitude;
@synthesize destinationLongitude;

// Push Notifications
@synthesize deviceToken;


// ---------------------------------------------------------
// Return a CarmaDriver object
// configured from the passed in dictionary
// which was returned from the carma.io server
// ---------------------------------------------------------
- (id)initWithDictionary:(NSDictionary *)dict {
    
    if (self = [super init]) {
        self.uID = [dict objectForKey:@"id"];
        self.firstName = [dict objectForKey:@"firstName"];
        self.lastName = [dict objectForKey:@"lastName"];
        self.imageURL = [dict objectForKey:@"imageURL"];
        
        // Assign address variables
        self.originStreet = [dict objectForKey:@"originStreet"];
        self.originCity = [dict objectForKey:@"originCity"];
        self.originState = [dict objectForKey:@"originState"];
        self.originZip = [dict objectForKey:@"originZip"];
        self.originLatitude = [[dict objectForKey:@"originLatitude"] doubleValue];
        self.originLongitude = [[dict objectForKey:@"originLongitude"] doubleValue];
        
        self.destinationStreet = [dict objectForKey:@"destinationStreet"];
        self.destinationCity = [dict objectForKey:@"destinationCity"];
        self.destinationState = [dict objectForKey:@"destinationState"];
        self.destinationZip = [dict objectForKey:@"destinationZip"];
        self.destinationLatitude = [[dict objectForKey:@"destinationLatitude"] doubleValue];
        self.destinationLongitude = [[dict objectForKey:@"destinationLongitude"] doubleValue];
        
        // Push Notifications
        //NSLog(@"%@", dict);
        self.deviceToken = [dict objectForKey:@"deviceToken"];
    }   
    
    return self;
    
}

// ---------------------------------------------------------
// Return a CarmaDriver object
// configured from the passed in dictionary
// which was returned from the carma.io server
// ---------------------------------------------------------
- (CarmaDriver *)driverWithDictionary:(NSDictionary *)dict {
    
    self.uID = [dict objectForKey:@"id"];
    self.firstName = [dict objectForKey:@"firstName"];
    self.lastName = [dict objectForKey:@"lastName"];
    self.imageURL = [dict objectForKey:@"imageURL"];
    
    // Assign address variables
    self.originStreet = [dict objectForKey:@"originStreet"];
    self.originCity = [dict objectForKey:@"originCity"];
    self.originState = [dict objectForKey:@"originState"];
    self.originZip = [dict objectForKey:@"originZip"];
    self.originLatitude = [[dict objectForKey:@"originLatitude"] doubleValue];
    self.originLongitude = [[dict objectForKey:@"originLongitude"] doubleValue];
    
    self.destinationStreet = [dict objectForKey:@"destinationStreet"];
    self.destinationCity = [dict objectForKey:@"destinationCity"];
    self.destinationState = [dict objectForKey:@"destinationnState"];
    self.destinationZip = [dict objectForKey:@"destinationZip"];
    self.destinationLatitude = [[dict objectForKey:@"destinationLatitude"] doubleValue];
    self.destinationLongitude = [[dict objectForKey:@"destinationLongitude"] doubleValue];
    
    return self;
    
}

- (void)updateDriverWithAttributes:(NSDictionary *)attributes
{
    LLDataDownloader *uploader = [[LLDataDownloader alloc] init];
    uploader.delegate = self;
    NSString *url = [NSString stringWithFormat:@"http://carma.io/scripts/server/carma_update_user.php"];
    NSMutableArray *paramArray = [NSMutableArray arrayWithCapacity:[attributes count]];
    
    for (NSString *key in attributes)
    {
        NSString *param = [NSString stringWithFormat:@"%@=%@", key, [attributes objectForKey:key]];
        [paramArray addObject:param];
    }
    
    NSString *params = [paramArray componentsJoinedByString:@"&"];
    //NSLog(@"%@", params);
    
    if (![uploader postDataWithURL:url andParams:params]) {NSLog(@"Couldn't download %@", url);}
}

- (void)dataHasFinishedDownloadingForDownloader:(LLDataDownloader *)downloader withResult:(BOOL)result andData:(NSData *)data
{
    NSString* responseString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    
    SBJSON *jsonParser = [SBJSON new];
    NSDictionary *responseData = [jsonParser objectWithString:responseString];
    
    if (![responseData objectForKey:@"status"])
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Pardon us..."
                                                        message:@"We seem to be having some trouble updating your profile right now. Mind trying again in just a bit?"
                                                       delegate:nil
                                              cancelButtonTitle:@"No problem"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        NSDictionary *driverData = [responseData objectForKey:@"data"];
        if (![[driverData objectForKey:@"id"] isEqual:[NSNull null]])
        {
            // Save the user's data in our data model
            CarmaDriver *driver = [[CarmaDriver alloc] initWithDictionary:driverData];
            self = driver;
            
            // Tell the system that we've successfully logged in
            [[NSNotificationCenter defaultCenter] postNotificationName:@"CarmaUserLoggedInNotification" object:self];
        }

    }
}

@end
