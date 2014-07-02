//
//  RWTChain.m
//  CookieCrunch
//
//  Created by タイ マイ・ティー on 7/1/14.
//  Copyright (c) 2014 Paditech. All rights reserved.
//

#import "RWTChain.h"

@implementation RWTChain {
    NSMutableArray *_cookies;
}

- (void)addCookie:(RWTCookie *)cookie {
    if (_cookies == nil) {
        _cookies = [NSMutableArray array];
    }
    
    [_cookies addObject:cookie];
}

- (NSArray *)cookies {
    return _cookies;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"type:%ld cookies:%@", (long)self.chainType, self.cookies];
}

@end
