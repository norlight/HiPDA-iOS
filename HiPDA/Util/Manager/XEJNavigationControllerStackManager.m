//
//  XEJNavigationControllerStackManager.m
//  HiPDA
//
//  Created by Blink on 17/2/6.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJNavigationControllerStackManager.h"
#import "AppDelegate.h"
#import "XEJNavigationController.h"
#import "XEJViewController.h"
#import <AspectsV1.4.2/Aspects.h>

@interface XEJNavigationControllerStackManager ()

@property (nonatomic, strong) NSMutableArray *navigationControllers;

@end

@implementation XEJNavigationControllerStackManager

+ (instancetype)sharedManager
{
    static XEJNavigationControllerStackManager *sharedManager;
    
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[XEJNavigationControllerStackManager alloc] initPrivate];
        });
    }
    return sharedManager;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        self.navigationControllers = [NSMutableArray new];
        [self registerNavigationHooks];
    }
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例"
                                   reason:[NSString stringWithFormat:@"请使用 +[%@ sharedManager] 进行初始化", NSStringFromClass([XEJNavigationControllerStackManager class])]
                                 userInfo:nil];
}

- (void)pushNavigationController:(UINavigationController *)navigationController {
    if ([self.navigationControllers containsObject:navigationController]) return;
    [self.navigationControllers addObject:navigationController];
}

- (UINavigationController *)popNavigationController {
    UINavigationController *navigationController = self.navigationControllers.lastObject;
    [self.navigationControllers removeLastObject];
    return navigationController;
}

- (UINavigationController *)topNavigationController {
    return self.navigationControllers.lastObject;
}

- (void)registerNavigationHooks
{
    @weakify(self);
    [XEJViewModel aspect_hookSelector:@selector(pushViewModel:animated:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo, XEJViewModel *viewModel, BOOL animated) {
                               @strongify(self);
                               XEJViewController *vc = [self viewControllerForViewModel:viewModel];
                               [self.navigationControllers.lastObject pushViewController:vc animated:animated];
                               
                           }
                                error:nil];
    
    [XEJViewModel aspect_hookSelector:@selector(popViewControllerAnimated:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
                               @strongify(self);
                               [self.navigationControllers.lastObject popViewControllerAnimated:animated];
                           }
                                error:nil];
    
    [XEJViewModel aspect_hookSelector:@selector(popToRootViewModelAnimated:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
                               @strongify(self);
                               [self.navigationControllers.lastObject popToRootViewControllerAnimated:animated];
                           }
                                error:nil];
    
    [XEJViewModel aspect_hookSelector:@selector(presentViewModel:animated:completion:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo, XEJViewModel *viewModel, BOOL animated, void(^completion)()) {
                               @strongify(self);
                               UIViewController *viewController = [self viewControllerForViewModel:viewModel];
                               UINavigationController *presentingViewController = self.navigationControllers.lastObject;
                               //裹一层Nav，present出来的视图结构应该有自己的Nav栈
                               if (![viewController isKindOfClass:UINavigationController.class]) {
                                   viewController = [[XEJNavigationController alloc] initWithRootViewController:viewController];
                               }
                               //先push到基础栈，以便即便在新的Nav栈内也可以在各处直接用lastObject来push
                               [self pushNavigationController:(UINavigationController *)viewController];
                               [presentingViewController presentViewController:viewController animated:animated completion:completion];
                           }
                                error:nil];
    
    [XEJViewModel aspect_hookSelector:@selector(dismissViewModelAnimated:completion:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated, void(^completion)()) {
                               @strongify(self)
                               [self popNavigationController];
                               [self.navigationControllers.lastObject dismissViewControllerAnimated:animated completion:completion];
                           }
                                error:nil];
    
    [XEJViewModel aspect_hookSelector:@selector(resetRootViewModel:)
                          withOptions:AspectPositionAfter
                           usingBlock:^(id<AspectInfo> aspectInfo, XEJViewModel *viewModel) {
                               @strongify(self);
                               [self resetRootViewModel:viewModel];
                           }
                                error:nil];
    
}

- (void)resetRootViewModel:(XEJViewModel *)viewModel
{
    XEJViewController *vc = [self viewControllerForViewModel:viewModel];
    [self.navigationControllers removeAllObjects];
    XEJNavigationController *nav;
    if (![vc isKindOfClass:[UINavigationController class]] &&
        ![vc isKindOfClass:[UITabBarController class]]) {
        nav = [[XEJNavigationController alloc] initWithRootViewController:vc];
        [self pushNavigationController:nav];
    }
    
    XEJAppDelegate.window.rootViewController = nav;
}

- (XEJViewController *)viewControllerForViewModel:(XEJViewModel *)viewModel
{
    NSString *controllerName = [viewModel controllerName];
    NSParameterAssert([NSClassFromString(controllerName) isSubclassOfClass:[XEJViewController class]]);
    NSParameterAssert([NSClassFromString(controllerName) instancesRespondToSelector:@selector(initWithViewModel:)]);
    XEJViewController *viewController = [[NSClassFromString(controllerName) alloc] initWithViewModel:viewModel];
    return viewController;
}












@end
