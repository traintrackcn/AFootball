//
//  UIImage+KTCommon.h
//  baiboard-ipad
//
//  Created by Zhiyu Liu on 4/19/12.
//  Copyright (c) 2012 LightPlaces Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (KTCommon)

+ (UIImage*)imageFromColor:(UIColor*)color;
- (UIImage*)resizeTo:(CGSize)size;
- (UIImage*)zoomImage:(CGSize)size;
- (UIImage*)zoomImageWithFactor:(CGFloat)factor;
- (UIImage*)thumbnailImage:(NSUInteger)size;

+ (CGFloat)defaultScale;
- (UIImage *)roundCorners:(CGFloat)radius;

@end
