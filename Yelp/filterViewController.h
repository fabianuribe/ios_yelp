//
//  filterViewController.h
//  Yelp
//
//  Created by Fabián Uribe Herrera on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import <UIKit/UIKit.h>

@class filterViewController;

@protocol filerViewControllerDellegate <NSObject>

- (void) filterViewController: (filterViewController *) filterViewController didChangeFilters: (NSDictionary *) filters;

@end

@interface filterViewController : UIViewController

@property (nonatomic, weak) id <filerViewControllerDellegate> delegate;

@end
