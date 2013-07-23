//
//  QTreeMap.m
//  AFootball
//
//  Created by traintrackcn on 13-7-17.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "QTreeRoot.h"

static QTreeRoot *_____instanceQTreeRoot;

@interface QTreeRoot(){
    NSMutableDictionary *leafToKey;
    NSMutableDictionary *treeToKey;
    
    NSMutableDictionary *contactToKey;
}

@end


@implementation QTreeRoot

+ (QTreeRoot *)sharedInstance{
    if (!_____instanceQTreeRoot) {
        _____instanceQTreeRoot = [[QTreeRoot alloc] init];
    }
    return _____instanceQTreeRoot;
}

- (id)init{
    self = [super init];
    if (self) {
        leafToKey = [NSMutableDictionary dictionary];
        treeToKey = [NSMutableDictionary dictionary];
        contactToKey = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (QTree *)root{
    return [[self sharedInstance] root];
}

#pragma mark -

- (void)generateWithFrame:(CGRect)frame{
    _root = [[QTree alloc] initWithLevel:0 frame:frame];
    
    _size = frame.size;
    _halfSize = CGSizeMake(_size.width/2.0, _size.height/2.0);
    
    [_root setKey:@"R"];
}

- (void)registerLeaf:(QTreeLeaf *)leaf{
//    [leaf addParent:parentTree];
    NSString *key = [leaf key];
    if (![leafToKey objectForKey:key]) [leafToKey setObject:leaf forKey:key];
//    [self registerTree:parentTree];
}


- (void)unregisterLeaf:(QTreeLeaf *)leaf{
    NSString *key = [leaf key];
    if ([leafToKey objectForKey:key]) [leafToKey removeObjectForKey:key];
}

- (void)registerTree:(QTree *)tree{
    if ([treeToKey objectForKey:[tree key]]) return;
    [treeToKey setObject:tree forKey:[tree key]];
    [_delegate qtreeDidRegisterTree:tree];
}


- (void)unregisterTree:(QTree *)tree{
//    TLOG(@"unregisterTree -> %@ parent -> %@ hasLeafs:%d", [tree key], [tree parent], [tree hasLeafs]);
    if ([tree hasLeafs]) return;
    [treeToKey removeObjectForKey:[tree key]];
    [_delegate qtreeDidUnregisterTree:tree];
  
//    return;
    QTree *parentTree = [tree parent];
    if (![parentTree hasSubLeafs]) {
//        TLOG(@"parentTree hasLeafs %d", [parentTree hasLeafs]);
        [parentTree removeSubTrees];
    }
    
    
}

#pragma mark - update physics

//- (void)simulatesPhysics:(CGFloat)interval{
//    [self updateLeafsPosition:interval];
//    [self detectCollision];
//}
//
//- (void)updateLeafsPosition:(CGFloat)interval{
//    //    TLOG_DEBUG(@"registers leafs -> %d", [[[QTreeRoot sharedInstance] registeredLeafs] count])
//    NSArray *leafs = [[QTreeRoot sharedInstance] registeredLeafs];
//    for (int i=0; i< [leafs count]; i++) {
//        QTreeLeaf *leaf = [leafs objectAtIndex:i];
//        [leaf moveByTimeInterval:interval];
//    }
//}

//#pragma mark - 
//
//- (void)detectCollision{
//    
//    NSArray *trees = [self treesInSight];
//    
//    _detectTimes = 0;
//    
//    for (int i=0; i<[trees count]; i++) {
//        QTree *tree = [trees objectAtIndex:i];
//        NSArray *leafs = [tree leafs];
//        [self detectCollisionAABB:leafs];
//        
//       _detectTimes += powf([leafs count], 2);
//    }
//    
//}
//
//
//
//- (void)detectCollisionAABB:(NSArray *)leafs{
//    
//    
//    
//    for ( int i=0; i<[leafs count]; i++) {
//        QTreeLeaf *leafA = [leafs objectAtIndex:i];
//        CGRect rectA = [leafA frame];
//        for (int j=0; j<[leafs count]; j++) {
//            QTreeLeaf *leafB = [leafs objectAtIndex:j];
//            
//            if ([leafA isEqual:leafB]) continue;
//            
//            CGRect rectB = [leafB frame];
//            BOOL aIntersectsB = CGRectIntersectsRect(rectA, rectB);
//            NSString *contactKeyAB = [NSString stringWithFormat:@"%@%@", [leafA key], [leafB key]];
//            NSString *contactKeyBA = [NSString stringWithFormat:@"%@%@", [leafB key], [leafA key]];
//            QTreeContact *contact = [contactToKey objectForKey:contactKeyAB];
//            if (aIntersectsB) {
//                if (contact) continue;
//                contact = [[QTreeContact alloc] init];
//                [contact setLeafA:leafA];
//                [contact setLeafB:leafB];
//                [contactToKey setObject:contact forKey:contactKeyAB];
//                [contactToKey setObject:contact forKey:contactKeyBA];
//                [_delegate qtreeDidBeginContact:contact];
//            }else{
//                if (!contact) continue;
//                [contactToKey removeObjectForKey:contactKeyAB];
//                [contactToKey removeObjectForKey:contactKeyBA];
//                [_delegate qtreeDidEndContact:contact];
//            }
//        }
//    }
//    
//    //decetCollision
//    
//}
//
//// more accurate
//- (void)detectCollisionSAT{
//    
//}

- (NSArray *)treesInSight{
    return [self registeredTrees];
}

#pragma mark -

- (void)insertLeaf:(QTreeLeaf *)leaf{
    [_root insertLeaf:leaf];
    [_delegate qtreeDidInsertLeaf:leaf];
}

- (void)updateLeaf:(QTreeLeaf *)leaf{
    [leaf removeFromParents];
    [_root insertLeaf:leaf];
    [_delegate qtreeDidUpdateLeaf:leaf];
}

- (NSArray *)registeredTrees{
    return [treeToKey allValues];
}

- (NSArray *)registeredLeafs{
    return [leafToKey allValues];
}

@end
