//
//  iDViewController.m
//  hiJink
//
//  Created by Isaac Dudney on 6/18/14.
//  Copyright (c) 2014 net.dudney.games. All rights reserved.
//

#import "iDViewController.h"
#import "iDMyScene.h"

@implementation iDViewController

- (BOOL)prefersStatusBarHidden{
    return YES;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    SKView * skView = (SKView *)self.view;
    skView.ignoresSiblingOrder = YES;
    
    if (!skView.scene) {
        iDMyScene *scene = [iDMyScene sceneWithSize:skView.bounds.size];
        scene.viewController = self;
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [skView presentScene:scene];
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end