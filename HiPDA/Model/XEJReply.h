//
//  XEJReply.h
//  HiPDA
//
//  Created by Blink on 17/2/4.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJModel.h"
#import <HTMLKit/HTMLKit.h>

@interface XEJReply : XEJModel

@property (nonatomic, strong) HTMLElement *element;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, assign) NSInteger floor;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *tid;

- (instancetype)initWithElement:(HTMLElement *)element;

@end
