//
//  CarmaUserProfileCell.h
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CarmaUserProfileCell : UITableViewCell
{
    UILabel *contextLabel;
    UILabel *dataLabel;
    UIImageView *contextImage;
}

@property (strong, nonatomic) UILabel *contextLabel;
@property (strong, nonatomic) UILabel *dataLabel;
@property (strong, nonatomic) UIImageView *contextImage;

@end
