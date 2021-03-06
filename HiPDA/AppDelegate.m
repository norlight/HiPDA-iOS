//
//  AppDelegate.m
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import "AppDelegate.h"
#import "XEJThreadViewModel.h"
#import "XEJThreadListViewModel.h"
#import "XEJThreadListViewController.h"
#import "XEJNavigationControllerStackManager.h"
#import "XEJLoginViewController.h"
#import "XEJRevealViewController.h"
#import "XEJAccountManager.h"
#import "XEJUtility.h"
#import <AspectsV1.4.2/Aspects.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    NSURLCache *urlCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                         diskCapacity:40 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:urlCache];
    
    [[[XEJAccountManager sharedManager] autoLogin] subscribeNext:^(id x) {
        [[XEJAccountManager sharedManager].isLogin sendNext:x];
    } error:^(NSError *error) {
        //
    }];

    XEJRevealViewModel *viewModel = [XEJRevealViewModel new];
    [[XEJNavigationControllerStackManager sharedManager] resetRootViewModel:viewModel];
    
    

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
