//
//  XEJUser.m
//  HiPDA
//
//  Created by Blink on 17/1/23.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJUser.h"
#import "XEJUtility.h"

@implementation XEJUser

- (NSString *)avatarUrlString
{
    if (!_avatarUrlString && _uid) {
        _avatarUrlString = [[XEJUtility sharedUtility] avatarUrlStringWithUid:_uid];
    }
    
    return _avatarUrlString;
}

@end
