//
//  XEJLockedObject.h
//  HiPDA
//
//  Created by Blink on 17/2/3.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJModel.h"
#import <HTMLKit/HTMLKit.h>

@interface XEJLocked : XEJModel

@property (nonatomic, strong) HTMLElement *element;

- (instancetype)initWithElement:(HTMLElement *)element;

@end
