//
//  CarmaPool.h
//  Carma
//
//  Created by Jeremy Lubin on 7/7/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CarmaPool : NSObject
{
    NSString *poolID;
    NSString *rotationMethod;
    NSNumber *rotationDay;
    NSNumber *rotationLength;
    NSDictionary *drivers;
}

@property (strong, nonatomic) NSString *poolID;
@property (strong, nonatomic) NSString *rotationMethod;
@property (strong, nonatomic) NSNumber *rotationDay;
@property (strong, nonatomic) NSNumber *rotationLength;
@property (strong, nonatomic) NSDictionary *drivers;

- (id)initWithDictionary:(NSDictionary *)dict;

@end
