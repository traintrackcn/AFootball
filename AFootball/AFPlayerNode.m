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
}

@end

@implementation AFPlayerNode

- (id)initWithSize:(CGSize)size{
    self = [super initWithColor:[UIColor blueColor] size:size];
    if (self) {
        [self assemblePhysicsBody];
        
//        TLOG(@"anchor -> %f %f", [self anchorPoint].x, [self anchorPoint].y);
    }
    return self;
}

- (void)assemblePhysicsBody{
    physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.size];
    [physicsBody setAffectedByGravity:NO];
    [physicsBody setDynamic:YES];
    [physicsBody setAllowsRotation:NO];
    [physicsBody setCategoryBitMask:CategoryPlayer];
    [physicsBody setContactTestBitMask:CategoryPlayer|CategoryWall];
    [physicsBody setCollisionBitMask:CategoryNull];
    [physicsBody setFriction:0];
    [physicsBody setVelocity:CGPointMake(0, 0)];
    [physicsBody setLinearDamping:0];
    [self setPhysicsBody:physicsBody];
}

- (void)setVelocity:(CGPoint)velocity{
    [physicsBody setVelocity:velocity];
}

- (void)playAnimation:(NSArray *)textures repeat:(BOOL)repeat{
//    return;
    [self removeActionForKey:@"animation"];
    SKAction *anim;
    anim = [SKAction animateWithTextures:textures timePerFrame:0.1];
    if (repeat) anim = [SKAction repeatActionForever:anim];
    [self runAction:anim withKey:@"animation"];
}

//- (void)assembleStand{
//    float w = [self size].width;
//    float h = 6;
//    _standNode = [[AFStandNode alloc] initWithSize:CGSizeMake(w, h)];
//    [_standNode setPosition:CGPointMake(0, -8)];
//    [self addChild:_standNode];
//}


@end
