//
//  AFAppDelegate.m
//  AFootball
//
//  Created by traintrackcn on 13-7-15.
//  Copyright (c) 2013年 traintrackcn. All rights reserved.
//

#import "AFAppDelegate.h"
#import "AFViewController.h"
//#import <Parse/Parse.h>

@implementation AFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //Parse.com configs
//    [Parse setApplicationId:@"nScrMH4sZ6rkc5PpmuFFAfvrcm6f3wvLtrlzahgR" clientKey:@"nDUPfeUeUZop4T9Wm5gz1ncaCfqa9s0EQFzMD1a5"];
//    
//    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    // Override point for customization after application launch.
    
    
    CGRect wRect = [[UIScreen mainScreen] bounds];
    UIWindow *w = [[UIWindow alloc] initWithFrame:wRect];
    [self setWindow:w];
    
    AFViewController *rootVC = [[AFViewController alloc] init];
    [w setRootViewController:rootVC];
    
    [w makeKeyAndVisible];
    
//    TLOG(@"%@", [[NSBundle mainBundle] pa]);
    
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
