//
//  DetailViewController.m
//  IosTest
//
//  Created by Ishan on 4/27/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "DetailViewController.h"
#import <SWNetworking/UIImageView+SWNetworking.h>
#import "DetailCell.h"
#import "DetailLandscapeCell.h"

@interface DetailViewController () {
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.about.feedTitle;
    self.navigationController.navigationBar.topItem.title = @"";
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];

    
    self.tableView.estimatedRowHeight = 230.0f;
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    self.tableView.tableFooterView    = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        DetailLandscapeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"landscapeCell" forIndexPath:indexPath];
        
        self.tableView.tableHeaderView = nil;
        if (![self.about.feedImageUrl isEqualToString:@""]) {
            //Feed image object is empty, Download image from Url using SWNetworking library
            if (self.about.feedImage == nil) {
                [cell.bannerImageView loadWithURLString:self.about.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
                    self.about.feedImage = image;
                    
                } errorBlock:^(NSString *error) {
                    
                }];
                
            } else {
                //Set image, already download image object
                [cell.bannerImageView setImage:self.about.feedImage];
            }
            
        } else {
            //Image url is empty, reset the constant and hide the image view
            [cell.bannerImageView setHidden:YES];
        }
        
        cell.descriptionLabel.text = self.about.feedDescription;
        return cell;
        
    } else {
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PortraitCell" forIndexPath:indexPath];
        cell.descriptionLabel.text         = self.about.feedDescription;
        if (![self.about.feedImageUrl isEqualToString:@""]) {
            //Feed image object is empty, Download image from Url using SWNetworking library
            if (self.about.feedImage == nil) {
                [cell.bannerImageView loadWithURLString:self.about.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
                    self.about.feedImage = image;
                    
                } errorBlock:^(NSString *error) {
                    
                }];
                
            } else {
                //Set image, already download image object
                [cell.bannerImageView setImage:self.about.feedImage];
            }
        } else {
            //Image url is empty, reset the constant and hide the image view
            [cell.bannerImageView setHidden:YES];
            //        cell.titleLeadingConstraint.constant        = 0.0f;
            
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

@end
