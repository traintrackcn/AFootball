//
//  UIImage+KTCommon.m
//  baiboard-ipad
//
//  Created by Zhiyu Liu on 4/19/12.
//  Copyright (c) 2012 LightPlaces Ltd. All rights reserved.
//

#import "UIImage+KTCommon.h"

static void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
	float fw, fh;
	if (ovalWidth == 0 || ovalHeight == 0) {
		CGContextAddRect(context, rect);
		return;
	}
	CGContextSaveGState(context);
	CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
	CGContextScaleCTM (context, ovalWidth, ovalHeight);
	fw = CGRectGetWidth (rect) / ovalWidth;
	fh = CGRectGetHeight (rect) / ovalHeight;
	CGContextMoveToPoint(context, fw, fh/2);
	CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
	CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
	CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
	CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
	CGContextClosePath(context);
	CGContextRestoreGState(context);
}

@implementation UIImage (KTCommon)

+ (UIImage*)imageFromColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    //  [[UIColor colorWithRed:222./255 green:227./255 blue: 229./255 alpha:1] CGColor]) ;
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage*)resizeTo:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [self drawInRect:CGRectMake(0,0,size.width,size.height)];
    UIImage* retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return retval;
}

- (UIImage *)thumbnailImage:(NSUInteger)height
{
    CGFloat imageAspectRatio = self.size.width / self.size.height;  
    CGSize thumbnailSize = CGSizeMake(height * imageAspectRatio, height);
    UIGraphicsBeginImageContext(thumbnailSize);
    [self drawInRect:CGRectMake(0,0,thumbnailSize.width,thumbnailSize.height)];
    UIImage* retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return retval;
}

- (UIImage *)zoomImageWithFactor:(CGFloat)factor
{    
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;    
    CGFloat height = imageSize.height;
    if (width == 0 || height == 0) {
        return self;        
    }
    CGSize targetSize = CGSizeMake(width * factor, height * factor);
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
    UIImage* retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return retval;
}

- (UIImage *)zoomImage:(CGSize)size
{    
    CGSize imageSize = self.size;
    CGFloat width = imageSize.width;    
    CGFloat height = imageSize.height;
    
    if (width == 0 || height == 0) {
        return self;        
    }    
    if (width <= size.width && height<= size.height) {        
        return self;        
    }
    CGFloat scaleFactor = 0.0;    
    CGFloat widthFactor = size.width / width;
    CGFloat heightFactor = size.height / height;
    if (widthFactor > heightFactor)
    {
        scaleFactor = heightFactor;
    }
    else
    {   
        scaleFactor = widthFactor;
    }
    CGFloat scaledWidth  = width * scaleFactor;
    CGFloat scaledHeight = height * scaleFactor;
    CGSize targetSize = CGSizeMake(scaledWidth, scaledHeight);
    UIGraphicsBeginImageContext(targetSize);
    [self drawInRect:CGRectMake(0,0,targetSize.width,targetSize.height)];
    UIImage* retval = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return retval;
}

+ (CGFloat)defaultScale
{
    CGFloat scale = 1.0;
    if([[UIScreen mainScreen]respondsToSelector:@selector(scale)]) {        
        CGFloat tmp = [[UIScreen mainScreen]scale];
        if (tmp > 1.5) {
            scale = 2.0;    
        }
    } 
    if(scale > 1.5) 
    {
        return scale;
    }
    else
    {
        return 1;
    }
}

- (UIImage *)roundCorners:(CGFloat)radius;
{
	int w = self.size.width;
	int h = self.size.height;
	
	CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
	CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
	
	CGContextBeginPath(context);
	CGRect rect = CGRectMake(0, 0, w, h);
	addRoundedRectToPath(context, rect, radius, radius);
	CGContextClosePath(context);
	CGContextClip(context);
	
	CGContextDrawImage(context, CGRectMake(0, 0, w, h), self.CGImage);
	
	CGImageRef imageMaskedRef = CGBitmapContextCreateImage(context);
	CGContextRelease(context);
	CGColorSpaceRelease(colorSpace);
    
    UIImage *imageMasked = [UIImage imageWithCGImage:imageMaskedRef];
    CGImageRelease(imageMaskedRef);
	
	return imageMasked;
}

@end
