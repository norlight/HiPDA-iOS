//
//  XEJUtility.m
//  HiPDA
//
//  Created by Blink on 17/1/26.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJUtility.h"

static NSString *const kUidBaseString = @"000000000";
static NSString *const kAvatarSuffixString = @"_avatar_middle.jpg";

@implementation XEJUtility

+ (instancetype)sharedUtility
{
    static XEJUtility *sharedUtility;
    
    if (!sharedUtility) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedUtility = [[XEJUtility alloc] initPrivate];
        });
    }
    return sharedUtility;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例"
                                   reason:[NSString stringWithFormat:@"请使用 +[%@ sharedUtility] 进行初始化", NSStringFromClass([XEJUtility class])]
                                 userInfo:nil];
}






- (NSString *)avatarUrlStringWithUid:(NSString *)uid
{
    NSString *zeroFill = [kUidBaseString substringWithRange:NSMakeRange(0, kUidBaseString.length - uid.length)];
    NSString *fullUid = [NSString stringWithFormat:@"%@%@", zeroFill, uid];
    NSString *part1 = [fullUid substringWithRange:NSMakeRange(0, 3)];
    NSString *part2 = [fullUid substringWithRange:NSMakeRange(3, 2)];
    NSString *part3 = [fullUid substringWithRange:NSMakeRange(5, 2)];
    NSString *part4 = [fullUid substringWithRange:NSMakeRange(7, 2)];
    
    NSString *avatarUrlString = [NSString stringWithFormat:@"%@/%@/%@/%@%@", part1, part2, part3, part4, kAvatarSuffixString];
    
    return avatarUrlString;

}

- (NSString *)filePathWithName:(NSString *)fileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = paths[0];
    return [documentsDirectory stringByAppendingPathComponent:fileName];
}

@end
