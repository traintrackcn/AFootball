//
//  TDeviceUtil.h
//  libOpen
//
//  Created by traintrackcn on 13-3-4.
//
//

#import <Foundation/Foundation.h>

@interface TDeviceUtil : NSObject

+(TDeviceUtil *)sharedInstance;

+ (BOOL)isIPad;

+ (BOOL)isPortrait;

+ (BOOL)iPhoneIs16_9;


//screen properties

- (CGFloat)screenWidth;
- (CGFloat)screenWidthHalf;
- (CGFloat)screenHeight;
- (CGFloat)screenHeightHalf;

@end
