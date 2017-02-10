//
//  XEJForum.m
//  HiPDA
//
//  Created by Blink on 17/1/23.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJForum.h"

@implementation XEJForum

- (instancetype)init
{
    self = [super init];
    if (self) {
        _fid = @"7";
        _title = @"Geek Talks";
        _private = NO;
    }
    
    return self;
}

@end
