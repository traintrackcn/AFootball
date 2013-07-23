//
//  DSViewControllerManager.m
//  og
//
//  Created by 2ViVe on 12-11-20.
//  Copyright (c) 2012年 2ViVe. All rights reserved.
//

#import "TNibUtil.h"
//#import "RevealController.h"

static TNibUtil *_instanceTNibUtil;


//private methods
@interface TNibUtil()

@end


@implementation TNibUtil

+ (TNibUtil *)instance{
    
//    LOG_DEBUG(@"instance -> %@",_instanceDSViewControllerManager);
    
	if(!_instanceTNibUtil){
		_instanceTNibUtil = [[TNibUtil alloc] init];
	}
	return _instanceTNibUtil;
}


- (id)init{
    if (self = [super init]){
    }
    return self;
}


+ (id) instantiateObjectFromNibWithName:(NSString *)name{
    NSArray *topLevelObjects = [[NSBundle mainBundle] loadNibNamed:name owner:nil options:nil];
    return [topLevelObjects objectAtIndex:0];
}







@end
