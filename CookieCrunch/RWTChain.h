//
//  RWTChain.h
//  CookieCrunch
//
//  Created by タイ マイ・ティー on 7/1/14.
//  Copyright (c) 2014 Paditech. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RWTCookie;

typedef NS_ENUM(NSUInteger, ChainType) {
    ChainTypeHorizontal,
    ChainTypeVertical,
};

@interface RWTChain : NSObject

@property (strong, nonatomic, readonly) NSArray *cookies;

@property (assign, nonatomic) ChainType chainType;

@property (assign, nonatomic) NSUInteger score;

- (void)addCookie:(RWTCookie *)cookie;

@end
