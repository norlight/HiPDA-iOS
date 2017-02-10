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
#import "XEJRevealViewController.h"
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
                               UIViewController *vc = [self viewControllerForViewModel:viewModel];
                               [self.navigationControllers.lastObject pushViewController:vc animated:animated];
                               
                           }
                                error:nil];
    
    [XEJViewModel aspect_hookSelector:@selector(popViewModelAnimated:)
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
    
    //每次切换front都将旧Nav弹出基础栈，新的压入
    [XEJRevealViewController aspect_hookSelector:@selector(pushFrontViewController:animated:)
                                     withOptions:AspectPositionBefore
                                      usingBlock:^(id<AspectInfo> aspectInfo, UIViewController *frontViewController, BOOL animated){
                                          NSAssert([frontViewController isKindOfClass:[UINavigationController class]], @"front需是Nav");
                                          [self popNavigationController];
                                          [self pushNavigationController:(UINavigationController *)frontViewController];
                                          
                                      }
                                           error:nil];
    
}

- (void)resetRootViewModel:(XEJViewModel *)viewModel
{
    [self.navigationControllers removeAllObjects];
    UIViewController *vc = [self viewControllerForViewModel:viewModel];
    
    //将RevealVc做为RootVc时需要特殊处理
    //倘若当成普通Vc处理在RevealVc外层包Nav做为vm route vm的基础，则front的title会被遮挡
    //所以选择包裹front，将其Nav压入基础栈
    if ([vc isMemberOfClass:[XEJRevealViewController class]]) {
        XEJRevealViewController *revealVc = (XEJRevealViewController *)vc;
        NSAssert([revealVc.frontViewController isKindOfClass:[UINavigationController class]], @"RevealVc做为RootVc时需保证其frontVc为Nav！");
        [self pushNavigationController:(UINavigationController *)revealVc.frontViewController];
        XEJAppDelegate.window.rootViewController = revealVc;
        return;
    }
    
    XEJNavigationController *nav;
    if (![vc isKindOfClass:[UINavigationController class]] &&
        ![vc isKindOfClass:[UITabBarController class]]) {
        nav = [[XEJNavigationController alloc] initWithRootViewController:vc];
        [self pushNavigationController:nav];
    }
    
    XEJAppDelegate.window.rootViewController = nav;
}

- (UIViewController *)viewControllerForViewModel:(XEJViewModel *)viewModel
{
    NSString *controllerName = [viewModel controllerName];
    //NSParameterAssert([NSClassFromString(controllerName) isSubclassOfClass:[XEJViewController class]]);
    NSParameterAssert([NSClassFromString(controllerName) instancesRespondToSelector:@selector(initWithViewModel:)]);
    UIViewController *viewController = [[NSClassFromString(controllerName) alloc] initWithViewModel:viewModel];
    return viewController;
}












@end
