//
//  AFMyScene.m
//  AFootball
//
//  Created by traintrackcn on 13-7-15.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "AFMyScene.h"


static const uint32_t leafCategory        =  0x1 << 0;
static const uint32_t otherCategory        =  0x1 << 1;

@interface AFMyScene(){
    SKNode *baseLayer;
    SKNode *treeLayer;
    SKNode *leafLayer;
    
    CGFloat previousTime;
    SKLabelNode *leafCountLabel;
    SKLabelNode *collideCountLabel;
    NSMutableDictionary *nodes;
    
    CGFloat _scale;
    QTreeLeaf *focusedLeaf;
}

@end

@implementation AFMyScene

-(id)initWithSize:(CGSize)size {    
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
//        [self createBackground];
        _scale = 0.5;
        
        
        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
        [self createLayers];
        
        nodes = [NSMutableDictionary dictionary];
        
        [self ceateQTreeRootAndDraw];
        [self createLabel];
        
        
        
        //setup physics world
        
        self.physicsWorld.contactDelegate = self;
        
    }
    return self;
}


- (void)createLayers{
    baseLayer = [[SKNode alloc] init];
    [self addChild:baseLayer];
    [baseLayer setScale:_scale];
    
    treeLayer = [[SKNode alloc] init];
    [baseLayer addChild:treeLayer];
    
    leafLayer = [[SKNode alloc] init];
    [baseLayer addChild:leafLayer];
}

- (void)createBackground{
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"AFField"];
    CGPoint targetPos = CGPointMake(self.size.width/2, self.size.height/2);
    [node setPosition:targetPos];
    [self addChild:node];
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

- (void)ceateQTreeRootAndDraw{
    CGFloat w = 256.0;
    CGFloat h = 256.0;
    CGFloat x = 32.0;
    CGFloat y = (self.size.height-h)/2;
    
    x = 0;
    y = 0;
    
    [[QTreeRoot sharedInstance] generateWithFrame:CGRectMake(x, y, w, h)];
    [[QTreeRoot sharedInstance] setDelegate:self];
    CGRect rootFrame = [[[QTreeRoot sharedInstance] root] frame];
    float rootX = rootFrame.origin.x;
    float rootY = rootFrame.origin.y;
    float rootW = rootFrame.size.width;
    float rootH = rootFrame.size.height;
    
    CGPoint startL = CGPointMake(rootX+rootW, rootY);
    CGPoint endL = CGPointMake(rootX+rootW, rootY+rootH);
    CGPoint startT = CGPointMake(rootX, rootY+rootH);
    CGPoint endT = CGPointMake(rootX+rootW, rootY+rootH);
    CGPoint startR = CGPointMake(rootX, rootY);
    CGPoint endR = CGPointMake(rootX, rootY+rootH);
    CGPoint startB = CGPointMake(rootX, rootY);
    CGPoint endB = CGPointMake(rootX+rootW, rootY);
    
    
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
        [body setDynamic:NO];
        [node setPhysicsBody:body];
        [self addChild:node];
    }
    
    
    
}


- (void)drawQTree:(QTree *)tree{
    int w = tree.frame.size.width;
    NSString *bgName = [NSString stringWithFormat:@"BG1_%d",w];
//    TLOG(@"bgName -> %@", bgName);
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:bgName];
    node.position = tree.center;
    [treeLayer addChild:node];
    
    [nodes setObject:node forKey:[tree key]];
}

- (CGFloat)randomVelocityScalar{
    return (arc4random() % 20) + 10;
}


- (void)appendLeaf:(CGPoint)pos{

    // draw leaf
    
    SKSpriteNode *node = [SKSpriteNode spriteNodeWithImageNamed:@"point"];
    node.position = pos;
    
//   TLOG(@"node size: %f %f", node.size.width, node.size.height);
    
    //setup physics body
    SKPhysicsBody *body = [SKPhysicsBody bodyWithRectangleOfSize:node.size];
    [body setAffectedByGravity:NO];
    [body setDynamic:YES];
    [body setAllowsRotation:YES];
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
    [leafLayer addChild:node];
    
    
    QTreeLeaf *leaf = [[QTreeLeaf alloc] init];
    
    CGRect aabb = [self genAABB:node];
    [leaf setAabb:aabb];
    [[QTreeRoot sharedInstance] insertLeaf:leaf];
    [nodes setObject:node forKey:[leaf key]];

//    [self logLeafsDetails];
    int count = [[[QTreeRoot sharedInstance] registeredLeafs] count];
    [leafCountLabel setText:[NSString stringWithFormat:@"leaf:%d",count]];
    
    if (count == 100) {
        focusedLeaf = leaf;
//        [node setColor:[UIColor blueColor]];
//        [node setBlendMode:SKBlendModeSubtract];
//        [node setColorBlendFactor:1];
        [node setScale:2.0];
    }
    
}


- (SKSpriteNode *)focusedNode{
    return [nodes objectForKey:[focusedLeaf key]];
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
    
    if ([[[QTreeRoot sharedInstance] registeredLeafs] count]>0) {
        return;
    }
    
    CGPoint location = CGPointZero;
    //        float s = [self scale];
    for (int i=0; i<100; i++) {
        location.x = arc4random()%240+6;
        location.y = arc4random()%240+6;
//        TLOG(@"_scale -> %f", _scale);
        location = CGPointMake(location.x, location.y);
        
        [self appendLeaf:location];
    }
    
    
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    /* Called when a touch begins */
    
    
    for (UITouch *touch in touches) {
        int tapCount = [touch tapCount];
        if (tapCount == 2) {
            [self zoom];
            return;
        }
        
//        CGPoint location = [touch locationInNode:self];

        [self appendRandomLeaf];
    }
}




- (void)zoom{
    
//    TLOG(@"_scale -> %f", _scale);
    
    float targetScale = 0;
    int scaleMode = 0;
    if (_scale == 2) {
        targetScale = 0.5;
        scaleMode = SKActionTimingEaseOut;
    }else if(_scale == 0.5){
        targetScale = 2;
        scaleMode = SKActionTimingEaseIn;
    }else{
        return;
    }
    
//    [self focusAction];
//    return;
//    scaleMode = SKActionTimingLinear;
    
    float duration = 0.8;
    SKAction *action = [SKAction customActionWithDuration:duration actionBlock:^(SKNode *node, CGFloat elapsedTime) {
//        TLOG(@"elapsedTime -> %f", elapsedTime);
        _scale = (targetScale-_scale) * (elapsedTime/duration)+_scale;
        [baseLayer setScale:_scale];
//        [self focusAction];
    }];
    [action setTimingMode:scaleMode];
    
    
    [baseLayer runAction:action  withKey:@"scale"];
    
    
}

- (void)appendSpaceShip:(CGPoint)location{
    SKSpriteNode *sprite = [SKSpriteNode spriteNodeWithImageNamed:@"Spaceship"];
    sprite.position = location;
    SKAction *action = [SKAction rotateByAngle:M_PI duration:1];
    [sprite runAction:[SKAction repeatActionForever:action]];
    [self addChild:sprite];
}



- (void)focusAction{
    if (!focusedLeaf) return;
    SKSpriteNode *node = [self focusedNode];
//    TLOG(@"action -> %@",[node actionForKey:@"focus"]);
//    if ([baseLayer actionForKey:@"focus"]) return;
//    TLOG(@"do focus");
    
    CGSize halfSize = [[QTreeRoot sharedInstance] halfSize];
    CGPoint target = CGPointMake(-[node position].x*_scale + halfSize.width, -[node position] .y*_scale + halfSize.height);

//    SKAction *action = [SKAction moveTo:target duration:0.1];
//    [action setTimingMode:SKActionTimingEaseOut];
//    [baseLayer runAction:action withKey:@"focus"];
    [baseLayer setPosition:target];
    
}

- (void)didSimulatePhysics{
    [self updateRegisteredLeafsAABB];
    [self focusAction];
}

- (void)updateRegisteredLeafsAABB{
//    TLOG(@"updateRegisteredLeafsAABB");
    NSArray *leafs = [[QTreeRoot sharedInstance] registeredLeafs];
    for (int i=0; i<[leafs count];i++) {
        QTreeLeaf *leaf = [leafs objectAtIndex:i];
        SKSpriteNode *node = [nodes objectForKey:[leaf key]];
        CGRect aabb = [self genAABB:node];
        [leaf setAabb:aabb];
        [[QTreeRoot sharedInstance] updateLeaf:leaf];
        
    }
}

- (CGRect)genAABB:(SKSpriteNode *)node{
    
    CGSize nodeSize = node.size;
    CGPoint nodePos = node.position;
    CGFloat aabbX = nodePos.x - nodeSize.width/2.0;
    CGFloat aabbY = nodePos.y - nodeSize.height/2.0;
//    TLOG(@"aabbX %f aabbY %f aabbW:%f aabbH %f", aabbX, aabbY , nodeSize.width, nodeSize.height);
    return CGRectMake(aabbX, aabbY, nodeSize.width, nodeSize.height);
}


#pragma mark - QTreeDelegate

- (void)qtreeDidInsertLeaf:(QTreeLeaf *)leaf{
    
}

- (void)qtreeDidUpdateLeaf:(QTreeLeaf *)leaf{
//    SKSpriteNode *node = [nodes objectForKey:[leaf key]];
//    [node setZRotation:[leaf angle]];
}

- (void)qtreeDidRegisterTree:(QTree *)tree{
//    return;
    [self drawQTree:tree];
}

- (void)qtreeDidUnregisterTree:(QTree *)tree{
//    return;
    SKShapeNode *node = [nodes objectForKey:[tree key]];
    [node removeFromParent];
    [nodes removeObjectForKey:[tree key]];
}

- (void)qtreeDidBeginContact:(QTreeContact *)contact{
//    TLOG(@"contact -> %@", contact);
    
    SKSpriteNode *nodeA = [nodes objectForKey:[contact.leafA key]];
    SKSpriteNode *nodeB = [nodes objectForKey:[contact.leafB key]];
    
    [nodeA setScale:1.5];
    [nodeB setScale:1.5];
    
    
    
//    [contact leafA].velocity = CGPointMake([contact leafA].velocity.x*0.5, [contact leafA].velocity.y*0.5);
//    [contact leafB].velocity = CGPointMake([contact leafB].velocity.x*0.5, [contact leafB].velocity.y*0.5);
}

- (void)qtreeDidEndContact:(QTreeContact *)contact{
    SKSpriteNode *nodeA = [nodes objectForKey:[contact.leafA key]];
    SKSpriteNode *nodeB = [nodes objectForKey:[contact.leafB key]];
    
    [nodeA setScale:1.0];
    [nodeB setScale:1.0];
    
//    [contact leafA].velocity = CGPointMake([contact leafA].velocity.x*2, [contact leafA].velocity.y*2);
//    [contact leafB].velocity = CGPointMake([contact leafB].velocity.x*2, [contact leafB].velocity.y*2);
}

#pragma mark - SKPhysicsContactDelegate

- (void)didBeginContact:(SKPhysicsContact *)contact{
//    TLOG(@"contact -> %@ %@", contact.bodyA.node.name, contact.bodyB.node.name);
    NSString *bodyAName = [[[contact bodyA] node] name];
    NSString *bodyBName = [[[contact bodyB] node] name];
    SKPhysicsBody *bodyA = [contact bodyA];
    SKPhysicsBody *bodyB = [contact bodyB];
    
    SKPhysicsBody *wallBody;
    NSString *wallBodyName;
    SKPhysicsBody *targetBody;
    
    if ([bodyAName rangeOfString:@"wall"].location != NSNotFound) {
        wallBody = bodyA;
        wallBodyName = bodyAName;
        targetBody = bodyB;
    }else if([bodyBName rangeOfString:@"wall"].location != NSNotFound){
        wallBody = bodyB;
        wallBodyName = bodyBName;
        targetBody = bodyA;
    }
    
    if (wallBody==nil) return;
    
//    TLOG(@"wallBodyName -> %@ %f %f", wallBodyName, targetBody.velocity.x, targetBody.velocity.y);
    
    if ([wallBodyName isEqualToString:@"wallL"]) {
        targetBody.velocity = CGPointMake(-[self randomVelocityScalar], targetBody.velocity.y);
    }
    
    if ([wallBodyName isEqualToString:@"wallR"]) {
        targetBody.velocity = CGPointMake([self randomVelocityScalar], targetBody.velocity.y);
    }
    
    if ([wallBodyName isEqualToString:@"wallT"]) {
        targetBody.velocity = CGPointMake(targetBody.velocity.x, -[self randomVelocityScalar]);
    }
        
    if ([wallBodyName isEqualToString:@"wallB"]) {
        targetBody.velocity = CGPointMake(targetBody.velocity.x, [self randomVelocityScalar]);
    }
    
    
    
    
}

- (void)didEndContact:(SKPhysicsContact *)contact{
    
}



@end
