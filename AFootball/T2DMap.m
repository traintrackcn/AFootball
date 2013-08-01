//
//  T2DMap.m
//  AFootball
//
//  Created by traintrackcn on 13-7-23.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "T2DMap.h"
#import "AFPlayerNode.h"

@interface T2DMap(){
    SKSpriteNode *maskNode;
    SKNode *baseLayer;
    SKNode *backgroundLayer;
    SKNode *treeLayer;
    SKNode *leafLayer;
    CGFloat targetScale;
    CGFloat _scale;
    CGSize treeSize; // w == h && power of 2
    CGSize mapSize;
    NSMutableDictionary *nodes;
    BOOL cameraZooming;
    BOOL cameraMoving;
}

@end

@implementation T2DMap

#pragma mark - init

- (id)initWithSize:(CGSize)aSize treeSize:(CGSize)aTreeSize{
    self = [super init];
    if (self) {
        mapSize = aSize;
        treeSize = aTreeSize;
        nodes = [NSMutableDictionary dictionary];
        [self assembleLayers];
        [self assembleTreeRoot];
        [self setScale:1];
    }
    return self;
}

#pragma mark - layers

- (void)assembleLayers{
    [self assembleCropMask];
    [self assembleBaseLayer];
    [self assembleBackgroundLayer];
    [self assembleTreeLayer];
    [self assembleLeafLayer];
}

- (void)assembleCropMask{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
     maskNode = [SKSpriteNode spriteNodeWithColor:[UIColor blackColor] size:CGSizeMake(screenSize.width,screenSize.width)];
    [maskNode setPosition:CGPointMake(maskNode.size.width/2, maskNode.size.height/2)];
    [self addChild:maskNode];
    [self setMaskNode:maskNode];
}

- (void)assembleBaseLayer{
    baseLayer = [[SKNode alloc] init];
    [self addChild:baseLayer];
}

- (void)assembleBackgroundLayer{
    backgroundLayer = [[SKNode alloc] init];
    [baseLayer addChild:backgroundLayer];
}

//qtree testing helper
- (void)assembleTreeLayer{
    treeLayer = [[SKNode alloc] init];
    [baseLayer addChild:treeLayer];
}

- (void)assembleLeafLayer{
    leafLayer = [[SKNode alloc] init];
    [baseLayer addChild:leafLayer];
}


- (void)assembleTreeRoot{
    CGRect treeFrame = CGRectZero;
    treeFrame.size = treeSize;
    [[QTreeRoot sharedInstance] generateWithFrame:treeFrame];
    [[QTreeRoot sharedInstance] setDelegate:self];
    [self addNodeForTree:[[QTreeRoot sharedInstance] root]];
}


#pragma mark - properties

- (SKNode *)baseLayer{
    return baseLayer;
}

- (void)setScale:(CGFloat)scale{
    _scale = scale;
    [baseLayer setScale:scale];
}

- (CGFloat)scale{
    return _scale;
}

- (void)setLargeBackgroundImageNamed:(NSString *)imageName{
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:imageName];
    [backgroundLayer addChild:sprite];
    CGPoint pos = CGPointMake(treeSize.width/2.0, treeSize.height/2.0);
    [sprite setPosition:pos];
    
    CGSize bgImgSize = [UIImage imageNamed:imageName].size;
    CGRect treeFrame = [[[QTreeRoot sharedInstance] root] frame];
    float bgX = (treeFrame.size.width - bgImgSize.width)/2;
    float bgY = treeFrame.origin.y;
    float bgW = bgImgSize.width;
    float bgH = treeFrame.size.height;
    
    _largeBackgroundFrame = CGRectMake(bgX, bgY, bgW, bgH);
    
    [self assembleLargeBackgroundWall];
}


- (void)assembleLargeBackgroundWall{
    float x = _largeBackgroundFrame.origin.x;
    float y = _largeBackgroundFrame.origin.y;
    float w = _largeBackgroundFrame.size.width;
    float h = _largeBackgroundFrame.size.height;
    // assemble walls
    CGPoint startL = CGPointMake(x+w, y);
    CGPoint endL = CGPointMake(x+w, y+h);
    CGPoint startT = CGPointMake(x, y+h);
    CGPoint endT = CGPointMake(x+w, y+h);
    CGPoint startR = CGPointMake(x, y);
    CGPoint endR = CGPointMake(x, y+h);
    CGPoint startB = CGPointMake(x, y);
    CGPoint endB = CGPointMake(x+w, y);
    
    
    SKPhysicsBody *body;
    SKNode *node;
    
    
    for (int i=0; i<4; i++) {
        CGPoint start;
        CGPoint end;
        NSString *wallName;
        
        switch (i) {
            case 0:
                start = startL;
                end = endL;
                wallName = @"wallL";
                break;
            case 1:
                start = startR;
                end = endR;
                wallName = @"wallR";
                break;
            case 2:
                start = startT;
                end = endT;
                wallName = @"wallT";
                break;
            case 3:
                start = startB;
                end = endB;
                wallName = @"wallB";
                break;
        }
        
        node = [SKNode node];
        [node setName:wallName];
        body = [SKPhysicsBody bodyWithEdgeFromPoint:start toPoint:end];
        [body setCategoryBitMask:CategoryWall];
        [body setDynamic:NO];
//        [body setUsesPreciseCollisionDetection:YES];
        [node setPhysicsBody:body];
        [backgroundLayer addChild:node];
    }
}

- (int)leafCount{
    return [[[QTreeRoot sharedInstance] registeredLeafs] count];
}

#pragma mark - position

- (void)positionInScreenCenter{
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGPoint mapPos = CGPointMake((screenSize.width - maskNode.size.width)/2, (screenSize.height - maskNode.size.height)/2);
    [self setPosition:mapPos];
}

#pragma mark - aabb methods

- (void)didSimulatePhysics{
    [self update];
    [self focusAction];
    [self zoomAction];
}

- (void)update{
    NSArray *leafs = [[QTreeRoot sharedInstance] registeredLeafs];
    for (int i=0; i<[leafs count];i++) {
        QTreeLeaf *leaf = [leafs objectAtIndex:i];
        T2DMapNode *node = [self nodeForKey:[leaf key]];
//        if ([node physicsBody].velocity.y!=0) {
//            [[node physicsBody] applyForce:CGPointMake(0, 0.04)];
//            TLOG(@"velocity %f", node.physicsBody.velocity.y);
//        }
        [self updateAABBForLeaf:leaf];
        [self updateZPositionForNode:node];
    }
}

- (void)updateAABBForLeaf:(QTreeLeaf *)leaf{
    T2DMapNode *node = [self nodeForKey:[leaf key]];
    CGRect aabb = [self gainAABB:node];
    [leaf setAabb:aabb];
    [[QTreeRoot sharedInstance] updateLeaf:leaf];
}

- (void)updateZPositionForNode:(T2DMapNode *)node{
    [node setZPosition:[node position].y];
}

- (CGRect)gainAABB:(T2DMapNode *)node{
    SKSpriteNode *sprite = (SKSpriteNode *)node;
    CGSize size = sprite.size;
    CGPoint pos = sprite.position;
    CGFloat aabbX = pos.x - size.width/2.0;
    CGFloat aabbY = pos.y - size.height/2.0;
    return CGRectMake(aabbX, aabbY, size.width, size.height);
}

#pragma mark - map actions

- (CGPoint)groupCenter{
    NSArray *leafs = [[QTreeRoot sharedInstance] registeredLeafs];
    float xMax, xMin, yMax, yMin;
    QTreeLeaf *leaf;
    T2DMapNode *sprite;
    if ([leafs count]==0) {
        targetScale = _scale;
        return CGPointMake(treeSize.width/2.0, treeSize.height/2.0);
    }
    
    if ([leafs count] == 1) {
        leaf = [leafs objectAtIndex:0];
        sprite = [self nodeForKey:[leaf key]];
        targetScale = _scale;
        return [sprite position];
    }
    
    int lastIdx = [leafs count] - 1;
    int idx = 0;
    
    while (idx <= lastIdx) {
        leaf = [leafs objectAtIndex:idx];
        sprite = [self nodeForKey:[leaf key]];
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


- (CGPoint)baseLayerPositionForCenterPoint:(CGPoint)pos{
    return CGPointMake(-pos.x*[self scale] + mapSize.width/2, -pos.y*[self scale] + mapSize.height/2);
}

- (BOOL)needFocus{
    CGPoint p2 = [self baseLayerPositionForCenterPoint:[self groupCenter]];
    CGPoint p1 = [baseLayer position];
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
    CGPoint targetLayerPos = [self baseLayerPositionForCenterPoint:[self groupCenter]];
    [baseLayer setPosition:targetLayerPos];
    
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



- (BOOL)needZoom{
    
    if (targetScale != [self scale]) {
        return YES;
    }
    return NO;
}

- (void)zoomAction{
    if (![self needZoom]) return;
    if (cameraZooming) return;
    
    cameraZooming = YES;
    CGFloat tmpTargetScale = targetScale;
    CGFloat tmpScale = [self scale];
    CGFloat scaleOffset = (tmpTargetScale - tmpScale);
//    TLOG(@"zoomAction targetScale -> %f [self scale] -> %f", targetScale,[self scale]);
    CGFloat duration = 0.8;
    SKAction *action = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
        CGFloat percent = elapsedTime/duration;
        CGFloat scale = scaleOffset*percent+tmpScale;
        [self setScale:scale];
    }];
    [action setTimingMode:SKActionTimingEaseOut];
    
    [baseLayer runAction:action completion:^{
        cameraZooming = NO;
    }];
    
//    [self setScale:targetScale];
}


- (T2DMapNode *)touchedNode:(UITouch *)touch{
    CGPoint pos = [touch locationInNode:baseLayer];
    SKNode *node = [baseLayer nodeAtPoint:pos];
    if ([[node parent] isKindOfClass:([AFPlayerNode class])])  return (T2DMapNode *)[node parent];
    if ([node isKindOfClass:([AFPlayerNode class])])  return (T2DMapNode *)node;
    return nil;
}

#pragma mark - sprites opertors

- (T2DMapNode *)nodeForKey:(NSString *)key{
    return [nodes objectForKey:key];
}

- (void)removeNodeForKey:(NSString *)key{
    SKNode *node = [self nodeForKey:key];
    [node removeFromParent];
    [nodes removeObjectForKey:key];
}

- (void)addNode:(T2DMapNode *)node{
    QTreeLeaf *leaf = [[QTreeLeaf alloc] init];
    CGRect aabb = [self gainAABB:node];
    [leaf setAabb:aabb];
    [[QTreeRoot sharedInstance] insertLeaf:leaf];
    [nodes setObject:node forKey:[leaf key]];
    [leafLayer addChild:node];
}

//for qtree testing
- (void)addNodeForTree:(QTree *)tree{
    int w = tree.frame.size.width;
    NSString *bgName = [NSString stringWithFormat:@"BG1_%d",w];
    //    TLOG(@"bgName -> %@", bgName);
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:bgName];
    node.position = tree.center;
    node.alpha = 0.5;
    [treeLayer addChild:node];
    [nodes setObject:node forKey:[tree key]];
}


#pragma mark - contacts

- (void)contactBetweenWall:(SKPhysicsBody *)wall andPlayer:(SKPhysicsBody *)player{
    NSString *wallName = [[wall node] name];
    if ([wallName isEqualToString:@"wallL"]) {
        if ([_delegate respondsToSelector:@selector(mapWallLContactNode:)]) {
            [_delegate mapWallLContactNode:(T2DMapNode *)[player node]];
        }
    }else if ([wallName isEqualToString:@"wallR"]) {
        if ([_delegate respondsToSelector:@selector(mapWallRContactNode:)]) {
            [_delegate mapWallRContactNode:(T2DMapNode *)[player node]];
        }
    }else if ([wallName isEqualToString:@"wallT"]) {
        if ([_delegate respondsToSelector:@selector(mapWallTContactNode:)]) {
            [_delegate mapWallTContactNode:(T2DMapNode *)[player node]];
        }
    }else if ([wallName isEqualToString:@"wallB"]) {
        if ([_delegate respondsToSelector:@selector(mapWallBContactNode:)]) {
            [_delegate mapWallBContactNode:(T2DMapNode *)[player node]];
        }
    }
}


- (void)contactBetweenPlayerA:(SKPhysicsBody *)playerA andPlayerB:(SKPhysicsBody *)playerB{
//    TLOG(@"");
    if ([_delegate respondsToSelector:@selector(mapContactPlayersBetweenNodeA:andNodeB:)]) {
        [_delegate mapContactPlayersBetweenNodeA:(T2DMapNode *)[playerA node] andNodeB:(T2DMapNode *)[playerB node]];
    }
}


#pragma mark - QTreeDelegate

- (void)qtreeDidInsertLeaf:(QTreeLeaf *)leaf{
    
}

- (void)qtreeDidUpdateLeaf:(QTreeLeaf *)leaf{
    //    SKSpriteNode *node = [nodes objectForKey:[leaf key]];
    //    [node setZRotation:[leaf angle]];
}

- (void)qtreeDidRegisterTree:(QTree *)tree{
    return;
    [self addNodeForTree:tree];
}

- (void)qtreeDidUnregisterTree:(QTree *)tree{
    return;
    [self removeNodeForKey:[tree key]];
}



#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact{
//    TLOG(@"contact -> %d %d", contact.bodyA.categoryBitMask, contact.bodyB.categoryBitMask);
    SKPhysicsBody *bodyA = [contact bodyA];
    SKPhysicsBody *bodyB = [contact bodyB];
    int bodyACategory = [bodyA categoryBitMask];
    int bodyBCategory = [bodyB categoryBitMask];

    if (bodyACategory == CategoryWall && bodyBCategory == CategoryPlayer) {
        [self contactBetweenWall:bodyA andPlayer:bodyB];
        return;
    }
    
    if (bodyBCategory == CategoryWall && bodyACategory == CategoryPlayer) {
        [self contactBetweenWall:bodyB andPlayer:bodyA];
        return;
    }
    
    if (bodyBCategory == CategoryPlayer && bodyACategory == CategoryPlayer) {
        [self contactBetweenPlayerA:bodyA andPlayerB:bodyB];
        return;
    }
    
   
    

    
}

- (void)didEndContact:(SKPhysicsContact *)contact{
//    SKPhysicsBody *bodyA = [contact bodyA];
//    SKPhysicsBody *bodyB = [contact bodyB];
//    int bodyACategory = [bodyA categoryBitMask];
//    int bodyBCategory = [bodyB categoryBitMask];
}



@end
