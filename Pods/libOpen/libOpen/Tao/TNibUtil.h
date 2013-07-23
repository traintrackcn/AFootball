//
//  DSViewControllerManager.h
//  og
//
//  Created by 2ViVe on 12-11-20.
//  Copyright (c) 2012年 2ViVe. All rights reserved.
//

#import <Foundation/Foundation.h>



@interface TNibUtil : NSObject{

}

+ (TNibUtil *)instance;
+ (id) instantiateObjectFromNibWithName:(NSString *)name;

@end
