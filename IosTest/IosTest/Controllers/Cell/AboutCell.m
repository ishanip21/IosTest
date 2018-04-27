//
//  AboutCell.m
//  IosTest
//
//  Created by Ishan on 4/26/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "AboutCell.h"

@implementation AboutCell

-(void)awakeFromNib {
    [super awakeFromNib];
    self.bannerImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.bannerImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.bannerImageView.layer setMasksToBounds:YES];
}

@end
