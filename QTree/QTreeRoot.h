//
//  QTreeMap.h
//  AFootball
//
//  Created by traintrackcn on 13-7-17.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QTree.h"
#import "QTreeContact.h"

@protocol QTreeDelegate <NSObject>

@required
- (void)qtreeDidInsertLeaf:(QTreeLeaf *)leaf;
- (void)qtreeDidUpdateLeaf:(QTreeLeaf *)leaf;
- (void)qtreeDidRegisterTree:(QTree *)tree;
- (void)qtreeDidUnregisterTree:(QTree *)tree;
- (void)qtreeDidBeginContact:(QTreeContact *)contact;
- (void)qtreeDidEndContact:(QTreeContact *)contact;

//- (void)qtreeDetectCollide;

@end

@interface QTreeRoot : NSObject{
    
}

+ (QTreeRoot *)sharedInstance;
- (void)generateWithFrame:(CGRect)frame;

- (void)registerLeaf:(QTreeLeaf *)leaf;
- (void)unregisterLeaf:(QTreeLeaf *)leaf;

- (void)registerTree:(QTree *)tree;
- (void)unregisterTree:(QTree *)tree;

- (NSArray *)registeredTrees;
- (NSArray *)registeredLeafs;

- (void)insertLeaf:(QTreeLeaf *)leaf;
- (void)updateLeaf:(QTreeLeaf *)leaf;


@property (nonatomic, strong) QTree *root;
@property (nonatomic, weak) id<QTreeDelegate> delegate;
@property (nonatomic, assign) CGSize halfSize;
@property (nonatomic, assign) CGSize size;

//@property (nonatomic, assign) int detectTimes;

@end
