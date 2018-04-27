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
#import "CHTCollectionViewWaterfallLayout.h"
#import "AboutCell.h"
#import "About.h"

#define HEADER_IDENTIFIER @"WaterfallHeader"
#define FOOTER_IDENTIFIER @"WaterfallFooter"

@interface HomeViewController ()<CHTCollectionViewDelegateWaterfallLayout> {
    NSArray             *feedsArray;
    NSMutableArray      *cellSize;
    NSMutableDictionary *cellSizeDictionary;
}

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CHTCollectionViewWaterfallLayout *layout    = [[CHTCollectionViewWaterfallLayout alloc] init];
    layout.sectionInset                         = UIEdgeInsetsMake(10, 10, 10, 10);
    self.collectionView.collectionViewLayout    = layout;
    self.collectionView.autoresizingMask        = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.collectionView layoutIfNeeded];
    
    self.title  = @"About Canada";
    cellSizeDictionary = [[NSMutableDictionary alloc] init];
    [self getDataFromAPI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLayoutForOrientation:[UIApplication sharedApplication].statusBarOrientation];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    [self updateLayoutForOrientation:toInterfaceOrientation];
}

- (void)updateLayoutForOrientation:(UIInterfaceOrientation)orientation {
    CHTCollectionViewWaterfallLayout *layout =
    (CHTCollectionViewWaterfallLayout *)self.collectionView.collectionViewLayout;
    layout.columnCount = UIInterfaceOrientationIsPortrait(orientation) ? 2 : 3;
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
        cellSize = [[NSMutableArray alloc] initWithCapacity:[feedsArray count]];
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
    [cellSizeDictionary removeAllObjects];
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [feedsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AboutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AboutCell" forIndexPath:indexPath];

    About *about = [feedsArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text        = about.feedTitle;
    cell.bannerImageView.image  = nil;
    [cell.bannerImageView setHidden:NO];
    
    if (![about.feedImageUrl isEqualToString:@""]) {
        //Feed image object is empty, Download image from Url using SWNetworking library
        if (about.feedImage == nil) {
            [cell.bannerImageView loadWithURLString:about.feedImageUrl loadFromCacheFirst:YES complete:^(UIImage *image) {
                about.feedImage = image;
                //add image size into dictionary
                [cellSizeDictionary setObject:[NSValue valueWithCGSize:CGSizeMake(image.size.width, image.size.height)] forKey:[NSNumber numberWithInteger:indexPath.row]];
                [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                
            } errorBlock:^(NSString *error) {
                [cellSizeDictionary setObject:[NSValue valueWithCGSize:CGSizeMake(0, 150)] forKey:[NSNumber numberWithInteger:indexPath.row]];
            }];
            
        } else {
            //Set image, already download image object
            [cell.bannerImageView setImage:about.feedImage];
        }
    } else {
        //Image url is empty, reset the constant and hide the image view
        [cellSizeDictionary setObject:[NSValue valueWithCGSize:CGSizeMake(0, 150)] forKey:[NSNumber numberWithInteger:indexPath.row]];
        [cell.bannerImageView setHidden:YES];
    }
    cell.bannerButton.tag = indexPath.row;
    [cell.bannerButton addTarget:self action:@selector(tapImageView:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([cellSizeDictionary count] > 0) {
        return [[cellSizeDictionary objectForKey:[NSNumber numberWithInteger:indexPath.row]] CGSizeValue];
    } else {
        return CGSizeMake(0, 0);
    }
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    return NO;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     if ([segue.identifier isEqualToString:@"DetailView"]) {
         DetailViewController *detailViewController = segue.destinationViewController;
         detailViewController.about = (About *)sender;
     }
 }

@end
