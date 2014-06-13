//
//  RWTLevel.m
//  CookieCrunch
//
//  Created by タイ マイ・ティー on 6/11/14.
//  Copyright (c) 2014 Paditech. All rights reserved.
//

#import "RWTLevel.h"

@interface RWTLevel ()

@property (strong, nonatomic) NSSet *possibleSwaps;

@end

@implementation RWTLevel {
    RWTCookie *_cookies[NumColumns][NumRows];
    RWTTile *_tiles[NumColumns][NumRows];
}

- (RWTCookie *)cookieAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column: %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row: %ld", (long)row);
    
    return _cookies[column][row];
}

- (NSSet *)shuffle {
    NSSet *set;
    do {
        set = [self createInitialCookies];
        
        [self detectPossibleSwaps];
        NSLog(@"Possible swaps: %@", self.possibleSwaps);
    }
    while ([self.possibleSwaps count] == 0);
    
    return set;
}

- (BOOL)hasChainAtColumn: (NSInteger)column row: (NSInteger)row {
    NSUInteger cookieType = _cookies[column][row].cookieType;
    
    NSUInteger horzLength = 1;
    for (NSInteger i = column - 1; i >= 0 && _cookies[i][row].cookieType == cookieType; i--, horzLength++);
    for (NSInteger i = column + 1; i < NumColumns && _cookies[i][row].cookieType == cookieType; i++, horzLength++);
    
    if (horzLength >= 3) return YES;
    
    NSUInteger vertLength = 1;
    for (NSInteger i = row - 1; i >= 0 && _cookies[i][row].cookieType == cookieType; i--, vertLength++);
    for (NSInteger i = row + 1; i < NumRows && _cookies[i][row].cookieType == cookieType; i++, vertLength++);
    
    return (vertLength >= 3);
}

- (void)detectPossibleSwaps {
    NSMutableSet *set = [NSMutableSet set];
    
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            
            RWTCookie *cookie = _cookies[column][row];
            if (cookie != nil) {
                
                // to do detection logic goes here
                // Is it possible to swap this cookie with the one on the right?
                if (column < NumColumns - 1) {
                    // Have a cookie in this spot? If there is no tile, there is no cookie
                    RWTCookie *other = _cookies[column + 1][row];
                    if (other != nil) {
                        // Swap them
                        _cookies[column][row] = other;
                        _cookies[column + 1][row] = cookie;
                        
                        // Is either cookie now parth of a chain
                        if ([self hasChainAtColumn:column + 1 row:row] ||
                            [self hasChainAtColumn:column row:row]) {
                            
                            RWTSwap *swap = [RWTSwap new];
                            swap.cookieA = cookie;
                            swap.cookieB = other;
                            [set addObject:swap];
                        }
                        
                        // Swap them back
                        _cookies[column][row] = cookie;
                        _cookies[column + 1][row] = other;
                    }
                }
                
                // Is it possible to swap this cookie with the one on the above
                if (row < NumRows - 1) {
                    RWTCookie *other = _cookies[column][row + 1];
                    if (other != nil) {
                        // swap them
                        _cookies[column][row] = other;
                        _cookies[column][row + 1] = cookie;
                        
                        if ([self hasChainAtColumn:column row:row] ||
                            [self hasChainAtColumn:column row:row+1]) {
                            
                            RWTSwap *swap = [RWTSwap new];
                            swap.cookieA = cookie;
                            swap.cookieB = other;
                            [set addObject:swap];
                        }
                        
                        _cookies[column][row] = cookie;
                        _cookies[column][row + 1] = other;
                    }
                }
            }
        }
    }
    
    self.possibleSwaps = set;
}

// check if swap is swapable
- (BOOL)isPossibleSwap: (RWTSwap *)swap {
    return [self.possibleSwaps containsObject:swap];
}

- (NSSet *)createInitialCookies {
    NSMutableSet *set = [NSMutableSet set];
    
    // 1
    for (NSInteger row = 0; row < NumRows; row++) {
        for (NSInteger column = 0; column < NumColumns; column++) {
            
            if (_tiles[column][row] != nil) {
                //2
//                NSUInteger cookieType = arc4random_uniform(NumCookieTypes) + 1;
                /*
                 do {
                 generate a new random number between 1 and 6
                 }
                 while (there are already two cookies of this type to the left
                 or there are already two cookies of this type below);
                 */
                NSUInteger cookieType;
                do {
                    cookieType = arc4random_uniform(NumCookieTypes) + 1;
                }
                while ((column >= 2 && _cookies[column - 1][row].cookieType == cookieType &&
                        _cookies[column - 2][row].cookieType == cookieType)
                        ||
                        (row >= 2 && _cookies[column][row - 1].cookieType == cookieType &&
                        _cookies[column][row - 2].cookieType == cookieType));
                
                // 3
                RWTCookie *cookie = [self createCookieAtColumn:column row:row withType: cookieType];
                
                // 4
                [set addObject:cookie];
            }
        }
    }
    
    return set;
}

- (RWTCookie *)createCookieAtColumn: (NSInteger)column row:(NSInteger)row withType: (NSUInteger)cookieType {
    RWTCookie *cookie = [RWTCookie new];
    cookie.cookieType = cookieType;
    cookie.column = column;
    cookie.row = row;
    _cookies[column][row] = cookie;
    
    return cookie;
}

// load json level
- (NSDictionary *)loadJSON: (NSString *)filename {
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    if (path == nil) {
        NSLog(@"Could not find level file: %@", filename);
        return nil;
    }
    
    NSError *error;
    NSData *data = [NSData dataWithContentsOfFile:path options:0 error:&error];
    if (data == nil) {
        NSLog(@"Could not load level file: %@, error: %@", filename, error);
        return nil;
    }
    
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (dictionary == nil || ![dictionary isKindOfClass:[NSDictionary class]]) {
        NSLog(@"Level file '%@' is not valid JSON: %@", filename, error);
    }
    
    return dictionary;
}

- (instancetype)initWithFile:(NSString *)filename {
    self = [super init];
    if (self != nil) {
        NSDictionary *dictionary = [self loadJSON:filename];
        
        // loop through the rows
        [dictionary[@"tiles"] enumerateObjectsUsingBlock:^(NSArray *array, NSUInteger row, BOOL *stop) {
            //loop throwgh the colums
            [array enumerateObjectsUsingBlock:^(NSNumber *value, NSUInteger column, BOOL *stop) {
                
                // note: In Spite Kit (0,0) is at the bottom of the screen,
                // so we need to read this file upsize down
                NSInteger tileRow = NumRows - row - 1;
                
                // If the value is 1, create a title object
                if ([value integerValue] == 1) {
                    _tiles[column][tileRow] = [RWTTile new];
                }
            }];
        }];
    }
    
    return self;
}

- (RWTTile *)tileAtColumn:(NSInteger)column row:(NSInteger)row {
    NSAssert1(column >= 0 && column < NumColumns, @"Invalid column %ld", (long)column);
    NSAssert1(row >= 0 && row < NumRows, @"Invalid row %ld", (long)row);
    
    return _tiles[column][row];
}

- (void)performSwap:(RWTSwap *)swap {
    NSInteger columnA = swap.cookieA.column;
    NSInteger rowA = swap.cookieA.row;
    NSInteger columnB = swap.cookieB.column;
    NSInteger rowB = swap.cookieB.row;
    
    _cookies[columnA][rowA] = swap.cookieB;
    swap.cookieB.column = columnA;
    swap.cookieB.row = rowA;
    
    _cookies[columnB][rowB] = swap.cookieA;
    swap.cookieA.column = columnB;
    swap.cookieA.row = rowB;
}

@end
