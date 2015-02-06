//
//  filterViewController.m
//  Yelp
//
//  Created by Fabián Uribe Herrera on 2/1/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "filterViewController.h"
#import "SwitchCell.h"
#import "SegmentedViewCell.h"

@interface filterViewController () <UITableViewDataSource, UITableViewDelegate, SwitchCellDelegate, SegmentedViewCellDelegate>

@property (nonatomic, readonly) NSDictionary *filters;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *categories;
@property (nonatomic, strong) NSArray *distanceOptions;
@property (nonatomic, strong) NSArray *sortOptions;
@property (nonatomic, strong) NSArray *popularOptions;


@property (nonatomic, strong) NSMutableSet *selectedCategories;
@property  BOOL onlyDeals;
@property  NSInteger selectedDistance;
@property  NSInteger selectedSort;

- (void) initCategories;
- (void) initDistanceOptions;
- (void) initSortOptions;


@end

@implementation filterViewController


- (id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.selectedCategories = [NSMutableSet set];
        [self initCategories];
        [self initDistanceOptions];
        [self initSortOptions];
        self.onlyDeals = NO;
    }
    
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(onCancelBtn)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Apply" style:UIBarButtonItemStylePlain target:self action:@selector(onApplyBtn)];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchCell" bundle:nil] forCellReuseIdentifier:@"SwitchCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"SegmentedViewCell" bundle:nil] forCellReuseIdentifier:@"SegmentedViewCell"];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"Sort by";
    }
    else if (section == 1){
        return @"Distance";
    }
    else if ( section == 2 ){
        return @"Popular";
    }
    else{
        return @"Categories";
    }
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - TableView methods

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if( section == 1 ){
        return 1;
    }else if( section == 2){
        return 1;
    }else{
        return self.categories.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([indexPath section] == 0) {
        
        SegmentedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentedViewCell"];
        
        [cell.segmentedControl removeAllSegments];

        
        for (NSDictionary *option in self.sortOptions) {
            [cell.segmentedControl insertSegmentWithTitle:option[@"title"] atIndex:cell.segmentedControl.numberOfSegments animated:NO];
        }
        
        cell.segmentedControl.selectedSegmentIndex = 0;
        cell.delegate = self;

        return cell;

    }
    
    if ([indexPath section] == 1) {
        
        SegmentedViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SegmentedViewCell"];
        
        [cell.segmentedControl removeAllSegments];
        
        for (NSDictionary *distance in self.distanceOptions) {
            [cell.segmentedControl insertSegmentWithTitle:distance[@"title"] atIndex:cell.segmentedControl.numberOfSegments animated:NO];
        }
        
        cell.segmentedControl.selectedSegmentIndex = 0;
        cell.delegate = self;

        return cell;
        
    }
    if ([indexPath section] == 2) {
        
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        cell.switchLabel.text = @"Offering a deal";
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        cell.delegate = self;
        
        return cell;
        
    } else {
        SwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchCell"];
        
        cell.switchLabel.text = self.categories[indexPath.row][@"name"];
        cell.on = [self.selectedCategories containsObject:self.categories[indexPath.row]];
        cell.delegate = self;
        
        return cell;
    }

}

#pragma mark -  Switch cell delegate methods

- (void) switchCell: (SwitchCell *)cell didUpdateValue:(BOOL)value{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if ([indexPath section] == 2) {
        if (value) {
            self.onlyDeals = YES;
        } else {
            self.onlyDeals = NO;
        }
    }

    if ([indexPath section] == 3) {
    
        if (value) {
            [self.selectedCategories addObject: self.categories[indexPath.row]];
        } else {
            [self.selectedCategories removeObject: self.categories[indexPath.row]];
        }
    }
}

- (void) segmentedViewCell: (SegmentedViewCell *)cell didUpdateValue:(NSInteger)value {
    
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    
    if ([indexPath section] == 0) {
        self.selectedSort = value;
    }
    
    if ([indexPath section] == 1) {
        self.selectedDistance = value;
    }
}


#pragma mark - Private methods

- (NSDictionary *) filters {
    
    NSMutableDictionary *filters = [NSMutableDictionary dictionary];
    
    [filters setObject:self.sortOptions[self.selectedSort][@"value"] forKey:@"sort"];
    
    
    [filters setObject:self.distanceOptions[self.selectedDistance][@"value"] forKey:@"radius_filter"];
    
    
    if (self.onlyDeals == YES) {
        [filters setObject:@"true" forKey:@"deals_filter"];
    }
    
    
    if (self.selectedCategories.count > 0) {
        NSMutableArray *names = [NSMutableArray array];
        
        for (NSDictionary *category in self.selectedCategories) {
            [names addObject:category[@"code"]];
            NSString *categoryFilter = [names componentsJoinedByString:@","];
            [filters setObject:categoryFilter forKey:@"category_filter"];
        }
    }
    
    return filters;
}


- (void) onCancelBtn {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) onApplyBtn {
    [self.delegate filterViewController:self didChangeFilters: self.filters];
    [self dismissViewControllerAnimated:YES completion:nil];    
}

- (void) initCategories {
    
    self.categories =  @[ @{@"name" : @"American, Traditional", @"code": @"tradamerican" },
                          @{@"name" : @"Chinese", @"code": @"chinese" },
                          @{@"name" : @"Italian", @"code": @"italian" },
                          @{@"name" : @"Japanese", @"code": @"japanese" },
                          @{@"name" : @"Mexican", @"code": @"mexican" },
                          @{@"name" : @"Thai", @"code": @"thai" },
                          @{@"name" : @"Vegetarian", @"code": @"vegetarian" }];
    
}


- (void) initSortOptions {
    
    self.sortOptions =  @[ @{@"title" : @"Best match", @"value": @"0" },
                           @{@"title" : @"Distance", @"value": @"1" },
                           @{@"title" : @"Rating", @"value": @"2" }];
}


- (void) initDistanceOptions {
    
    self.distanceOptions =  @[ @{@"title" : @"Any", @"value": @"40000" },
                               @{@"title" : @"1 Mile", @"value": @"1609" },
                               @{@"title" : @"5 Miles", @"value": @"8045" },
                               @{@"title" : @"20 Miles", @"value": @"32180" }];
}

@end
