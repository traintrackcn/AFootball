//
//  Quadtree.m
//  libOpen
//
//  Created by traintrackcn on 13-7-16.
//
//

#import "QTree.h"
#import "QTreeLeaf.h"
#import "QTreeRoot.h"




@interface QTree(){
    
    NSMutableArray *subTrees;
    CGRect q1;
    CGRect q2;
    CGRect q3;
    CGRect q4;
}

@end

@implementation QTree

- (id)initWithLevel:(int)level frame:(CGRect)frame{
    self = [super init];
    if (self) {
        [self setLevel:level];
        [self setFrame:frame];
        [self generateQuadrants];
        _leafs = [NSMutableArray array];
    }
    return self;
}

- (void)setFrame:(CGRect)frame{
    _frame = frame;
    _center = CGPointMake(frame.origin.x+frame.size.width/2.0, frame.origin.y+frame.size.height/2.0);
}

- (void)subdivide {
    
    if ([self hasSubTrees]) return;
    int subTreeLevel = _level + 1;
    NSArray *frames = [NSArray arrayWithObjects:
                       [NSValue valueWithCGRect:q1],
                       [NSValue valueWithCGRect:q2],
                       [NSValue valueWithCGRect:q3],
                       [NSValue valueWithCGRect:q4],
                       nil];
    
    subTrees = [NSMutableArray arrayWithCapacity:4];
    for (int i=0; i<4; i++) {
        CGRect frame = [[frames objectAtIndex:i] CGRectValue];
        QTree *subTree = [[QTree alloc] initWithLevel:subTreeLevel frame:frame];
        [subTree setKey:[NSString stringWithFormat:@"%@-%d",[self key], (i+1)]];
        [subTree setParent:self];
        [subTrees addObject:subTree];
    }

}

#pragma mark - node methods

- (BOOL)hasSubLeafs{
    if (![self hasSubTrees]) return NO;
    
    for (int i=0; i<[subTrees count]; i++) {
        QTree *subTree = [subTrees objectAtIndex:i];
        if ([subTree hasLeafs]||[subTree hasSubTrees]) {
            return YES;
        }
    }
    
    return NO;
}

- (BOOL)hasLeafs{
    if ([_leafs count]==0) {
        return NO;
    }
    return YES;
}

- (BOOL)isRoot{
    if ([[self key] isEqualToString:@"R"]) {
        return YES;
    }
    return NO;
}

- (BOOL)hasSubTrees{
    if (subTrees) return YES;
    return NO;
}

- (QTree *)subTreeInQuadrant:(int)quadrant{
    if (![self hasSubTrees]) return nil;
    return [subTrees objectAtIndex:quadrant];
}

#pragma mark - quadrant methods

- (void)generateQuadrants{
    int halfW = _frame.size.width/2;
    int halfH = _frame.size.height/2;
    int x = _frame.origin.x;
    int y = _frame.origin.y;
    q1 = CGRectMake(x + halfW, y + halfH, halfW, halfH);
    q2 = CGRectMake(x, y + halfH, halfW, halfH);
    q3 = CGRectMake(x, y, halfW, halfH);
    q4 = CGRectMake(x + halfW, y, halfW, halfH);
}

- (NSString *)rectString:(CGRect)rect{
    return [NSString stringWithFormat:@"%f_%f_%f_%f",rect.origin.x, rect.origin.y, rect.size.width, rect.size.height];
}

- (NSArray *)quadrantsIntersectsRect:(CGRect)targetRect{
    NSMutableArray *tmpArr = [NSMutableArray arrayWithCapacity:4];
    if (CGRectIntersectsRect(targetRect, q1)) [tmpArr addObject:[NSNumber numberWithInt:Quadrant1]];
    if (CGRectIntersectsRect(targetRect, q2)) [tmpArr addObject:[NSNumber numberWithInt:Quadrant2]];
    if (CGRectIntersectsRect(targetRect, q3)) [tmpArr addObject:[NSNumber numberWithInt:Quadrant3]];
    if (CGRectIntersectsRect(targetRect, q4)) [tmpArr addObject:[NSNumber numberWithInt:Quadrant4]];
    
//    TLOG(@"q1:%@ q2:%@ q3:%@ q4:%@ rect:%@", [self rectString:q1], [self rectString:q2], [self rectString:q3], [self rectString:q4], [self rectString:targetRect]);
    
    return tmpArr;
}

#pragma mark - insert methods

- (void)insertLeaf:(QTreeLeaf *)leaf{
    [self insertLeafToSubTree:leaf];
    [self rearrangeWhenOverCapacity];
}

- (void)insertLeafToSubTree:(QTreeLeaf *)leaf{
    if (![self hasSubTrees]){
        [self insertLeafToCurrentTree:leaf];
        return;
    }
    
    NSArray *quadrants = [self quadrantsIntersectsRect:[leaf aabb]];
    for (int i=0; i<[quadrants count]; i++) {
        int quadrant = [[quadrants objectAtIndex:i] integerValue];
         QTree *subTree = [self subTreeInQuadrant:quadrant];
        [subTree insertLeaf:leaf];
    }
    
}

- (void)insertLeafToCurrentTree:(QTreeLeaf *)leaf{
    [_leafs addObject:leaf];
    [leaf addParent:self];
    [[QTreeRoot sharedInstance] registerLeaf:leaf];
    [[QTreeRoot sharedInstance] registerTree:self];
}

- (void)rearrangeWhenOverCapacity{
    if ([_leafs count] <= TQTreeMaxLeafs) return;
    if (_level >= TQTreeMaxLevels) {
//        TLOG(@"Over level capacity [count:%d]",[_leafs count]);
        return;
    }
    
    [self subdivide];
    
    int idx = 0;
    while (idx < [_leafs count]) {
        QTreeLeaf *leaf = [_leafs objectAtIndex:idx];
        NSArray *quadrants = [self quadrantsIntersectsRect:[leaf aabb]];
        [leaf removeFromParent:self];

        
//        TLOG(@"quadrants->%@", quadrants);
        
        for (int i=0; i<[quadrants count]; i++) {
            int quadrant = [[quadrants objectAtIndex:i] intValue];
            QTree *subTree = [self subTreeInQuadrant:quadrant];
            [subTree insertLeaf:leaf];
        }
        
        continue;
        
        idx ++ ;
    }
    
}

#pragma mark - modify methods

- (void)removeLeaf:(QTreeLeaf *)leaf{
    [_leafs removeObject:leaf];
}

#pragma mark - fetch

/*
 * Return all objects that could collide with the given object
 */
- (NSArray *)fetch:(CGRect)targetRect{
    NSArray *quadrants = [self quadrantsIntersectsRect:targetRect];
    NSMutableArray *results;
    
    for (int i=0; i<[quadrants count]; i++) {
        int quadrant = [[quadrants objectAtIndex:i] intValue];
        if ([self hasSubTrees]) {
            QTree *subTree = [self subTreeInQuadrant:quadrant];
            NSArray *subTreeLeafs = [subTree fetch:targetRect];
            [results addObjectsFromArray:subTreeLeafs] ;
        }
    }
    
    
    [results addObjectsFromArray:_leafs];
    
    return results;
}


#pragma mark - clear methods

- (void)clear{
    [self removeLeafs];
    [self removeSubTrees];
}

- (void)removeLeafs{
    for (int i=0; i<[_leafs count]; i++) {
        QTreeLeaf *leaf = [_leafs objectAtIndex:i];
        [self removeLeaf:leaf];
    }
}

- (void)removeSubTrees{
    if (![self hasSubTrees]) return;
//    TLOG(@"removeSubTrees [%@]", [self key]);
    for (int i=0; i < [subTrees count]; i++) {
        QTree *subTree = [subTrees objectAtIndex:i];
        [subTree clear];
        [subTree setParent:nil];
    }
    subTrees = nil;
}


@end
