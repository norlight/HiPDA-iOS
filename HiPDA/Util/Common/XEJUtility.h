//
//  XEJUtility.h
//  HiPDA
//
//  Created by Blink on 17/1/26.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XEJUtility : NSObject

+ (instancetype)sharedUtility;

- (NSString *)avatarUrlStringWithUid:(NSString *)uid;
- (NSString *)filePathWithName:(NSString *)fileName;

@end
