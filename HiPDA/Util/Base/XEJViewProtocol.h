//
//  XEJViewProtocol.h
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEJViewModelProtocol.h"

@protocol XEJViewProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id<XEJViewModelProtocol>)viewModel;

- (void)xej_initialize;
- (void)setupViews;
- (void)bindViewModel:(id<XEJViewModelProtocol>)viewModel;

@end
