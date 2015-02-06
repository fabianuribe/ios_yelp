//
//  SegmentedViewCell.h
//  Yelp
//
//  Created by Fabián Uribe Herrera on 2/5/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SegmentedViewCell;

@protocol SegmentedViewCellDelegate <NSObject>

- (void) segmentedViewCell:(SegmentedViewCell *)cell didUpdateValue:(NSInteger) value;


@end

@interface SegmentedViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (nonatomic, weak) id<SegmentedViewCellDelegate> delegate;


@end
