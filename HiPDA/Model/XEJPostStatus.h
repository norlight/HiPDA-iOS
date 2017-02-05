//
//  XEJPostStatus.h
//  HiPDA
//
//  Created by Blink on 17/2/3.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJModel.h"
#import <HTMLKit/HTMLKit.h>

@interface XEJPostStatus : XEJModel

@property (nonatomic, strong) HTMLElement *element;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, strong) NSDate *updatedAt;

- (instancetype)initWithElement:(HTMLElement *)element;

@end
