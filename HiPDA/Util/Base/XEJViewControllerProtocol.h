//
//  XEJViewControllerProtocol.h
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEJViewModelProtocol.h"

@protocol XEJViewControllerProtocol <NSObject>

@optional
- (instancetype)initWithViewModel:(id<XEJViewModelProtocol>)viewModel;

- (void)setupViews;
- (void)layoutViews;
- (void)bindViewModel;
- (void)setupNavigation;
- (void)fetchNewData;

@end
