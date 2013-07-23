//
//  Quadtree.h
//  libOpen
//
//  Created by traintrackcn on 13-7-16.
//
//


const static int TQTreeMaxLeafs = 4;
const static int TQTreeMaxLevels = 4;


enum {
    QuadrantUnavalible = -1,
    Quadrant1 = 0,          //Quadrant 1
    Quadrant2 = 1,          //Quadrant 2
    Quadrant3 = 2,          //Quadrant 3
    Quadrant4 = 3              //Quadrant 4
};


#import <Foundation/Foundation.h>
#import "QTreeLeaf.h"

@interface QTree : NSObject


- (id)initWithLevel:(int)level frame:(CGRect)frame;


- (NSArray *)fetch:(CGRect)rect;
- (BOOL)isRoot;
- (BOOL)hasSubTrees;
- (QTree *)subTreeInQuadrant:(int)quadrant;

- (void)clear;
- (void)removeLeafs;
- (void)removeSubTrees;

- (void)insertLeaf:(QTreeLeaf *)leaf;
- (void)removeLeaf:(QTreeLeaf *)leaf;

- (BOOL)hasLeafs;
- (BOOL)hasSubLeafs;


@property (nonatomic, assign) CGPoint center;

@property (nonatomic, assign) int level;
@property (nonatomic, assign) CGRect frame;
@property (nonatomic, strong) NSMutableArray *leafs;
@property (nonatomic, strong) NSString *key;
@property (nonatomic, strong) QTree *parent;

@end
