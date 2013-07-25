//
//  T2DMap.h
//  AFootball
//
//  Created by traintrackcn on 13-7-23.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "QTreeRoot.h"

@protocol T2DMapDelegate <NSObject>

@optional
- (void)mapWallLContactNode:(SKNode *)node;
- (void)mapWallRContactNode:(SKNode *)node;
- (void)mapWallTContactNode:(SKNode *)node;
- (void)mapWallBContactNode:(SKNode *)node;

- (void)mapContactPlayersBetweenNodeA:(SKNode *)nodeA andNodeB:(SKNode *)nodeB;

@end

@interface T2DMap : SKCropNode <QTreeDelegate, SKPhysicsContactDelegate>

- (id)initWithSize:(CGSize)aSize treeSize:(CGSize)aTreeSize;
- (void)setLargeBackgroundImageNamed:(NSString *)imageName;
- (void)positionInScreenCenter;
- (CGFloat)scale;
- (int)leafCount;
- (void)addNode:(SKNode *)node;

- (void)didSimulatePhysics;

- (SKNode *)touchedNode:(UITouch *)touch;

@property (nonatomic, weak) id<T2DMapDelegate> delegate;

@property (nonatomic, assign) CGRect largeBackgroundFrame;

@end
