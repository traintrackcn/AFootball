//
//  AFPlayerSprite.m
//  AFootball
//
//  Created by traintrackcn on 13-7-24.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "AFPlayerNode.h"
#import "AFCategory.h"

@interface AFPlayerNode(){
    SKPhysicsBody *physicsBody;
    CGSize skinSize;
    CGSize physicsSize;
    CGSize physicsFixedSize; // produce more accurate collisions
}

@end

@implementation AFPlayerNode

- (id)initWithSize:(CGSize)size{
    skinSize = size;
    physicsSize = CGSizeMake(skinSize.width, skinSize.height-14.0);
    physicsFixedSize = CGSizeMake(physicsSize.width-3.0, physicsSize.height-3.0);
    self = [super init];
    if (self) {
        [self assemblePhysicsBody];
        [self assembleSkin];
//        [self assemblePhysicsHelper];

    }
    return self;
}

- (void)assemblePhysicsHelper{
    SKSpriteNode *helper = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:physicsSize];
    [helper setAlpha:0.5];
    [self addChild:helper];
}

- (void)assemblePhysicsBody{
//    physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:physicsFixedSize];
    [physicsBody setAffectedByGravity:NO];
    [physicsBody setDynamic:YES];
    [physicsBody setAllowsRotation:NO];
    [physicsBody setCategoryBitMask:CategoryPlayer];
    [physicsBody setContactTestBitMask:CategoryPlayer|CategoryWall];
//    [physicsBody setCollisionBitMask:CategoryPlayer|CategoryWall];
    [physicsBody setCollisionBitMask:CategoryNull];
    [physicsBody setFriction:0];
    [physicsBody setVelocity:CGPointMake(0, 0)];
    [physicsBody setLinearDamping:0];
//    [physicsBody setUsesPreciseCollisionDetection:YES];
    [self setPhysicsBody:physicsBody];
}

- (void)setVelocity:(CGPoint)velocity{
    [physicsBody setVelocity:velocity];
}

- (void)assembleSkin{
    _skinNode = [SKSpriteNode spriteNodeWithColor:[UIColor purpleColor] size:skinSize];
    [_skinNode setPosition:CGPointMake(0, (skinSize.height - physicsSize.height)/2)];
//    [_skinNode setAlpha:0.5];
    [self addChild:_skinNode];
}

- (void)playAnimation:(NSArray *)textures repeat:(BOOL)repeat{
//    return;
    [self removeActionForKey:@"animation"];
    SKAction *anim;
    anim = [SKAction animateWithTextures:textures timePerFrame:0.1];
    if (repeat) anim = [SKAction repeatActionForever:anim];
    [_skinNode runAction:anim withKey:@"animation"];
}

#pragma mark - properties

- (CGSize)size{
    return skinSize;
}

- (CGSize)physicsSize{
    return physicsSize;
}


@end
