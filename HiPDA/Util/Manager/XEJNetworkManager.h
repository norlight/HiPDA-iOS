//
//  XEJNetworkManager.h
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XEJNetworkManager : NSObject

#pragma mark - Life Cycle
+ (instancetype)sharedManager;


#pragma mark - Response Signal
- (RACSignal *)GET:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)POST:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)POST:(NSString *)path parameters:(NSDictionary *)parameters encoding:(NSStringEncoding)encoding;

@end
