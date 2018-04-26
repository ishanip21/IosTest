//
//  HomeViewController.m
//  IosTest
//
//  Created by Ishan on 4/26/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "HomeViewController.h"
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
    
    // Register cell classes
    [self.collectionView registerClass:[AboutCell class] forCellWithReuseIdentifier:reuseIdentifier];
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

#pragma mark - Action methods

- (IBAction)tapRefresh:(UIBarButtonItem *)sender {
    [self getDataFromAPI];
    feedsArray = nil;
    [self.collectionView reloadData];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionViewDataSource

//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    return 1;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [feedsArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    AboutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];

    About *about = [feedsArray objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = about.feedTitle;
    cell.titleLabel.textColor = [UIColor yellowColor];
    cell.descriptionLabel.text = about.description;
    [cell setBackgroundColor:[UIColor redColor]];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(350, 100);
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

@end
