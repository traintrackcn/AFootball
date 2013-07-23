//
//  QTreeLeaf.m
//  libOpen
//
//  Created by traintrackcn on 13-7-16.
//
//

#import "QTreeLeaf.h"
#import "QTreeRoot.h"

@interface QTreeLeaf(){
    NSMutableArray *parents;
}

@end

@implementation QTreeLeaf

- (id)init{
    self = [super init];
    if (self) {
        NSString *hexRandom = [NSString stringWithFormat:@"%08X", (arc4random() % 999999999)];

        [self setKey:hexRandom];
//        [self setFrame:frame];
//        
//        _velocity.x = (arc4random() % 20) + 10;
//        _velocity.y = (arc4random() % 20) + 10;
        
//        TLOG_DEBUG(@"velocity x:%f y:%f", _velocity.x , _velocity.y);
        parents = [NSMutableArray arrayWithCapacity:4];
    }
    return self;
}



//- (int)velocityQuadrant{
//    if (_velocity.x>0) {
//        if (_velocity.y>0) {
//            return Quadrant1;
//        }else if(_velocity.y<0){
//            return Quadrant4;
//        }
//    }else if(_velocity.x<0){
//        if (_velocity.y>0) {
//            return Quadrant2;
//        }else if(_velocity.y<0){
//            return Quadrant3;
//        }
//    }
//    
//    return -1;
//}
//
//- (CGFloat)angle{
////    return 0;
//    
//    float a = _velocity.y;
//    float b = _velocity.x;
//    
//    if (a==0) {
//        if (b>0) {
//            return M_PI_2;
//        }else if(b<0){
//            return M_PI_2+M_PI;
//        }
//    }else if(b==0){
//        if (a>0) {
//            return 0;
//        }else if(b<0){
//            return M_PI;
//        }
//    }
//    
//    if (a==0 && b==0) {
//        return 0;
//    }
//    
//    float c = sqrtf(pow(a, 2) + pow(b, 2));
//    float angle = asin(a/c);
//    if (angle<0) angle = -angle;
//    
////    TLOG(@"angle -> %f   a:%f c:%f", (angle/M_PI)*180, a, c);
//    int quadrant = [self velocityQuadrant];
//    switch (quadrant) {
//        case Quadrant1:
//            return angle;
//        case Quadrant2:
//            return M_PI-angle;
//        case Quadrant3:
//            return M_PI+angle;
//        case Quadrant4:
//            return M_PI*2-angle;
//    }
//    return angle;
//}

//- (void)setFrame:(CGRect)frame{
//    _frame = frame;
//    _center = CGPointMake(frame.origin.x+frame.size.width/2.0, frame.origin.y+frame.size.height/2.0);
//}

#pragma mark - move action

//- (void)moveByTimeInterval:(CGFloat)interval{
//    CGRect frame = [self frame];
//    CGPoint oldPos = frame.origin;
//    CGPoint targetPos = CGPointMake(oldPos.x+_velocity.x*interval, oldPos.y+_velocity.y*interval);
////    TLOG_DEBUG(@"oldPos %f %f targetPos x %f y %f", oldPos.x, oldPos.y,targetPos.x , targetPos.y);
//    [self moveTo:targetPos];
//}
//
//- (void)moveTo:(CGPoint)target{
//    
//    // temp for bounce
//    if ([self bounce:target])   return;
//    
//    
//    CGRect frame = [self frame];
//    frame.origin = target;
//    [self setFrame:frame];
//    [[QTreeRoot sharedInstance] updateLeaf:self];
//    
//}

//- (BOOL)bounce:(CGPoint)target{
//    
//    CGRect rFrame = [[[QTreeRoot sharedInstance] root] frame];
//    if (target.x >= rFrame.origin.x + rFrame.size.width || target.x <= rFrame.origin.x) {
//        _velocity.x = - _velocity.x;
//        return YES;
//    }
//    
//    if (target.y >= rFrame.origin.y + rFrame.size.height || target.y <= rFrame.origin.y) {
//        _velocity.y = - _velocity.y;
//        return YES;
//    }
//    
//    return NO;
//}

#pragma mark - parent operate

- (void)addParent:(QTree *)parentTree{
    [parents addObject:parentTree];
}

- (NSArray *)allParents{
    return parents;
}

- (NSArray *)allParentsKeys{
    NSMutableArray *keys = [NSMutableArray array];
    for (int i=0; i<[parents count]; i++) {
        QTree *parent = [parents objectAtIndex:i];
        [keys addObject:[parent key]];
    }
    return keys;
}

- (void)removeFromParents{
    for (int i=0; i<[parents count]; i++) {
        QTree *parent = [parents objectAtIndex:i];
        [self removeFromParent:parent];
    }
}

- (void)removeFromParent:(QTree *)parentTree{
    [parentTree removeLeaf:self];
    [parents removeObject:parentTree];
    [[QTreeRoot sharedInstance] unregisterTree:parentTree];
    
    if ([parents count]==0) [[QTreeRoot sharedInstance] unregisterLeaf:self];
}

@end
