//
//  CarmaUserProfileCell.m
//  Carma
//
//  Created by Jeremy Lubin on 7/5/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import "CarmaUserProfileCell.h"

@implementation CarmaUserProfileCell

@synthesize contextLabel;
@synthesize dataLabel;
@synthesize contextImage;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        UIView *textHolder = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x + 69,
                                                                      (69 - 55)/2,
                                                                      self.frame.size.width - 80,
                                                                      55)];
        
        contextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                                 1,
                                                                 textHolder.frame.size.width,
                                                                 26)];
        contextLabel.font = [UIFont fontWithName:@"Heiti TC" size:16.0];
        contextLabel.textColor = [UIColor colorWithRed:118/255. green:118/255. blue:118/255. alpha:1];
        contextLabel.highlightedTextColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:1];
        contextLabel.backgroundColor = [UIColor clearColor];
        [textHolder addSubview:contextLabel];
        
        dataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,
                                                              1 + 26 + 1,
                                                              textHolder.frame.size.width,
                                                              26)];
        dataLabel.font = [UIFont fontWithName:@"Heiti TC" size:16.0];
        dataLabel.textColor = [UIColor colorWithRed:25/255. green:78/255. blue:112/255. alpha:1];
        dataLabel.highlightedTextColor = [UIColor colorWithRed:50/255. green:100/255. blue:128/255. alpha:1];
        dataLabel.backgroundColor = [UIColor clearColor];
        [textHolder addSubview:dataLabel];
        
        [self addSubview:textHolder];
        
        self.contextImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 69, 69)];
        [self addSubview:contextImage];
        
        UIView *greenBackground = [[UIView alloc] init];
        [greenBackground setBackgroundColor:[UIColor colorWithRed:197/255. green:243/255. blue:216/255. alpha:1]];
        self.selectedBackgroundView = greenBackground;
        
        //self.contentView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
