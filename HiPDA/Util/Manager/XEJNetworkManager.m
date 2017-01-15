//
//  XEJNetworkManager.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJNetworkManager.h"
#import <AFNetworking/AFNetworking.h>

static NSString *const kBaseURLString = @"https://www.hi-pda.com";

@interface XEJNetworkManager ()

@property (nonatomic, strong) AFHTTPSessionManager *manager;
@property (nonatomic, strong) AFURLSessionManager *urlSessionManager;

@end

@implementation XEJNetworkManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager
{
    static XEJNetworkManager *sharedManager;
    
    if (!sharedManager) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedManager = [[XEJNetworkManager alloc] initPrivate];
        });
    }
    return sharedManager;
}

- (instancetype) initPrivate
{
    self = [super init];
    
    if (self) {
        //占楼
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[[NSURL alloc] initWithString:kBaseURLString]];
        _manager = manager;
        
        //用户代理伪装
        NSString *userAgent = @"Chrome/55";
        [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
        //响应设置
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        urlSessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _urlSessionManager = urlSessionManager;
        
    }
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例"
                                   reason:[NSString stringWithFormat:@"请使用 +[%@ sharedManager] 进行初始化", NSStringFromClass([XEJNetworkManager class])]
                                 userInfo:nil];
}


#pragma mark - Signal
//GET请求
- (RACSignal *)GET:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.manager GET:path
                                            parameters:parameters
                                              progress:nil
                                               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                   RACTuple *tuple = RACTuplePack(task, responseObject);
                                                   [subscriber sendNext:tuple];
                                                   [subscriber sendCompleted];
                                               } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                   [subscriber sendError:error];
                                               }];
        
        //留出取消操作
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }];
    }];
}

//POST请求
- (RACSignal *)POST:(NSString *)path parameters:(NSDictionary *)parameters
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURLSessionDataTask *task = [self.manager POST:path
                                             parameters:parameters
                                               progress:nil
                                                success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                                    RACTuple *tuple = RACTuplePack(task, responseObject);
                                                    [subscriber sendNext:tuple];
                                                    [subscriber sendCompleted];
                                                }
                                                failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                                    [subscriber sendError:error];
                                                }];
        
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }];
    }];
}

//AFHTTPSessionManager的httpRequestSerializer默认为utf-8，且似乎无法直接使用requestSerializer.stringEncoding更改
//只能手动构建request，将body各字段逐个编码
- (RACSignal *)POST:(NSString *)path parameters:(NSDictionary *)parameters encoding:(NSStringEncoding)encoding
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSURL *url = [NSURL URLWithString:path];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"Chrome/55" forHTTPHeaderField:@"User-Agent"];
        [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        //重点
        NSMutableData *bodyData = [NSMutableData new];
        [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *obj, BOOL * _Nonnull stop) {
            NSString *string = [NSString stringWithFormat:@"%@=%@&", key, obj];
            NSData *data = [string dataUsingEncoding:encoding];
            [bodyData appendData:data];
        }];
        [request setHTTPBody:bodyData];
        
        NSURLSessionDataTask *task = [self.urlSessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
            }
            
            RACTuple *tuple = RACTuplePack(task, responseObject);
            [subscriber sendNext:tuple];
            [subscriber sendCompleted];
            
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            if (task.state != NSURLSessionTaskStateCompleted) {
                [task cancel];
            }
        }];
    }];
}

@end
