//
//  XEJRevealViewModel.m
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJRevealViewModel.h"
#import "XEJThreadListViewModel.h"

@implementation XEJRevealViewModel

- (instancetype)init
{
    _rearViewModel = [XEJRearViewModel new];
    _frontViewModel = [XEJThreadListViewModel new];
    return [super init];
}

@end
