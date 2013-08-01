//
//  T2DMap.h
//  AFootball
//
//  Created by traintrackcn on 13-7-23.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "QTreeRoot.h"

@class T2DMapNode;

@protocol T2DMapDelegate <NSObject>

@optional
- (void)mapWallLContactNode:(T2DMapNode *)node;
- (void)mapWallRContactNode:(T2DMapNode *)node;
- (void)mapWallTContactNode:(T2DMapNode *)node;
- (void)mapWallBContactNode:(T2DMapNode *)node;

- (void)mapContactPlayersBetweenNodeA:(T2DMapNode *)nodeA andNodeB:(T2DMapNode *)nodeB;

@end

@interface T2DMap : SKCropNode <QTreeDelegate, SKPhysicsContactDelegate>

- (id)initWithSize:(CGSize)aSize treeSize:(CGSize)aTreeSize;
- (void)setLargeBackgroundImageNamed:(NSString *)imageName;
- (void)positionInScreenCenter;
- (CGFloat)scale;
- (int)leafCount;
- (void)addNode:(T2DMapNode *)node;

- (void)didSimulatePhysics;

- (T2DMapNode *)touchedNode:(UITouch *)touch;

@property (nonatomic, weak) id<T2DMapDelegate> delegate;

@property (nonatomic, assign) CGRect largeBackgroundFrame;

@end
