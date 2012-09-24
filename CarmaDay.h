//
//  CarmaDay.h
//  Carma
//
//  Created by Jeremy Lubin on 5/20/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CarmaDriver.h"

@interface CarmaDay : NSObject {
    
    NSDate *date;
    CarmaDriver *driver;
    NSArray *passengers;
    NSArray *inactives;

}

@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) CarmaDriver *driver;
@property (strong, nonatomic) NSArray *passengers;
@property (strong, nonatomic) NSArray *inactives;

- (id)initWithDictionary:dict;
- (BOOL)isToday;

@end
