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

- (void)addParent:(QTree *)parentTree;
- (NSArray *)allParents;
- (NSArray *)allParentsKeys;

- (void)removeFromParents;
- (void)removeFromParent:(QTree *)parentTree;


@property (nonatomic, assign) CGRect aabb;
@property (nonatomic, strong) NSString *key;



@end
