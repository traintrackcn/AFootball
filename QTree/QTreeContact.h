//
//  QTreeContact.h
//  AFootball
//
//  Created by traintrackcn on 13-7-19.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QTreeLeaf;

@interface QTreeContact : NSObject

@property (nonatomic, strong) QTreeLeaf *leafA;
@property (nonatomic, strong) QTreeLeaf *leafB;

@end
