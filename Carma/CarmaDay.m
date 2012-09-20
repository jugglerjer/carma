//
//  CarmaDay.m
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaDay.h"
#import "CarmaDriver.h"

@implementation CarmaDay

@synthesize date;
@synthesize driver;
@synthesize passengers;
@synthesize inactives;

- (id)initWithDictionary:dict {
    
    if (self = [super init]) {
        
        // Convert string date into an NSDate
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd"];
        NSDate *dateFormatted = [dateFormat dateFromString:[dict objectForKey:@"date"]];
        self.date = dateFormatted;
        
        // Add the day's driver to the day object
        NSDictionary *driverTemp = [dict objectForKey:@"driver"];
        if (![driverTemp isEqual:[NSNull null]]) {
            CarmaDriver *driverNew = [[CarmaDriver alloc] init];
            [driverNew driverWithDictionary:driverTemp];
            self.driver = driverNew;
        }
        
        // Add the day's passengers to the day object
        NSArray *passengersData = [dict objectForKey:@"passengers"];
        if (![passengersData isEqual:[NSNull null]]) {
            NSMutableArray *passengersTemp = [NSMutableArray arrayWithCapacity:[passengersData count]];
            
            if ([passengersData count] > 0) {
                for (NSDictionary *passenger in passengersData) {
                    
                    CarmaDriver *passengerNew = [[CarmaDriver alloc] init];
                    [passengerNew driverWithDictionary:passenger];
                    [passengersTemp addObject:passengerNew];
                    
                }
            }
            
            self.passengers = passengersTemp;
            
        }
       
        
        // Add the day's inactives to the day object
        NSArray *inactivesData = [dict objectForKey:@"inactives"];
        
        if (![inactivesData isEqual:[NSNull null]]) {
            NSMutableArray *inactivesTemp = [NSMutableArray arrayWithCapacity:[inactivesData count]];
            
            if ([inactivesData count] > 0) {
                for (NSDictionary *inactive in inactivesData) {
                    
                    CarmaDriver *inactiveNew = [[CarmaDriver alloc] init];
                    [inactiveNew driverWithDictionary:inactive];
                    [inactivesTemp addObject:inactiveNew];
                    
                }
            }
            
            self.inactives = inactivesTemp;
        }
        
    }
    
    return self;
    
}

- (BOOL)isToday {
    
    // Convert both today and the day's date into strings
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy/MM/dd"];
    
    NSString *today = [dateFormat stringFromDate:[NSDate date]];
    NSString *day = [dateFormat stringFromDate:date];
    
    // Check whether the date is today's date
    return [today isEqualToString:day];
    
}

@end
