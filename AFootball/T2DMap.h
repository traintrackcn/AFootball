//
//  T2DMap.h
//  AFootball
//
//  Created by traintrackcn on 13-7-23.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "QTreeRoot.h"

@class T2DNode;

@protocol T2DMapDelegate <NSObject>

@optional
- (void)mapWallLContactNode:(T2DNode *)node;
- (void)mapWallRContactNode:(T2DNode *)node;
- (void)mapWallTContactNode:(T2DNode *)node;
- (void)mapWallBContactNode:(T2DNode *)node;

- (void)mapContactPlayersBetweenNodeA:(T2DNode *)nodeA andNodeB:(T2DNode *)nodeB;

@end

@interface T2DMap : SKCropNode <QTreeDelegate, SKPhysicsContactDelegate>

- (id)initWithSize:(CGSize)aSize layerSize:(CGSize)aLayerSize;
- (void)setLargeBackgroundImageNamed:(NSString *)imageName;
- (void)positionInScreenCenter;
- (int)leafCount;
- (CGSize)size;

#pragma mark - camera operators

- (void)assembleCamera;

#pragma mark - layer operators
- (CGPoint)layerCenter;
- (void)setLayerPosition:(CGPoint)pos;
- (SKNode *)layer;

- (void)addNode:(T2DNode *)node;
- (T2DNode *)nodeForKey:(NSString *)key;
- (void)removeNodeForKey:(NSString *)key;

- (void)didSimulatePhysics;

- (CGPoint)layerPositionForCenterPoint:(CGPoint)pos;
- (CGFloat)scale;
- (void)setScale:(CGFloat)scale;

- (T2DNode *)touchedNode:(UITouch *)touch;

@property (nonatomic, weak) id<T2DMapDelegate> delegate;

@property (nonatomic, assign) CGRect largeBackgroundFrame;

@end
