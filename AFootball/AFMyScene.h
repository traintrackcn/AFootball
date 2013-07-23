//
//  AFMyScene.h
//  AFootball
//

//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "QTreeRoot.h"

@interface AFMyScene : SKScene <QTreeDelegate, SKPhysicsContactDelegate>



- (void)zoom;


@end
