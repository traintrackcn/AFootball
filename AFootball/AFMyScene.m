//
//  AFMyScene.m
//  AFootball
//
//  Created by traintrackcn on 13-7-15.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "AFMyScene.h"
#import "T2DMap.h"


static const uint32_t leafCategory        =  0x1 << 0;
static const uint32_t otherCategory        =  0x1 << 1;

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

- (CGFloat)randomVelocityScalar{
    return (arc4random() % 20) + 10;
}

- (void)appendNode:(CGPoint)pos{

    SKSpriteNode *node = [SKSpriteNode spriteNodeWithColor:[UIColor blueColor] size:CGSizeMake(16.0, 24.0)];
    node.position = pos;
    
    //setup physics body
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    [body setAffectedByGravity:NO];
    [body setDynamic:YES];
    [body setAllowsRotation:NO];
    [body setCategoryBitMask:leafCategory];
    [body setContactTestBitMask:leafCategory];
    [body setCollisionBitMask:otherCategory];
    CGPoint v;
    v.x = [self randomVelocityScalar];
    v.y = [self randomVelocityScalar];
    [body setVelocity:v];
    [body setFriction:0];
    [body setLinearDamping:0];
//    [body setRestitution:1];
    //    [node setScale:0.1];
    //    [node setPaused:YES];
    //    [node setHidden:YES];
//    [node setZRotation:[leaf angle]];   // minus M_PI_2 to fix spirte rotation
    
    [node setPhysicsBody:body];
    
    [map addNode:node];
    [leafCountLabel setText:[NSString stringWithFormat:@"leaf:%d",[map leafCount]]];
    
    //actions
    
    [self swichLeafAnimation:node towardsUp:YES];
    
}


- (void)swichLeafAnimation:(SKSpriteNode *)node towardsUp:(BOOL)towardsUp{
    SKAction *walkAnimation;
    [node removeActionForKey:@"animation"];
    if (towardsUp) {
        walkAnimation = [SKAction animateWithTextures:playerRunUpTextures timePerFrame:0.1];
    }else{
        walkAnimation = [SKAction animateWithTextures:playerRunDownTextures timePerFrame:0.1];
    }
    walkAnimation = [SKAction repeatActionForever:walkAnimation];
    [node runAction:walkAnimation withKey:@"animation"];
}

//- (void)logLeafsDetails{
//    NSArray *leafs = [[QTreeRoot sharedInstance] registeredLeafs];
//    for (int i=0; i<[leafs count]; i++) {
//        QTreeLeaf *leaf = [leafs objectAtIndex:i];
//        TLOG(@"leaf parents -> %@", [leaf allParentsKeys]);
//    }
//    TLOG(@"------------------------------");
//}

- (void)appendRandomLeaf{
    
    if ([map leafCount]>0)  return;
    
    CGPoint location = CGPointZero;
    int leafCount = 10;
    CGRect bgFrame = [map largeBackgroundFrame];
    int bgW = bgFrame.size.width;
    for (int i=0; i<leafCount; i++) {
        location.x = arc4random()% bgW + bgFrame.origin.x;
        location.y = arc4random()%240+6;
        [self appendNode:location];
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

        [self appendRandomLeaf];
    }
}

#pragma mark -

- (void)didSimulatePhysics{
    [map didSimulatePhysics];
}


#pragma mark - T2DMapDelegate

- (void)mapWallBContactNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    body.velocity = CGPointMake(body.velocity.x, [self randomVelocityScalar]);
    [self swichLeafAnimation:(SKSpriteNode *)node towardsUp:YES];
}

- (void)mapWallTContactNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    body.velocity = CGPointMake(body.velocity.x, -[self randomVelocityScalar]);
    [self swichLeafAnimation:(SKSpriteNode *)node towardsUp:NO];
    
}

- (void)mapWallLContactNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    body.velocity = CGPointMake(-[self randomVelocityScalar], body.velocity.y);
}

- (void)mapWallRContactNode:(SKNode *)node{
    SKPhysicsBody *body = [node physicsBody];
    body.velocity = CGPointMake([self randomVelocityScalar], body.velocity.y);
}




@end
