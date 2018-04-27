//
//  DetailCell.h
//  IosTest
//
//  Created by Ishan on 4/27/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *bannerImageView;

@end
