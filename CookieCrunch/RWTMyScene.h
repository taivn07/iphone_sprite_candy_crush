//
//  RWTMyScene.h
//  CookieCrunch
//

//  Copyright (c) 2014 Paditech. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class RWTLevel;
@class RWTSwap;

@interface RWTMyScene : SKScene

@property (strong, nonatomic) RWTLevel *level;

- (void)addSpritesForCookies: (NSSet *)cookies;

- (void)addTiles;

@property (copy, nonatomic) void (^swipeHandler)(RWTSwap *swap);

- (void)animateSwap: (RWTSwap *)swap completion: (dispatch_block_t)completion;

// slides the cookies to their new positions and then immediately flips them back
- (void)animateInvalidSwap: (RWTSwap *)swap completion: (dispatch_block_t)completion;

- (void)animateMatchedCookies: (NSSet *)chains completion: (dispatch_block_t)completion;

- (void)animateFallingCookies: (NSArray *)columns completion: (dispatch_block_t)completion;

- (void)animateNewCookies: (NSArray *)columns completion: (dispatch_block_t)completion;

- (void)animateGameOver;
- (void)animateBeginGame;

- (void)removeAllCookieSprites;

@end
