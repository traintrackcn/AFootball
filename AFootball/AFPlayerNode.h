//
//  AFPlayerSprite.h
//  AFootball
//
//  Created by traintrackcn on 13-7-24.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface AFPlayerNode : SKSpriteNode

- (id)initWithSize:(CGSize)size;
- (void)setVelocity:(CGPoint)velocity;
- (void)playAnimation:(NSArray *)textures repeat:(BOOL)repeat;


@property (nonatomic, strong) SKNode *standNode;

@end
