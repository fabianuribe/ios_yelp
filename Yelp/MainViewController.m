//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "ResultCell.h"
#import "UIImageView+AFNetworking.h"
#import "JGProgressHUD.h"
#import "filterViewController.h"


NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, filerViewControllerDellegate, UISearchBarDelegate>

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *businesses;
@property (nonatomic, strong) UISearchBar *searchBar;

- (void) fetchBusinessesWithQuery: (NSString *)query params: (NSDictionary *)params;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self fetchBusinessesWithQuery:@"Restaurants" params: nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // set the view as source and delegator of the table view
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.navigationItem.titleView = [[UISearchBar alloc] init];
    
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.placeholder = @"e.g. tacos, Max's";
    self.searchBar.delegate = self;
    self.navigationItem.titleView = self.searchBar;
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleDone target:self action:@selector(onFilterButton)];
    
    // Register cell view
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCell"];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 98;
    
}



- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    // Do the search...
    [self onSearchButton];
}

- (void) onSearchButton {
    NSString *searchTerm = self.searchBar.text;
//    [self fetchBusinessesWithQuery:searchTerm params:self.filters];
        [self fetchBusinessesWithQuery:searchTerm params:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.businesses.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ResultCell"];
    
    NSDictionary *business = self.businesses[indexPath.row];
    NSArray *street = [business valueForKeyPath: @"location.address"];
    
    float distance = [business[@"distance"] floatValue];
    
    cell.businessTitleLabel.text = [NSString stringWithFormat:@"%i. %@", (int)indexPath.item + 1, business[@"name"]];
    cell.categoryLabel.text = [[[business valueForKeyPath: @"categories"] objectAtIndex:0] objectAtIndex:0];
    cell.addressLabel.text =  [NSString stringWithFormat: @"%@, %@", (street.count)? street[0] : @"" , [business valueForKeyPath:@"location.city"]];
    cell.reviewCountLabel.text = [NSString stringWithFormat: @"%@ reviews", business[@"review_count"]];
    cell.distanceLabel.text = [NSString stringWithFormat:@" %.02f mi", distance/1609 ];
    
    [cell.thumbImage setImageWithURL:[NSURL URLWithString: [business valueForKeyPath:@"image_url"]]];
    [cell.ratingImage setImageWithURL:[NSURL URLWithString: [business valueForKeyPath:@"rating_img_url_large"]]];

    return cell;

}


#pragma mark - Filter 

- (void) filterViewController:(filterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters {
    
    NSString *searchTerm = self.searchBar.text;
    

    [self fetchBusinessesWithQuery:searchTerm params: filters];
}


#pragma mark - Private methods

- (void) fetchBusinessesWithQuery: (NSString *)query params: (NSDictionary *)params {
    // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
    self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];

    JGProgressHUD *HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = @"Loading";
    [HUD showInView:self.view];
    
    
    [self.client searchWithTerm:query params:params success:^(AFHTTPRequestOperation *operation, id response) {
        
        self.businesses = response[@"businesses"];
        

        [self.tableView reloadData];
        
        [HUD dismissAfterDelay:.3];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
        HUD.textLabel.text = @"Error while getting results";

        self.businesses =  @[];
        [self.tableView reloadData];

        [HUD dismissAfterDelay:2.0];

    }];
}


- (void) onFilterButton {
    filterViewController *vc = [[filterViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
