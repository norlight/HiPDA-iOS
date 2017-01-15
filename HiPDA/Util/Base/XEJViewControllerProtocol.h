//
//  XEJViewControllerProtocol.h
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEJViewProtocol.h"

@protocol XEJViewControllerProtocol <XEJViewProtocol>

@optional
//vc的viewmodel更多是用来初始化v，暂时去除绑定
//- (void)bindViewModel;
- (void)setupNavigation;

@end
