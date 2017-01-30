//
//  XEJViewModel.m
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import "XEJViewModel.h"

@implementation XEJViewModel



- (instancetype)init
{
    self = [super init];
    if (self) {
        [self xej_initialize];
    }
    
    return self;
}

- (instancetype)initWithModel:(id<XEJModelProtocol>)model
{
    self = [super init];
    if (self) {
        [self xej_initialize];
    }
    
    return self;
}

- (void)xej_initialize
{
    //各种共有的初始化放这里
}

- (NSString *)controllerName
{
    NSString *viewModelName = NSStringFromClass([self class]);
    return [viewModelName stringByReplacingOccurrencesOfString:@"Model" withString:@"Controller"];
}







@end
