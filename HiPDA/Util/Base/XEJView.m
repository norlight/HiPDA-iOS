//
//  XEJView.m
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import "XEJView.h"

@implementation XEJView

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        [self setupViews];
        [self layoutViews];
        [self bindViewModel];
    }
    
    return self;
}

- (instancetype)init
{
    return [self initPrivate];
}

- (instancetype)initWithViewModel:(id<XEJViewModelProtocol>)viewModel
{
    return [self initPrivate];
}

- (void)setupViews {};
- (void)layoutViews {};
- (void)bindViewModel {};

@end
