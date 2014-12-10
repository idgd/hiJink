//  iDMyScene.m
//  hiJink
//  Created by Isaac Dudney on 6/18/14.
//  Copyright (c) 2014 net.dudney.games. All rights reserved.

#import "iDMyScene.h"

@interface iDMyScene()

@property (nonatomic,strong) SKSpriteNode *desired;
@property (nonatomic,strong) SKSpriteNode *player;
@property (nonatomic,strong) SKSpriteNode *enemy;

@property (nonatomic,strong) SKLabelNode *desiredTutorial;
@property (nonatomic,strong) SKLabelNode *playerTutorial;
@property (nonatomic,strong) SKLabelNode *enemyTutorial;
@property (nonatomic,strong) SKLabelNode *startTutorial;

@property (nonatomic,strong) SKLabelNode *score;

@property (nonatomic,strong) UIButton *share;

@property (nonatomic,strong) ADBannerView *advertisement;

@property (nonatomic,weak) UITouch *jinkTouch;

@property (nonatomic) NSString *avenir;

@property (nonatomic) CGPoint centre;
@property (nonatomic) CGPoint desiredOrigPoint;
@property (nonatomic) CGPoint playerOrigPoint;
@property (nonatomic) CGPoint enemyOrigPoint;

@property (nonatomic) CGSize blockSize;

@property (nonatomic) NSInteger scoreInt;

@property (nonatomic) BOOL gameRun;
@property (nonatomic) BOOL gameStart;
@property (nonatomic) CGFloat timeEnd;

@end


@implementation iDMyScene

-(void)didMoveToView:(SKView *)view {
    self.avenir = @"Avenir Next Medium";
    
    self.blockSize = CGSizeMake(self.scene.size.width/20,
                                self.scene.size.width/20);
    self.centre = CGPointMake(self.scene.size.width/2,
                              self.scene.size.height/2);
    
    self.scoreInt = 0;
    
    self.backgroundColor = [SKColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
    self.physicsWorld.gravity = CGVectorMake(0,0);
    
    self.desired = [SKSpriteNode spriteNodeWithColor:
                    [SKColor colorWithRed:0.2 green:1 blue:0.2 alpha:1]
                                                size:self.blockSize];
    self.desired.position = CGPointMake(self.centre.x,
                                        self.centre.y+self.blockSize.height*2);
    self.desired.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.desired.size];
    self.desired.physicsBody.dynamic = NO;
    
    self.desiredOrigPoint = self.desired.position;
    
    self.player = [SKSpriteNode spriteNodeWithColor:
                   [SKColor colorWithRed:1 green:1 blue:0.2 alpha:1]
                                               size:self.blockSize];
    self.player.position = self.centre;
    self.player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:
                               CGSizeMake(self.player.size.width-5,
                                          self.player.size.height-5)];
    self.player.physicsBody.allowsRotation = NO;
    
    self.playerOrigPoint = self.player.position;
    
    self.enemy = [SKSpriteNode spriteNodeWithColor:
                  [SKColor colorWithRed:1 green:0.2 blue:0.2 alpha:1]
                                              size:self.blockSize];
    self.enemy.position = CGPointMake(self.centre.x,
                                      self.centre.y-self.blockSize.height*2);
    self.enemy.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.enemy.size];
    self.enemy.physicsBody.allowsRotation = NO;
    
    self.enemyOrigPoint = self.enemy.position;
    
    [self addChild:self.desired];
    [self addChild:self.player];
    [self addChild:self.enemy];
    
    self.desiredTutorial = [SKLabelNode labelNodeWithFontNamed:self.avenir];
    self.desiredTutorial.position = CGPointMake(self.centre.x,
                                                self.scene.size.height/4*3+self.blockSize.height/2);
    self.desiredTutorial.text = @"get the green box fast";
    self.desiredTutorial.fontSize = self.blockSize.width * 1.2;
    
    self.playerTutorial = [SKLabelNode labelNodeWithFontNamed:self.avenir];
    self.playerTutorial.position = CGPointMake(self.centre.x,
                                               self.scene.size.height/3*2+self.blockSize.height/2);
    self.playerTutorial.text = @"the yellow box goes to your finger";
    self.playerTutorial.fontSize = self.blockSize.width * 1.2;
    
    self.enemyTutorial = [SKLabelNode labelNodeWithFontNamed:self.avenir];
    self.enemyTutorial.position = CGPointMake(self.centre.x,
                                              self.scene.size.height/4);
    self.enemyTutorial.text = @"avoid the red box";
    self.enemyTutorial.fontSize = self.blockSize.width * 1.2;
    
    self.startTutorial = [SKLabelNode labelNodeWithFontNamed:self.avenir];
    self.startTutorial.position = CGPointMake(self.centre.x,
                                              self.scene.size.height/4 - self.blockSize.height * 2);
    
    self.startTutorial.text = @"tap the top of the screen to start";
    self.startTutorial.fontSize = self.blockSize.width * 1.2;
    
    [self addChild:self.desiredTutorial];
    [self addChild:self.playerTutorial];
    [self addChild:self.enemyTutorial];
    [self addChild:self.startTutorial];
    
    self.share = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.share setTitleColor:[SKColor whiteColor] forState:UIControlStateNormal];
    [self.share setTitle:@"share" forState:UIControlStateNormal];
    [self.share addTarget:self action:@selector(share:) forControlEvents:UIControlEventTouchUpInside];
    self.share.frame = CGRectMake(self.desiredOrigPoint.x - self.scene.size.width / 30,
                                  self.desiredOrigPoint.y - self.scene.size.width / 6.5,
                                  self.scene.size.width / 2.5,
                                  self.scene.size.width / 10);
    self.share.titleLabel.font = [UIFont fontWithName:self.avenir size:self.blockSize.width * 2];
    self.share.hidden = YES;
    
    [view addSubview:self.share];
    
    self.timeEnd = 0.0;
    
    self.advertisement = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    self.advertisement.hidden = YES;
    [self.view addSubview:self.advertisement];
    
    self.gameStart = YES;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.jinkTouch = [touches anyObject];
    
    if (!self.gameRun) {
        self.gameRun = YES;
        self.timeEnd = 0.0;
        
        [self restartGame];
        
        [self.desiredTutorial removeFromParent];
        [self.playerTutorial removeFromParent];
        [self.enemyTutorial removeFromParent];
        [self.startTutorial removeFromParent];
    }
    
    self.gameStart = NO;
}

-(void)update:(CFTimeInterval)currentTime {
    const CGFloat endTimeAdditive = 3;
    
    if (self.gameRun) {
        if (self.timeEnd == 0.0) {
            self.timeEnd = currentTime + endTimeAdditive;
        } else if (currentTime >= self.timeEnd) {
            [self endGame];
        }
    }
    
    if (self.gameRun) {
        self.backgroundColor = [SKColor colorWithRed:0.4
                                               green:0.2 * (self.timeEnd - currentTime)
                                                blue:0.2 * (self.timeEnd - currentTime)
                                               alpha:1];
    } else {
        self.backgroundColor = self.backgroundColor;
    }
    
    if (self.jinkTouch) {
        [self movePlayer];
        [self enemyFollow];
    }else{
        self.player.physicsBody.velocity = CGVectorMake(0,0);
        self.enemy.physicsBody.velocity = CGVectorMake(0,0);
    }
    
    if ([self.player intersectsNode:self.desired]) {
        self.desired.position = CGPointMake(arc4random_uniform(self.scene.size.width/2) + self.scene.size.width/4,
                                            arc4random_uniform(self.scene.size.height/2) + self.scene.size.height/4);
        
        self.scoreInt += 1;
        self.timeEnd = currentTime + endTimeAdditive;
    }
    
    if ([self.player intersectsNode:self.enemy]) {
        [self endGame];
    }
    
    if (self.advertisement.bannerLoaded == NO || self.gameRun == YES || self.gameStart == YES) {
        self.advertisement.hidden = YES;
    } else if (self.advertisement.bannerLoaded == YES && self.gameRun == NO && self.gameStart == NO) {
        self.advertisement.hidden = NO;
    }
}

-(void) movePlayer {
    CGVector playerFingerDistance = CGVectorMake([self.jinkTouch locationInNode:self].x - self.player.position.x,
                                                 [self.jinkTouch locationInNode:self].y - self.player.position.y);
    self.player.physicsBody.velocity = CGVectorMake(playerFingerDistance.dx*5,
                                                    playerFingerDistance.dy*5);
}

-(void) enemyFollow {
    CGVector distanceLeft = CGVectorMake(self.player.position.x - self.enemy.position.x,
                                         self.player.position.y - self.enemy.position.y);
    self.enemy.physicsBody.velocity = CGVectorMake(distanceLeft.dx*5,
                                                   distanceLeft.dy*5);
}

-(void) restartGame {
    self.scoreInt = 0;
    self.gameRun = YES;
    
    [self.score removeFromParent];
    
    self.share.hidden = YES;
    
    self.scene.backgroundColor = [SKColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:1];
}

-(void) endGame {
    self.gameRun = NO;
    self.scene.backgroundColor = [SKColor colorWithRed:0.4 green:0.1 blue:0.1 alpha:1];
    
    self.player.physicsBody.velocity = CGVectorMake(0,0);
    self.enemy.physicsBody.velocity = CGVectorMake(0,0);
    
    self.desired.position = self.desiredOrigPoint;
    self.player.position = self.playerOrigPoint;
    self.enemy.position = self.enemyOrigPoint;
    
    self.jinkTouch = nil;
    
    self.share.hidden = NO;
    
    self.score = [SKLabelNode labelNodeWithFontNamed:self.avenir];
    self.score.fontSize = self.blockSize.width * 2;
    self.score.text = [NSString stringWithFormat:@"%ld", (long)self.scoreInt];
    self.score.position = CGPointMake(self.centre.x-self.blockSize.width*2,
                                      self.centre.y-self.blockSize.height/2);
    
    [self addChild:self.score];
    
    [self addChild:self.desiredTutorial];
    [self addChild:self.playerTutorial];
    [self addChild:self.enemyTutorial];
    [self addChild:self.startTutorial];
}

-(void) share:(id)sender {
    UIActivityViewController *activityViewController = [[UIActivityViewController alloc]
                                                        initWithActivityItems:@[[NSString stringWithFormat:
                                                                                 @"I scored %ld in hiJink! Find it here: https://appsto.re/us/-ahh1.i",
                                                                                 (long)self.scoreInt]]
                                                        applicationActivities:nil];
    
    [self.viewController presentViewController:activityViewController animated:YES completion:NULL];
}

@end