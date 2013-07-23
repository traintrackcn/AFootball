//
//  TDeviceUtil.m
//  libOpen
//
//  Created by traintrackcn on 13-3-4.
//
//

#import "TDeviceUtil.h"


@interface TDeviceUtil(){
    CGFloat screenWidth;
    CGFloat screenHeight;
    CGFloat screenWidthHalf;
    CGFloat screenHeightHalf;
}
@end


static TDeviceUtil *____instanceTDeviceUtil;

@implementation TDeviceUtil


- (id)init{
    self = [super init];
    if (self) {
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize size = rect.size;
        screenWidth = size.width;
        screenHeight = size.height;
        screenWidthHalf = screenWidth/2.0f;
        screenHeightHalf = screenHeight/2.0f;
        
    }
    return self;
}


+(TDeviceUtil *)sharedInstance{
    if (____instanceTDeviceUtil == nil) {
        ____instanceTDeviceUtil = [[TDeviceUtil alloc] init];
    }
    return ____instanceTDeviceUtil;
}

+ (BOOL)isIPad{
    return UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad;
}

+ (BOOL)isPortrait{
    //    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    //    return UIDeviceOrientationIsPortrait(orientation);
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    //    if (orientation == 4) {
    //        return NO;
    //    }
    return UIInterfaceOrientationIsPortrait(orientation);
}

+ (BOOL)iPhoneIs16_9{
    //    UIDevice *device = [UIDevice currentDevice];
    //    NSString *model = [device model];
    CGRect rect = [[UIScreen mainScreen] bounds];
    CGSize size = rect.size;
    float w = size.width;
    float h = size.height;
    
    if (w==320.0f && h == 480.0f) {
        return NO;
    }
    
    //    LOG_DEBUG(@"screen rect -> w:%f h:%f", size.width,size.height);
    return YES;
}



+ (NSString *)systemInfo{
    UIDevice *device = [UIDevice currentDevice];
    NSString *str = [NSString stringWithFormat:@"%@_%@",[device systemVersion],[device model]];
    str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
    return str;
}

+ (NSUInteger)supportedInterfaceOrientations
{
    if ([self isIPad]) {
        return UIInterfaceOrientationMaskAll;
    } else {
        return UIInterfaceOrientationMaskPortrait;
    }
}

#pragma mark - screen properties

- (CGFloat)screenWidth{
    return screenWidth;
}

- (CGFloat)screenWidthHalf{
    return screenWidthHalf;
}

- (CGFloat)screenHeight{
    return screenHeight;
}

- (CGFloat)screenHeightHalf{
    return screenHeightHalf;
}


@end
