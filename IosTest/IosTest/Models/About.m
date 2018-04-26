//
//  About.m
//  IosTest
//
//  Created by Ishan on 4/26/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "About.h"
#import "Constans.h"
#import <SWNetworking/SWRequest.h>
#import "NSDictionary+NSDictionary.h"

@implementation About

- (id)initWithDictionary:(NSDictionary *)dictionary {
    
    self = [super init];
    
    if (self) {
        for (NSString *key in dictionary) {
            
            if ([key isEqualToString:@"title"]) {
                self.feedTitle = [dictionary objectForKey:@"title"];
            } else if ([key isEqualToString:@"description"]) {
                self.feedDescription = [dictionary objectForKey:@"description"];
            } else if ([key isEqualToString:@"imageHref"]) {
                self.feedImageUrl = [dictionary objectForKey:@"imageHref"];
            }
        }
    }
    return self;
}

+ (void)callGetFeedAPI:(UIView *)view
            completion:(void (^)(NSArray *))completion
                 error:(void (^)(NSString *))errorBlock {
    //using SWNetworking call the API.
    SWGETRequest *getFeedRequest    = [[SWGETRequest alloc] init];
    [getFeedRequest startDataTaskWithURL:FEED_URL
                              parameters:nil
                              parentView:view
                                 success:^(NSURLSessionDataTask *uploadTask, id responseObject) {
                                     
                                     //Get response from API call and encording it to UTF8
                                     NSError *error                  = nil;
                                     NSString *string                = [[NSString alloc] initWithData:responseObject encoding:NSISOLatin1StringEncoding];
                                     NSData *utf8Data                = [string dataUsingEncoding:NSUTF8StringEncoding];
                                     NSDictionary *respondObject     = [NSJSONSerialization JSONObjectWithData:utf8Data options:NSJSONReadingMutableContainers error:&error];
                                     
                                     //Reading respond and assign the data into array
                                     completion([self getFeedList:respondObject]);
                                     
                                 } failure:^(NSURLSessionTask *uploadTask, NSError *error) {
                                     errorBlock(ERROR_MESSAGE);
                                 }];
}

+ (NSArray *)getFeedList:(NSDictionary *)response {
    
    NSMutableArray *feedArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *object in [response objectForKey:@"rows"]) {
        NSDictionary *customObject = [object dictionaryRemovingNSNullValues];
        
        [feedArray addObject:[[About alloc] initWithDictionary:customObject]];
    }
    return feedArray;
}

@end
