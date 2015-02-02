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
#import "filterViewController.h"


NSString * const kYelpConsumerKey = @"vxKwwcR_NMQ7WaEiQBK_CA";
NSString * const kYelpConsumerSecret = @"33QCvh5bIF5jIHR5klQr7RtBDhQ";
NSString * const kYelpToken = @"uRcRswHFYa1VkDrGV6LAW2F8clGh5JHV";
NSString * const kYelpTokenSecret = @"mqtKIxMIR4iBtBPZCmCLEb-Dz3Y";

@interface MainViewController () <UITableViewDataSource, UITableViewDelegate, filerViewControllerDellegate>

@property (nonatomic, strong) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *businesses;


@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // You can register for Yelp API keys here: http://www.yelp.com/developers/manage_api_keys
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey consumerSecret:kYelpConsumerSecret accessToken:kYelpToken accessSecret:kYelpTokenSecret];
        
        [self.client searchWithTerm:@"Thai" success:^(AFHTTPRequestOperation *operation, id response) {
            
            self.businesses = response[@"businesses"];
            [self.tableView reloadData];

        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"error: %@", [error description]);
        }];
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
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Filters" style:UIBarButtonItemStyleDone target:self action:@selector(onFilterButton)];
    
    // Register cell view
    [self.tableView registerNib:[UINib nibWithNibName:@"ResultCell" bundle:nil] forCellReuseIdentifier:@"ResultCell"];

    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 98;

    
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
    
    float distance = [business[@"distance"] floatValue];
    
    cell.businessTitleLabel.text = [NSString stringWithFormat:@"%i. %@", (int)indexPath.item + 1, business[@"name"]];
    cell.categoryLabel.text = [[[business valueForKeyPath: @"categories"] objectAtIndex:0] objectAtIndex:0];
    cell.addressLabel.text =  [NSString stringWithFormat: @"%@, %@", [[business valueForKeyPath:@"location.address"] objectAtIndex:0], [business valueForKeyPath:@"location.city"]];
    cell.reviewCountLabel.text = [NSString stringWithFormat: @"%@ reviews", business[@"review_count"]];
    cell.distanceLabel.text = [NSString stringWithFormat:@" %.02f mi", distance ];
    
    [cell.thumbImage setImageWithURL:[NSURL URLWithString: [business valueForKeyPath:@"image_url"]]];
    [cell.ratingImage setImageWithURL:[NSURL URLWithString: [business valueForKeyPath:@"rating_img_url_large"]]];

    return cell;

}


#pragma mark - Filter 

- (void) filterViewController:(filterViewController *)filterViewController didChangeFilters:(NSDictionary *)filters {
    //fire new network event
}


#pragma mark - Private methods

- (void) onFilterButton {
    filterViewController *vc = [[filterViewController alloc] init];
    vc.delegate = self;
    
    UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self presentViewController:nvc animated:YES completion:nil];
}

@end
