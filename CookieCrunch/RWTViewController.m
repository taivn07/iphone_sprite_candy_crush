//
//  RWTViewController.m
//  CookieCrunch
//
//  Created by タイ マイ・ティー on 6/11/14.
//  Copyright (c) 2014 Paditech. All rights reserved.
//

#import "RWTViewController.h"
#import "RWTMyScene.h"
#import "RWTLevel.h"

@interface RWTViewController ()

@property (strong, nonatomic) RWTLevel *level;
@property (strong, nonatomic) RWTMyScene *scene;

@end

@implementation RWTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.multipleTouchEnabled = YES;
    
    // Create and configure the scene.
    self.scene = [RWTMyScene sceneWithSize:skView.bounds.size];
    self.scene.scaleMode = SKSceneScaleModeAspectFill;
    
    // Load the level
    self.level = [[RWTLevel alloc] initWithFile:@"Level_3"];
    self.scene.level = self.level;
    
    // Add tile
    [self.scene addTiles];
    
    id block = ^(RWTSwap *swap) {
        self.view.userInteractionEnabled = NO;
        
        if ([self.level isPossibleSwap:swap]) {
            [self.level performSwap:swap];
            [self.scene animateSwap:swap completion:^{
                self.view.userInteractionEnabled = YES;
            }];
        } else {
            [self.scene animateInvalidSwap:swap completion:^{
                self.view.userInteractionEnabled = YES;
            }];
        }
    };
    
    self.scene.swipeHandler = block;
    
    // Present the scene.
    [skView presentScene:self.scene];
    
    // Let's start the game!
    [self beginGame];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    } else {
        return UIInterfaceOrientationMaskAll;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void)beginGame {
    [self shuffle];
}

- (void)shuffle {
    NSSet *newCookies = [self.level shuffle];
    [self.scene addSpritesForCookies:newCookies];
    
}

@end
