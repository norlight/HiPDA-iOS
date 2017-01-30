//
//  XEJModelProtocol.h
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Ono/Ono.h>

@protocol XEJModelProtocol <NSObject>

@optional
- (instancetype)initWithElement:(ONOXMLElement *)element;
+ (instancetype)modelWithElement:(ONOXMLElement *)element;

- (void)xej_initialize;

@end
