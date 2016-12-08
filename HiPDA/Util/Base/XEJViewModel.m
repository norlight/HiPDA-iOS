//
//  XEJViewModel.m
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import "XEJViewModel.h"

@implementation XEJViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    XEJViewModel *viewModel = [super allocWithZone:zone];
    if (viewModel) {
        [viewModel xej_initialize];
    }
    
    return viewModel;
}

- (void)xej_initialize
{
    //各种共有的初始化放这里
}
@end
