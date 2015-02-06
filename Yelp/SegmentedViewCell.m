//
//  SegmentedViewCell.m
//  Yelp
//
//  Created by Fabián Uribe Herrera on 2/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "SegmentedViewCell.h"


@interface SegmentedViewCell ()

- (IBAction)segmentedControllerChanged:(id)sender;


@end


@implementation SegmentedViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)segmentedControllerChanged: (id)sender {
    [self.delegate segmentedViewCell:self didUpdateValue: self.segmentedControl.selectedSegmentIndex];
}

@end
