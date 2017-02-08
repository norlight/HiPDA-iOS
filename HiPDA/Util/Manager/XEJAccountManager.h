//
//  XEJAccountManager.h
//  HiPDA
//
//  Created by Blink on 17/2/7.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XEJAccountManager : NSObject

@property (nonatomic, strong) RACReplaySubject *isLogin;

+ (instancetype)sharedManager;

- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password questionId:(NSString *)questionId answer:(NSString *)answer;
- (RACSignal *)signOut;

- (RACSignal *)storeAccountWithUsername:(NSString *)username password:(NSString *)passowrd;
- (RACSignal *)currentAccount;
- (RACSignal *)deleteAccount;

- (RACSignal *)storeSecureInfoWithQuestionId:(NSString *)questionId answer:(NSString *)answer;
- (RACSignal *)currentSecureInfo;
- (RACSignal *)deletestoreSecureInfo;

- (RACSignal *)autoLogin;


@end
