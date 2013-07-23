//
//  AFViewController.m
//  AFootball
//
//  Created by traintrackcn on 13-7-15.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "AFViewController.h"
#import "AFMyScene.h"

@implementation AFViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    [self setView:[[UIView alloc] init]];
//    [self view].backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    
    CGRect screenFrame = [[UIScreen mainScreen] bounds];
    // Configure the view.
//    float viewH = screenFrame.size.height;
//    CGRect skViewRect = CGRectMake(0, (screenFrame.size.height-viewH)/2.0, 320, viewH);
    SKView * skView = [[SKView alloc] initWithFrame:screenFrame];
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    skView.showsDrawCount = YES;
//    [[self view] addSubview:skView];
    [self setView:skView];
    
    
    
//    NSLog(@"skViewRect w:%f h:%f", skViewRect.size.width);
    
    // Create and configure the scene.
    SKScene * scene = [AFMyScene sceneWithSize:skView.bounds.size];
//    SKScene * scene = [AFMyScene sceneWithSize:CGSizeMake(256.0, 256.0)];
    scene.scaleMode = SKSceneScaleModeAspectFit;
//    [scene setAnchorPoint:CGPointMake(10, 10)];
//    LOG_DEBUG();
    
    // Present the scene.
    [skView presentScene:scene];
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

@end
