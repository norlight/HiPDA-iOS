//
//  XEJRearViewModel.m
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJRearViewModel.h"
#import "XEJAccountManager.h"

@implementation XEJRearViewModel

- (void)xej_initialize
{
    _forums = ({
        NSMutableArray *array = [NSMutableArray new];
        [array addObject:[self forumWithFid:@"2" title:@"Discovery" private:YES]];
        [array addObject:[self forumWithFid:@"6" title:@"Buy & Sell" private:YES]];
        [array addObject:[self forumWithFid:@"7" title:@"Geek Talks" private:NO]];
        [array addObject:[self forumWithFid:@"59" title:@"E-INK" private:NO]];
        array;
    });
    
    
    _icons = @{
               @"2" : [UIImage imageNamed:@"icon_discovery"],
               @"6" : [UIImage imageNamed:@"icon_buy_and_sell"],
               @"7" : [UIImage imageNamed:@"icon_geek_talks"],
               @"59" : [UIImage imageNamed:@"icon_e_ink"]
               };
    
    _logoutCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        RACSignal *signoutSuccess = [[XEJAccountManager sharedManager] signOut];
        RACSignal *deleteInfo = [[[XEJAccountManager sharedManager] deleteAccount]
        then:^RACSignal *{
            return [[XEJAccountManager sharedManager] deletestoreSecureInfo];
        }];
        return [RACSignal if:signoutSuccess then:deleteInfo else:[RACSignal return:@(false)]];
    }];
    [[_logoutCommand.executionSignals switchToLatest] subscribeNext:^(NSNumber *success) {
        if (success.boolValue) {
            [[XEJAccountManager sharedManager].isLogin sendNext:@(NO)];
        }
    }];
    
    //注意，如果可能转发error的信号不要直接用RAC宏赋值，error直接递过来没处理会崩掉
    //RAC(self, isLogin) = [[XEJAccountManager sharedManager] isLogin];
    [[[XEJAccountManager sharedManager] isLogin] subscribeNext:^(NSNumber *isLogin) {
        //NSLog(@"已登录：%@", isLogin);
        self.isLogin = isLogin.boolValue;
    } error:^(NSError *error) {
        //
    }];
}

- (XEJForum *)forumWithFid:(NSString *)fid title:(NSString *)title private:(BOOL)private
{
    XEJForum *forum = [XEJForum new];
    forum.fid = fid;
    forum.title = title;
    forum.private = private;
    return forum;
}











@end
