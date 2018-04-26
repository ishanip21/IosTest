//
//  About.h
//  IosTest
//
//  Created by Ishan on 4/26/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface About : NSObject

@property (nonatomic, strong) NSString *feedTitle;
@property (nonatomic, strong) NSString *feedDescription;
@property (nonatomic, strong) NSString *feedImageUrl;
@property (nonatomic, strong) UIImage  *feedImage;

+ (void)callGetFeedAPI:(UIView *)view completion:(void(^)(NSArray *feedArray))completion error:(void(^)(NSString *error))errorBlock;
- (NSArray *)getFeedList:(NSDictionary *)response;

@end
