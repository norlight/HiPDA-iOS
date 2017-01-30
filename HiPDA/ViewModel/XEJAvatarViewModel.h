//
//  XEJAvatarViewModel.h
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJUser.h"

@interface XEJAvatarViewModel : XEJViewModel

@property (nonatomic, strong) XEJUser *model;

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *avatarUrlString;

- (instancetype)initWithModel:(XEJUser *)model;

@end
