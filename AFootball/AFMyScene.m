//
//  AFMyScene.m
//  AFootball
//
//  Created by traintrackcn on 13-7-15.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "AFMyScene.h"
#import "T2DMap.h"
#import "AFPlayerNode.h"




@interface AFMyScene(){
    SKLabelNode *leafCountLabel;
    SKLabelNode *collideCountLabel;
    SKTextureAtlas *playerAtlas;
    NSMutableArray *playerRunUpTextures;
    NSMutableArray *playerRunDownTextures;
    T2DMap *map;
}

@end

@implementation AFMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self initAtlas];
        [self createLabel];
        [self assembleMap];
    }
    return self;
}

- (void)assembleMap{
    map = [[T2DMap alloc] initWithSize:CGSizeMake(320.0, 320.0) treeSize:CGSizeMake(256.0, 256.0)];
    [map setLargeBackgroundImageNamed:@"AFField"];
    [map positionInScreenCenter];
    [map setDelegate:self];
    [self addChild:map];
    [[self physicsWorld] setContactDelegate:map];
    
}

- (void)initAtlas{
    playerRunUpTextures = [NSMutableArray array];
    playerRunDownTextures = [NSMutableArray array];
    for (int i=0; i<7; i++) {
//         SKTexture *t = [playerAtlas textureNamed:[NSString stringWithFormat:@"linkRunUp_%d",i] ];
        SKTexture *t = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"linkRunUp_%d",i] ];
        SKTexture *t1 = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"linkRunDown_%d",i] ];
//        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"linkRunUp_%d",i]];
//        SKTexture *t = [SKTexture textureWithImageNamed:[NSString stringWithFormat:@"linkRunUp_%d",i]];
//        TLOG(@"t %@  w %f h:%f ",t, t.size.width, t.size.height);
        [playerRunUpTextures addObject:t];
        [playerRunDownTextures addObject:t1];
    }

    
//    SKTexture *t1 = [SKTexture textureWithImageNamed:@"tmp-6"];
//    TLOG(@"t1 -> %@", t1);
}



- (void)createLabel{
    leafCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Ariel"];
    leafCountLabel.fontSize = 14;
    leafCountLabel.position = CGPointMake(50,40);
    [self addChild:leafCountLabel];
    
    collideCountLabel = [SKLabelNode labelNodeWithFontNamed:@"Ariel"];
    collideCountLabel.fontSize = 14;
    collideCountLabel.position = CGPointMake(50,60);
    [self addChild:collideCountLabel];
}



#pragma mark - leaf operators


- (void)appendPlayer:(CGPoint)pos{
    AFPlayerNode *node = [[AFPlayerNode alloc] initWithSize:CGSizeMake(16.0, 24.0)];
    [node setPosition:pos];
    [node setVelocity:CGPointMake([self randomVelocityScalar], [self randomVelocityScalar])];
    [map addNode:node];
    [node playAnimation:playerRunUpTextures repeat:YES];
    
    [self updateLabel];
}

- (void)updateLabel{
    [leafCountLabel setText:[NSString stringWithFormat:@"leaf:%d",[map leafCount]]];
}


- (void)reverseUpDownForNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    AFPlayerNode *playerNode = (AFPlayerNode *)node;
    if ([self isMovingUp:body]) {
        [playerNode setVelocity:CGPointMake(body.velocity.x, -[self randomVelocityScalar])];
        [playerNode playAnimation:playerRunDownTextures repeat:YES];
    }else{
        [playerNode setVelocity:CGPointMake(body.velocity.x, [self randomVelocityScalar])];
        [playerNode playAnimation:playerRunUpTextures repeat:YES];
    }
}


- (BOOL)isMovingUp:(SKPhysicsBody *)body{
    if (body.velocity.y > 0)  return YES;
    return NO;
}

//- (void)logLeafsDetails{
//    NSArray *leafs = [[QTreeRoot sharedInstance] registeredLeafs];
//    for (int i=0; i<[leafs count]; i++) {
//        QTreeLeaf *leaf = [leafs objectAtIndex:i];
//        TLOG(@"leaf parents -> %@", [leaf allParentsKeys]);
//    }
//    TLOG(@"------------------------------");
//}

- (CGFloat)randomVelocityScalar{
    return (arc4random() % 20) + 10;
}

- (void)appendRandomPlayers{
    
    if ([map leafCount]>0)  return;
    
    CGPoint location = CGPointZero;
    int leafCount = 10;
    CGRect bgFrame = [map largeBackgroundFrame];
    int bgW = bgFrame.size.width;
    for (int i=0; i<leafCount; i++) {
        location.x = arc4random()% bgW + bgFrame.origin.x;
        location.y = arc4random()%240+6;
        [self appendPlayer:location];
    }
}

#pragma mark - touch actions

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    for (UITouch *touch in touches) {
        int tapCount = [touch tapCount];
        if (tapCount == 2) {
            return;
        }
        
//        CGPoint location = [touch locationInNode:self];

        [self appendRandomPlayers];
    }
}

#pragma mark -

- (void)didSimulatePhysics{
    [map didSimulatePhysics];
}


#pragma mark - T2DMapDelegate

- (void)mapWallBContactNode:(SKNode *)node{
//    SKPhysicsBody *body = [node physicsBody];
//    AFPlayerNode *playerNode = (AFPlayerNode *)node;
//    [playerNode setVelocity:CGPointMake(body.velocity.x, [self randomVelocityScalar])];
//    [playerNode playAnimation:playerRunUpTextures repeat:YES];
    
     [self reverseUpDownForNode:node];
}

- (void)mapWallTContactNode:(SKNode *)node{
//    SKPhysicsBody *body = [node physicsBody];
//    AFPlayerNode *playerNode = (AFPlayerNode *)node;
//    [playerNode setVelocity:CGPointMake(body.velocity.x, -[self randomVelocityScalar])];
//    [playerNode playAnimation:playerRunDownTextures repeat:YES];
    
    [self reverseUpDownForNode:node];
}

- (void)mapWallLContactNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    AFPlayerNode *playerNode = (AFPlayerNode *)node;
    [playerNode setVelocity:CGPointMake(-[self randomVelocityScalar], body.velocity.y)];
}

- (void)mapWallRContactNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    AFPlayerNode *playerNode = (AFPlayerNode *)node;
    [playerNode setVelocity:CGPointMake([self randomVelocityScalar], body.velocity.y)];
}

- (void)mapContactPlayersBetweenNodeA:(SKNode *)nodeA andNodeB:(SKNode *)nodeB{
//    [self reverseUpDownForNode:nodeA];
//    [self reverseUpDownForNode:nodeB];
}



#pragma mark - 




@end
