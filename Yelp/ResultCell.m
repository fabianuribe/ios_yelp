//
//  ResultCell.m
//  Yelp
//
//  Created by Fabián Uribe Herrera on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "ResultCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation ResultCell

- (void)awakeFromNib {
    // Initialization code
    self.thumbImage.layer.cornerRadius = 8.0;
    self.thumbImage.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
