//
//  CarmaCalendarDayRoleCell.m
//  Carma
//
//  Created by Jeremy Lubin on 6/6/12.
//  Copyright (c) 2012 Lubin Labs. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "CarmaCalendarDayRoleCell.h"

static NSString *const UserImageURLPrefix = @"http://carma.io/styles/images/";

@implementation CarmaCalendarDayRoleCell

@synthesize driver;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier andUser:(CarmaDriver *)user;
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // Start download for user photo
        self.imageView.image = [UIImage imageNamed:@"user_placeholder@2x.png"];
        self.imageView.layer.masksToBounds = YES;
        //self.imageView.layer.cornerRadius = 10.0;
        
        // Load the cell image
        LLDataDownloader *downloader = [[LLDataDownloader alloc] init];
        downloader.delegate = self;
        NSString *imageURL = [NSString stringWithFormat:@"%@%@", UserImageURLPrefix, user.imageURL];
        if (![downloader getDataWithURL:imageURL]) {NSLog(@"Couldn't download %@", imageURL);}
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dataHasFinishedDownloadingWithResult:(BOOL)result andData:(NSData *)data {
    
    UIImage *imageTemp = [UIImage imageWithData:data];
    self.imageView.image = imageTemp;
    
}

@end
