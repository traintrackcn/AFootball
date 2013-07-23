//
//  TRootViewController.h
//  libOpen
//
//  Created by traintrackcn on 13-1-31.
//
//

#import <UIKit/UIKit.h>

@interface TRootViewController : UINavigationController{
    
}


- (void)pushVC:(NSString *)name;
- (void)presentVC:(NSString *)name;

- (void)alertWithTitle:(NSString *)title message:(NSString *)msg;

@end
