//
//  XEJNavigationProtocol.h
//  HiPDA
//
//  Created by Blink on 17/2/6.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XEJViewModel;

@protocol XEJNavigationProtocol <NSObject>

@optional
- (void)pushViewModel:(XEJViewModel *)viewModel animated:(BOOL)animated;
- (void)popViewModelAnimated:(BOOL)animated;
- (void)popToRootViewModelAnimated:(BOOL)animated;
- (void)presentViewModel:(XEJViewModel *)viewModel animated:(BOOL)animated completion:(void(^)())completion;
- (void)dismissViewModelAnimated:(BOOL)animated completion:(void(^)())completion;
- (void)resetRootViewModel:(XEJViewModel *)viewModel;

@end
