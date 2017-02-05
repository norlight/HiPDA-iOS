//
//  XEJObjectViewModelProtocol.h
//  HiPDA
//
//  Created by Blink on 17/2/3.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEJViewModelProtocol.h"

@class HTMLElement;

@protocol XEJObjectViewModelProtocol <XEJViewModelProtocol>

@optional




/**
 *  将原始element裹一层<object>，并添加类型、尺寸等属性
 *
 *  @return append到<object>下的新element
 */
- (HTMLElement *)objectElement;

@end
