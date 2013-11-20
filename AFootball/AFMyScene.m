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
#import "T2DCamera.h"




@interface AFMyScene(){
    SKLabelNode *leafCountLabel;
    SKLabelNode *collideCountLabel;
    SKTextureAtlas *playerAtlas;
    NSMutableArray *playerRunUpTextures;
    NSMutableArray *playerRunDownTextures;
    T2DMap *map;
    
    CGPoint oldPointA;
    CGPoint oldPointB;
    SKNode *oldNodeA;
    SKNode *oldNodeB;
}

@end

@implementation AFMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self initAtlas];
        [self createLabel];
        [self assembleMap];
        
//        [self assembleBall];
        [self appendRandomPlayers];
    }
    return self;
}

- (void)assembleBall{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor greenColor] size:CGSizeMake(10, 10)];
    SKPhysicsBody *physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    [node  setPosition:CGPointMake(100, 200)];
    //    physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width/2, self.size.height/2)];
    [physicsBody setDynamic:YES];
    [physicsBody setCategoryBitMask:CategoryBall];
    [physicsBody setContactTestBitMask:CategoryWall];
    [physicsBody setCollisionBitMask:CategoryWall];
    [physicsBody setFriction:0.5];
//    [physicsBody setVelocity:CGPointMake(0, 0)];
    [physicsBody setRestitution:0.9];
    [physicsBody setMass:0.01];
    [physicsBody setLinearDamping:0.9];
    [node setPhysicsBody:physicsBody];
    [map addChild:node];
}

- (void)assembleMap{
    map = [[T2DMap alloc] initWithSize:CGSizeMake(320.0, 320.0) layerSize:CGSizeMake(256.0, 256.0)];
    [map setLargeBackgroundImageNamed:@"AFField"];
    [map positionInScreenCenter];
    [map setDelegate:self];
    [self addChild:map];
    [[self physicsWorld] setContactDelegate:map];
    [[self physicsWorld] setGravity:CGVectorMake(0, -9.8)];
    
//    T2DCamera *c = [[T2DCamera alloc] initWithMap:map];
    
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
    
    if (pos.y>100) {
        [node setVelocity:CGVectorMake([self randomVelocityScalar], -[self randomVelocityScalar])];
        [node playAnimation:playerRunDownTextures repeat:YES];
    }else{
        [node setVelocity:CGVectorMake([self randomVelocityScalar], [self randomVelocityScalar])];
//        TLOG(@"mass -> %f area -> %f", [node physicsBody].mass, [node physicsBody].area);
//        [[node physicsBody] applyImpulse:CGPointMake(0, 50)];
        [node playAnimation:playerRunUpTextures repeat:YES];
    }
    
    
    [map addNode:node];
    
    
    [self updateLabel];
}

- (void)updateLabel{
    [leafCountLabel setText:[NSString stringWithFormat:@"leaf:%d",[map leafCount]]];
}


- (void)reverseUpDownForNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    AFPlayerNode *playerNode = (AFPlayerNode *)node;
    if ([self isMovingUp:body]) {
        [playerNode setVelocity:CGVectorMake(body.velocity.dx, -[self randomVelocityScalar])];
        [playerNode playAnimation:playerRunDownTextures repeat:YES];
    }else{
        [playerNode setVelocity:CGVectorMake(body.velocity.dx, [self randomVelocityScalar])];
        [playerNode playAnimation:playerRunUpTextures repeat:YES];
    }
}


- (BOOL)isMovingUp:(SKPhysicsBody *)body{
    if (body.velocity.dy > 0)  return YES;
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
//    return 0;
    return (arc4random() % 20) + 20;
}

- (void)appendRandomPlayers{
    
    if ([map leafCount]>0)  return;
    
    int leafCount = 5;
    CGRect bgFrame = [map largeBackgroundFrame];
    CGFloat bgX = bgFrame.origin.x;
//    CGFloat bgW = bgFrame.size.width;
    CGFloat bgH = bgFrame.size.height;
//    TLOG(@"bgW -> %f", bgW);
    for (int i=0; i<leafCount; i++) {
        CGFloat playerX = bgX+24*i+12;
        CGFloat offsetY = 2;
        
        [self appendPlayer:CGPointMake(playerX, 12+offsetY)];
//        [self appendPlayer:CGPointMake(playerX, (24+offsetY))];
        [self appendPlayer:CGPointMake(playerX, bgH-(16+offsetY))];
        
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
        
//        AFPlayerNode *node = (AFPlayerNode *)[map touchedNode:touch];
//        SKPhysicsBody *body = [node physicsBody];
//        [[node physicsBody] setVelocity:CGPointMake(0, 10)];
//        [body applyImpulse:CGPointMake(0, 0.404)];
//        [body applyForce:CGPointMake(0, 0.04)];
//        TLOG(@"touchedNode %@", );

        [self appendRandomPlayers];
    }
}

#pragma mark -

- (void)didSimulatePhysics{
    [map didSimulatePhysics];
}


#pragma mark - T2DMapDelegate

- (void)mapWallBContactNode:(T2DNode *)node{
//    TLOG(@"");
     [self reverseUpDownForNode:node];
}

- (void)mapWallTContactNode:(T2DNode *)node{
//     TLOG(@"");
    [self reverseUpDownForNode:node];
}

- (void)mapWallLContactNode:(T2DNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    AFPlayerNode *playerNode = (AFPlayerNode *)node;
    [playerNode setVelocity:CGVectorMake(-[self randomVelocityScalar], body.velocity.dy)];
}

- (void)mapWallRContactNode:(T2DNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    AFPlayerNode *playerNode = (AFPlayerNode *)node;
    [playerNode setVelocity:CGVectorMake([self randomVelocityScalar], body.velocity.dy)];
}




- (void)mapContactPlayersBetweenNodeA:(T2DNode *)nodeA andNodeB:(T2DNode *)nodeB{
    
//    [nodeA setPaused:YES];
//    [self setPaused:YES];
    
//    TLOG(@"mapContactPlayersBetweenNodeA");
//    [[nodeA physicsBody] setVelocity:CGPointZero];
//    [[nodeB physicsBody] setVelocity:CGPointZero];
    
//    [nodeA setPosition:[nodeA position]];
//    [nodeB setPosition:[nodeB position]];
    
//    oldPointA = [nodeA position];
//    oldPointB = [nodeB position];
//    
//    oldNodeA = nodeA;
//    oldNodeB = nodeB;
//    TLOG(@"desity->%f", [nodeA physicsBody].density);
//    if ([self isMovingUp:[nodeA physicsBody]]) {
//        [[nodeB physicsBody] applyForce:CGPointMake(0, 10)];
//    }
//    
//    if ([self isMovingUp:[nodeB physicsBody]]) {
//        [[nodeA physicsBody] applyForce:CGPointMake(0, 10)];
//    }
//    [self restoreLastContact];
//    [self performSelector:@selector(restoreLastContact) withObject:self afterDelay:1];
    
//    float distanceY =  nodeB.position.y - nodeA.position.y;
//    TLOG(@"distanceY %f", distanceY);
//    [self reverseUpDownForNode:nodeA];
//    [self reverseUpDownForNode:nodeB];
}



#pragma mark - 




@end
