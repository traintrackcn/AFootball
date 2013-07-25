//
//  AFPlayerSprite.h
//  AFootball
//
//  Created by traintrackcn on 13-7-24.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AFPlayerNode : SKNode

- (id)initWithSize:(CGSize)size;
- (void)setVelocity:(CGPoint)velocity;
- (void)playAnimation:(NSArray *)textures repeat:(BOOL)repeat;
//- (void)size;
- (CGSize)size;
- (CGSize)physicsSize;

@property (nonatomic, strong) SKSpriteNode *skinNode;

@end
