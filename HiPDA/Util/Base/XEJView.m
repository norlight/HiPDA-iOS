//
//  XEJView.m
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import "XEJView.h"

@implementation XEJView

- (instancetype)init
{
    return [self initWithViewModel:nil];
}

- (instancetype)initWithViewModel:(id<XEJViewModelProtocol>)viewModel
{
    self = [super init];
    if (self) {
        if ([self respondsToSelector:@selector(setupViews)]) {
            [self setupViews];
        }
        
        if (viewModel && [self respondsToSelector:@selector(bindViewModel:)]) {
            [self bindViewModel:viewModel];
        }
    }
    
    return self;
}



@end
