//
//  T2DCamera.h
//  AFootball
//
//  Created by traintrackcn on 13-8-1.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import <Foundation/Foundation.h>

@class T2DMap;

//@protocol T2DCameraDelegate <NSObject>
//
//@required
//- (T2DMap *)mapOfCamera;
//
//@end


@interface T2DCamera : NSObject

- (void)update;


- (id)initWithMap:(T2DMap *)map;
//@property (nonatomic, weak) T2DMap *map;
//@property (nonatomic, weak) id<T2DCameraDelegate> delegate;

@end
