//
//  CarmaPool.m
//  Carma
//
//  Created by Jeremy Lubin on 7/7/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaPool.h"
#import "CarmaDriver.h"

@implementation CarmaPool

@synthesize poolID;
@synthesize rotationMethod;
@synthesize rotationDay;
@synthesize rotationLength;
@synthesize drivers;

// ---------------------------------------------------------
// Return a CarmaPool object
// configured from the passed in dictionary
// which was returned from the carma.io server
// ---------------------------------------------------------
- (id)initWithDictionary:(NSDictionary *)dict
{
    if (self = [super init])
    {
        self.poolID = [dict objectForKey:@"id"];
        self.rotationMethod = [dict objectForKey:@"rotationMethod"];
        self.rotationDay = (NSNumber *)[dict objectForKey:@"rotationDay"];
        self.rotationLength = (NSNumber *)[dict objectForKey:@"rotationLength"];
        
        NSMutableDictionary *driversTemp = [NSMutableDictionary dictionaryWithCapacity:4];
        for (NSDictionary *driverData in [dict objectForKey:@"drivers"])
        {
            CarmaDriver *driver = [[CarmaDriver alloc] initWithDictionary:driverData];
            [driversTemp setObject:driver forKey:driver.uID];
        }
        self.drivers = driversTemp;
    }  
    return self;
}

@end
