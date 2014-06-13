//
//  RWTLevel.h
//  CookieCrunch
//
//  Created by タイ マイ・ティー on 6/11/14.
//  Copyright (c) 2014 Paditech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RWTCookie.h"
#import "RWTTile.h"
#import "RWTSwap.h"

static const NSInteger NumColumns = 9;
static const NSInteger NumRows = 9;

@interface RWTLevel : NSObject

- (NSSet *)shuffle;

- (RWTCookie *)cookieAtColumn: (NSInteger)column row:(NSInteger)row;

- (instancetype)initWithFile: (NSString *)filename;
- (RWTTile *)tileAtColumn: (NSInteger)column row: (NSInteger)row;

- (void)performSwap: (RWTSwap *)swap;

- (BOOL)isPossibleSwap: (RWTSwap *)swap;

@end
