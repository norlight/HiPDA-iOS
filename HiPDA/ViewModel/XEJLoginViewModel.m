//
//  XEJLoginViewModel.m
//  HiPDA
//
//  Created by Blink on 17/2/7.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJLoginViewModel.h"
#import "XEJAccountManager.h"

@implementation XEJLoginViewModel

- (void)xej_initialize
{
    
    RACSignal *usernameValid = [RACSignal return:@(self.username.length)];
    RACSignal *passwordValid = [RACSignal return:@(self.password.length)];
    __unused RACSignal *enabled = [RACSignal combineLatest:@[usernameValid, passwordValid] reduce:^id(NSNumber *usernameValid, NSNumber *passwordValid){
        return @(usernameValid.boolValue && passwordValid.boolValue);
    }];
    

    
    self.loginCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signInSuccess = [[XEJAccountManager sharedManager] signInWithUsername:_username
                                                                                password:_username
                                                                              questionId:_questionId
                                                                                  answer:_answer];
        RACSignal *storeInfo = [[[XEJAccountManager sharedManager] storeAccountWithUsername:_username
                                                                                   password:_password]
                                then:^RACSignal *{
                                    return [[XEJAccountManager sharedManager] storeSecureInfoWithQuestionId:_questionId
                                                                                                     answer:_answer];
                                }];
        return [RACSignal if:signInSuccess then: storeInfo else:[RACSignal return:@(false)]];
    }];
    
    [[self.loginCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        NSLog(@"%@", x);
        /*
        if (success.boolValue) {
            [[XEJAccountManager sharedManager].isLogin sendNext:@(YES)];
            //pop to normal viewModel
        } else {
            [[XEJAccountManager sharedManager].isLogin sendNext:@(NO)];
            //show notify
        }
         */
    }];
    
    [self.loginCommand.errors subscribeNext:^(NSError *error) {
        NSLog(@"something wrong：%@", error);
    }];
}

@end
