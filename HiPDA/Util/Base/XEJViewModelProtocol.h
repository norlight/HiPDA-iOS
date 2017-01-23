//
//  XEJViewModelProtocol.h
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEJModelProtocol.h"

@protocol XEJViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id<XEJModelProtocol>)model;
- (void)xej_initialize;
- (NSString *)controllerName;  //对应Controller，用于vm route vm

@end
