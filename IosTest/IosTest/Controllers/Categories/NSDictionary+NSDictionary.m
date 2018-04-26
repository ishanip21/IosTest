//
//  NSDictionary+NSDictionary.m
//  IosTest
//
//  Created by Ishan on 4/27/18.
//  Copyright © 2018 Ishan. All rights reserved.
//

#import "NSDictionary+NSDictionary.h"

@implementation NSDictionary (NSDictionary)

- (NSDictionary*)dictionaryRemovingNSNullValues {
    return [self removeNull];
}

#pragma mark - Replace null values to empty string

- (NSDictionary*)removeNull {
    
    NSMutableDictionary *replaced = [NSMutableDictionary dictionaryWithDictionary: self];
    
    const id nul = [NSNull null];
    const NSString *blank = @"";
    
    for (NSString *key in [self allKeys]) {
        
        const id object = [self objectForKey: key];
        if (object == nul) {
            [replaced setObject: blank forKey: key];
        }
    }
    return [NSDictionary dictionaryWithDictionary: replaced];
}

@end
