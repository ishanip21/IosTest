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
    
    __weak IBOutlet UIView *headerView;
    __weak IBOutlet UIImageView *bannerImageView;
}

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.about.feedTitle;
    
    self.tableView.estimatedRowHeight = 100.0f;
    self.tableView.rowHeight          = UITableViewAutomaticDimension;
    self.tableView.tableFooterView    = [[UIView alloc] initWithFrame:CGRectZero];
    
    if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation)) {
        [headerView setHidden:YES];
        bannerImageView.image = nil;
        
    } else {
        if (![self.about.feedImageUrl isEqualToString:@""]) {
            if (self.about.feedImage == nil) {
                [bannerImageView loadWithURLString:self.about.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
                    self.about.feedImage = image;
                }];
                
            } else {
                [bannerImageView setImage:self.about.feedImage];
            }
        }
    }
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
        if (![self.about.feedImageUrl isEqualToString:@""]) {
            //Feed image object is empty, Download image from Url using SWNetworking library
            if (self.about.feedImage == nil) {
                [cell.bannerImageView loadWithURLString:self.about.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
                    self.about.feedImage = image;
                }];
                
            } else {
                //Set image, already download image object
                [cell.bannerImageView setImage:self.about.feedImage];
            }
        } else {
            //Image url is empty, reset the constant and hide the image view
            [cell.bannerImageView setHidden:YES];
            //        cell.titleLeadingConstraint.constant        = 0.0f;
            //        cell.descriptionLeadingConstraint.constant  = 0.0f;
            //        cell.imageViewWidthConstraint.constant      = 0.0f;
            //        cell.imageViewHeightConstraint.constant     = 0.0f;
        }
        cell.descriptionLabel.text = self.about.feedDescription;
        return cell;
        
    } else {
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PortraitCell" forIndexPath:indexPath];
        cell.descriptionLabel.text = self.about.feedDescription;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
