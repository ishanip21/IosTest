//
//  HomeViewController.m
//  IosTest
//
//  Created by Ishan on 4/26/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailViewController.h"
#import <SWNetworking/UIImageView+SWNetworking.h>
#import "AboutCell.h"
#import "About.h"

@interface HomeViewController () {
    NSArray *feedsArray;
}

@end

@implementation HomeViewController

static NSString * const reuseIdentifier = @"AboutCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"About Canada";
    [self getDataFromAPI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Custom methods

-(void)showAlertWithMessage:(NSString *)message {
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:message
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertController addAction:okButton];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)getDataFromAPI {
    [About callGetFeedAPI:self.navigationController.view completion:^(NSArray *feedArray) {
        feedsArray = feedArray;
        [self.collectionView reloadData];
        
    } error:^(NSString *error) {
        [self showAlertWithMessage:error];
    }];
}

- (void)tapImageView:(UIButton *)sender {
    [self performSegueWithIdentifier:@"DetailView" sender:[feedsArray objectAtIndex:sender.tag]];
}

#pragma mark - Action methods

- (IBAction)tapRefresh:(UIBarButtonItem *)sender {
    [self getDataFromAPI];
    feedsArray = nil;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [feedsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AboutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    About *about = [feedsArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text        = about.feedTitle;
    cell.bannerImageView.image  = nil;
    if (![about.feedImageUrl isEqualToString:@""]) {
        //Feed image object is empty, Download image from Url using SWNetworking library
        if (about.feedImage == nil) {
            [cell.bannerImageView loadWithURLString:about.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
                about.feedImage = image;
            }];
            
        } else {
            //Set image, already download image object
            [cell.bannerImageView setImage:about.feedImage];
        }
    } else {
        //Image url is empty, reset the constant and hide the image view
        [cell.bannerImageView setHidden:YES];
//        cell.titleLeadingConstraint.constant        = 0.0f;
//        cell.descriptionLeadingConstraint.constant  = 0.0f;
//        cell.imageViewWidthConstraint.constant      = 0.0f;
//        cell.imageViewHeightConstraint.constant     = 0.0f;
    }
    cell.bannerButton.tag = indexPath.row;
    [cell.bannerButton addTarget:self action:@selector(tapImageView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(350, 200);
}

#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

#pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"DetailView"]) {
         DetailViewController *detailViewController = segue.destinationViewController;
         detailViewController.about = (About *)sender;
     }
 }

@end
