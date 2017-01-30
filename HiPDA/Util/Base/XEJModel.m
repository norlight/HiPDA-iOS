//
//  XEJModel.m
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import "XEJModel.h"

@implementation XEJModel



- (instancetype)initWithElement:(ONOXMLElement *)element
{
    self = [super init];
    if (self) {
        [self xej_initialize];
    }
    
    return self;
}

+ (instancetype)modelWithElement:(ONOXMLElement *)element
{
    return [[self alloc] initWithElement:element];
}

- (void)xej_initialize {}


@end
