//
//  XEJAccountManager.m
//  HiPDA
//
//  Created by Blink on 17/2/7.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJAccountManager.h"
#import "XEJNetworkManager.h"
#import <Ono/Ono.h>
#import <YYKit/YYKit.h>
#import <SAMKeychain/SAMKeychain.h>
#import <RegexKitLite-NoWarning/RegexKitLite.h>

@interface XEJAccountManager ()

@property (nonatomic, strong) RACSignal *formhash;

@end

@implementation XEJAccountManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager
{
    static XEJAccountManager *sharedManager;
    
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[XEJAccountManager alloc] initPrivate];
        });
    }
    
    return sharedManager;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        _isLogin = [RACReplaySubject replaySubjectWithCapacity:1];
        
        NSString *queryString = @"?action=login";
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@", XEJBaseUrl, XEJLoggingPath, queryString];
        _formhash = [[[[XEJNetworkManager sharedManager] GET:urlString parameters:nil]
                      map:^NSString *(RACTuple *tuple) {
                          ONOXMLDocument *doc = [ONOXMLDocument HTMLDocumentWithData:tuple.second error:nil];
                          ONOXMLElement *formhashElement = [doc firstChildWithXPath:@"//form[@id='loginform']/input[@name='formhash']"];
                          return formhashElement[@"value"];
                      }]
                     replayLazily]; //转成热信号，避免副作用
    }
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例"
                                   reason:[NSString stringWithFormat:@"请使用 +[%@ sharedManager] 进行初始化", NSStringFromClass([XEJAccountManager class])]
                                 userInfo:nil];
}

#pragma mark - Request
- (RACSignal *)signInWithUsername:(NSString *)username password:(NSString *)password questionId:(NSString *)questionId answer:(NSString *)answer
{
    return _formhash;
    
    
    return [RACSignal empty];
    
    NSParameterAssert(username);
    NSParameterAssert(password);
    
    [[[self.formhash flattenMap:^RACStream *(NSString *formhash) {
        NSDictionary* bodyParameters = @{
                                         @"loginfield" : @"username",
                                         @"cookietime" : @"2592000",
                                         @"formhash" : formhash,
                                         @"username" : username.md5String,
                                         @"password" : password,
                                         @"questionid" : questionId ?: @"",
                                         @"answer" : answer ?: @""
                                         //@"referer" : @"https://www.hi-pda.com/forum/",
                                         };
        
        
        NSString *queryString = @"?action=login&loginsubmit=yes";
        NSString *urlString = [NSString stringWithFormat:@"%@%@%@", XEJBaseUrl, XEJLoggingPath, queryString];
        return [[XEJNetworkManager sharedManager] POST:urlString parameters:bodyParameters];
    }]
      
      reduceEach:^id(NSURLSessionDataTask *task, id responseObject){
          return responseObject;
      }]
     map:^id(NSData *response) {
         NSString *resString = [[NSString alloc] initWithData:response encoding:XEJEncodingGBK];
         NSLog(@"response:%@", resString);
         return @([resString isMatchedByRegex:@"欢迎您回来"]);
     }];
    
}

- (RACSignal *)signOut
{
    return [[[self.formhash flattenMap:^RACStream *(NSString *formhash) {
        NSString *urlString = [NSString stringWithFormat:@"%@%@", XEJBaseUrl, XEJLoggingPath];
        NSDictionary* queryParameters = @{
                                          @"action":@"logout",
                                          @"formhash":formhash
                                          };
        return [[XEJNetworkManager sharedManager] GET:urlString parameters:queryParameters];
    }]
    map:^id(RACTuple *tuple) {
        return [[NSString alloc] initWithData:tuple[1] encoding:XEJEncodingGBK];
    }]
    map:^id(NSString *resString) {
        return @([resString isMatchedByRegex:@"您已退出论坛"]);
    }];
}



#pragma mark - Keychain
- (RACSignal *)storeAccountWithUsername:(NSString *)username password:(NSString *)passowrd
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error;
        BOOL success = [SAMKeychain setPassword:passowrd forService:XEJBundleID account:username error:&error];
        if (error) {
            [subscriber sendError:error];
        } else {
            [subscriber sendNext:@(success)];
            [subscriber sendCompleted];
        }
        return nil;
    }];
}

//当前用户名、密码
- (RACSignal *)currentAccount
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSError *error;
        SAMKeychainQuery *query = [SAMKeychainQuery new];
        query.service = XEJBundleID;
        [query fetchAll:&error];
        //没找到帐号返回error，并不是返回空数组
        if (error) {
            [subscriber sendError:error];
        }
        
        NSArray *accounts = [SAMKeychain accountsForService:XEJBundleID];
        NSString *firstAccount = accounts[0][@"acct"];  //取得的帐号是键值对
        NSString *password = [SAMKeychain passwordForService:XEJBundleID account:firstAccount];
        [subscriber sendNext:RACTuplePack(firstAccount, password)];
        [subscriber sendCompleted];
        
        return nil;
    }];
}

- (RACSignal *)deleteAccount
{
    return [[self currentAccount] flattenMap:^RACStream *(RACTuple *tuple) {
        NSString *account = tuple.first;
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            NSError *error;
            BOOL success = [SAMKeychain deletePasswordForService:XEJBundleID account:account error:&error];
            if (error) {
                [subscriber sendError:error];
            } else {
                [subscriber sendNext:@(success)];
                [subscriber sendCompleted];
            }
            
            return nil;
        }];
    }];
}

- (RACSignal *)storeSecureInfoWithQuestionId:(NSString *)questionId answer:(NSString *)answer
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:questionId forKey:XEJQuestionIDKey];
        [defaults setObject:answer forKey:XEJAnswerKey];
        BOOL success = [defaults synchronize];
        [subscriber sendNext:@(success)];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)currentSecureInfo
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *questionId = [defaults objectForKey:XEJQuestionIDKey];
        NSString *answer = [defaults objectForKey:XEJAnswerKey];
        RACTuple *tuple = RACTuplePack(questionId, answer);
        [subscriber sendNext:tuple];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)deletestoreSecureInfo
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults removeObjectForKey:XEJQuestionIDKey];
        [defaults removeObjectForKey:XEJAnswerKey];
        BOOL success = [defaults synchronize];
        [subscriber sendNext:@(success)];
        [subscriber sendCompleted];
        return nil;
    }];
}

- (RACSignal *)autoLogin
{
    return [[RACSignal combineLatest:@[[self currentAccount], [self currentSecureInfo]]
                              reduce:^id(RACTuple *accountInfo, RACTuple *secureInfo){
                                  NSString *username = accountInfo.first;
                                  NSString *password = accountInfo.second;
                                  NSString *questionId = secureInfo.first;
                                  NSString *answer = secureInfo.second;
                                  RACTuple *tuple = RACTuplePack(username, password, questionId, answer);
                                  return tuple;
                              }]
            
            flattenMap:^RACStream *(RACTuple *tuple) {
                RACTupleUnpack(NSString *username, NSString *password, NSString *questionId, NSString *answer) = tuple;
                return [self signInWithUsername:username password:password questionId:questionId answer:answer];
            }];
    
    
    
}



















@end
