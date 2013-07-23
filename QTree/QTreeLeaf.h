//
//  QTreeLeaf.h
//  libOpen
//
//  Created by traintrackcn on 13-7-16.
//
//

#import <Foundation/Foundation.h>

@class QTree;

@interface QTreeLeaf : NSObject


//- (id)initWithFrame:(CGRect)frame;
//- (void)moveByTimeInterval:(CGFloat)interval;
//- (void)moveTo:(CGPoint)target;
//- (CGFloat)angle;

- (void)addParent:(QTree *)parentTree;
- (NSArray *)allParents;
- (NSArray *)allParentsKeys;

- (void)removeFromParents;
- (void)removeFromParent:(QTree *)parentTree;


//@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGRect aabb;
@property (nonatomic, strong) NSString *key;
//@property (nonatomic, assign) CGPoint velocity;
//@property (nonatomic, assign) CGFloat radius;



@end
