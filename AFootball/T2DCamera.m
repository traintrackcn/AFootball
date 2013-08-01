//
//  T2DCamera.m
//  AFootball
//
//  Created by traintrackcn on 13-8-1.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "T2DCamera.h"
#import "QTreeLeaf.h"
#import "T2DMap.h"
#import "T2DNode.h"

@interface T2DCamera (){
    BOOL zooming;
    BOOL moving;
    CGFloat targetScale;
    T2DMap *map;
    SKNode *layer;
}

@end

@implementation T2DCamera

- (id)initWithMap:(T2DMap *)aMap{
    self = [super init];
    if (self) {
        map = aMap;
        layer = [aMap layer];
    }
    return self;
}

- (CGPoint)focusPoint{
    NSArray *leafs = [[QTreeRoot sharedInstance] registeredLeafs];
    float xMax, xMin, yMax, yMin;
    QTreeLeaf *leaf;
    T2DNode *sprite;
    if ([leafs count]==0) {
        targetScale = [map scale];
        return [map layerCenter];
    }
    
    if ([leafs count] == 1) {
        leaf = [leafs objectAtIndex:0];
        sprite = [map nodeForKey:[leaf key]];
        targetScale = [map scale];
        return [sprite position];
    }
    
    int lastIdx = [leafs count] - 1;
    int idx = 0;
    
    while (idx <= lastIdx) {
        leaf = [leafs objectAtIndex:idx];
        sprite = [map nodeForKey:[leaf key]];
        CGPoint pos = [sprite position];
        
        if (idx == 0) {
            xMax = pos.x;
            xMin = pos.x;
            yMax = pos.y;
            yMin = pos.y;
        }else{
            xMax = MAX(xMax, pos.x);
            xMin = MIN(xMin, pos.x);
            yMax = MAX(yMax, pos.y);
            yMin = MIN(yMin, pos.y);
        }
        
        idx ++;
    }
    
    
    // a little bit more focus area
    float offset = 30;
    xMax += offset;
    xMin -= offset;
    yMax += offset;
    yMin -= offset;
    
    float x = (xMax-xMin)/2.0 + xMin;
    float y = (yMax - yMin)/2.0 + yMin;
    CGSize mapSize = [map size];
    float distanceX = ABS(xMax-xMin);
    float distanceY = ABS(yMax - yMin);
    float scaleX = mapSize.width/distanceX;
    float scaleY = mapSize.height/distanceY;
    //    TLOG(@"scaleX %f  mapSize.width %f distanceX %f", scaleX, mapSize.width, distanceX);
    targetScale = scaleX>scaleY?scaleY:scaleX;
    //    TLOG(@"targetScale %f fixedTargetScalle %f", targetScale, floorf(targetScale*2)/2);
    int step = 3;
    targetScale = floorf(targetScale*step)/step;
    
    
    return CGPointMake(x, y);
}

- (BOOL)needFocus{
    CGPoint p2 = [map layerPositionForCenterPoint:[self focusPoint]];
    CGPoint p1 = [[map layer] position];
    CGFloat xDist = (p2.x - p1.x); //[2]
    CGFloat yDist = (p2.y - p1.y); //[3]
    CGFloat distance = sqrt((xDist * xDist) + (yDist * yDist)); //[4]
    //    TLOG(@"distance -> %f", distance);
    if (distance >= 10) {
        return YES;
    }
    return NO;
}


- (void)focusAction{
    //    return;
    CGPoint targetLayerPos = [map layerPositionForCenterPoint:[self focusPoint]];
    [map setLayerPosition:targetLayerPos];
    
    //    if (![self needFocus]) return;
    //    if (cameraMoving) return;
    //    cameraMoving = YES;
    //    CGPoint targetLayerPos = [self baseLayerPositionForCenterPoint:[self groupCenter]];
    //    CGFloat duration = .5;
    //    SKAction *action = [SKAction moveTo:targetLayerPos duration:duration];
    //    [action setTimingMode:SKActionTimingEaseOut];
    //    [baseLayer runAction:action completion:^{
    //        cameraMoving = NO;
    //    }];
}

- (void)update{
    [self focusAction];
    [self zoomAction];
}

- (BOOL)needZoom{
    
    if (targetScale != [map scale]) {
        return YES;
    }
    return NO;
}

- (void)zoomAction{
    if (![self needZoom]) return;
    if (zooming) return;
    
    zooming = YES;
    CGFloat tmpTargetScale = targetScale;
    CGFloat tmpScale = [map scale];
    CGFloat scaleOffset = (tmpTargetScale - tmpScale);
    //    TLOG(@"zoomAction targetScale -> %f [self scale] -> %f", targetScale,[self scale]);
    CGFloat duration = 0.8;
    SKAction *action = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        CGFloat percent = elapsedTime/duration;
        CGFloat scale = scaleOffset*percent+tmpScale;
        [map setScale:scale];
    }];
    [action setTimingMode:SKActionTimingEaseOut];
    
    [layer runAction:action completion:^{
        zooming = NO;
    }];
    
    //    [self setScale:targetScale];
}

//- (T2DMap *)map{
//    return [_delegate mapOfCamera];
//}
//
//- (SKNode *)layer{
//    return [map layer];
//}

@end
