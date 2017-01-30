//
//  XEJUser.h
//  HiPDA
//
//  Created by Blink on 17/1/23.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJModel.h"

@interface XEJUser : XEJModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *avatarUrlString;

//- (instancetype)initWithUid:(NSString *)uid;

@end
