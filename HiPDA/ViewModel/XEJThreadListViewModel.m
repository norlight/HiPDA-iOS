//
//  XEJThreadListViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadListViewModel.h"
#import "XEJThread.h"
#import "XEJNetworkManager.h"
#import <Ono/Ono.h>
#import <RegexKitLite-NoWarning/RegexKitLite.h>

//static NSString *const kForumPathString = @"forum/forumdisplay.php?fid=%@&page=%ld";

@interface XEJThreadListViewModel ()

@property (nonatomic, strong) XEJThread *model;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XEJThreadListViewModel

- (instancetype)initWithModel:(XEJThread *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    _updateUI = [RACSubject subject];
    _refreshEndSubject = [RACSubject subject];
    _cellSelectedSubject = [RACSubject subject];
 
    [[self.fetchDataCommand.executionSignals switchToLatest] subscribeNext:^(NSArray<XEJThreadListCellViewModel *> *viewModels) {
        //
        /*
        NSLog(@"总数：%ld", threads.count);
        [threads enumerateObjectsUsingBlock:^(XEJThread * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSLog(@"置顶：%d", obj.stick);
            NSLog(@"tid:%@", obj.tid);
            NSLog(@"标题：%@", obj.title);
            NSLog(@"颜色：%@", obj.titleColor);
            NSLog(@"日期：%@", obj.createdAt);
            NSLog(@"回复：%ld", obj.replyCount);
            NSLog(@"查看：%ld", obj.viewCount);
            NSLog(@"页数：%ld", obj.pageCount);
            NSLog(@"图片：%d", obj.hasImageAttach);
            NSLog(@"附件：%d", obj.hasCommonAttach);
            NSLog(@"评分：%d", obj.agreed);
            NSLog(@"精华：%d", obj.digested);
        }];
         */
        
        self.dataArray = viewModels;
        
        [self.updateUI sendNext:nil];
    }];
    [self.fetchDataCommand.errors subscribeNext:^(NSError *error) {
        //
        NSLog(@"错误：%@", error);
    }];
    
}



- (RACCommand *)fetchDataCommand
{
    if (!_fetchDataCommand) {
        _fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.currentPage = 1;
            return [self viewModelsSignal];
        }];
    };
    
    return _fetchDataCommand;
}

- (RACCommand *)nextPageCommand
{
    if (!_nextPageCommand) {
        _nextPageCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.currentPage++;
            return [self viewModelsSignal];
        }];
    }
    
    return _nextPageCommand;
}

- (RACSignal *)viewModelsSignal
{

    NSString *fid = @"59";
    NSNumber *page = @(1);
    NSString *path = [NSString stringWithFormat:XEJForumPath, fid, page];
    return [[[[[[XEJNetworkManager sharedManager] GET:path parameters:nil]
               
               flattenMap:^RACStream *(RACTuple *tuple) {
                   NSData *response = tuple.second;
                   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                       NSError *error = nil;
                       ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithData:response error:&error];
                       error ? [subscriber sendError:error] : [subscriber sendNext:document];
                       return nil;
                   }];
               }]
              
              map:^NSArray<ONOXMLElement *>*(ONOXMLDocument *document) {
                  static NSString *const kThreadXPathString = @".//div[@id='threadlist']/form/table[@class='datatable']/tbody[contains(@id, 'thread')]";
                  NSMutableArray<ONOXMLElement *> *elements = [NSMutableArray new];
                  [document enumerateElementsWithXPath:kThreadXPathString
                                            usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                                [elements addObject:element];
                                            }];
                  return [elements copy];
              }]
             
             map:^NSArray<XEJThread *>*(NSArray<ONOXMLElement *> *elements) {
                 return [[elements.rac_sequence map:^id(ONOXMLElement *element) {
                     XEJThread *thread = [XEJThread modelWithElement:element];
                     thread.fid = self.fid;
                     return thread;
                 }] array];
             }]
            
            map:^NSArray<XEJThreadListCellViewModel *>*(NSArray<XEJThread *> *threads) {
                return [[threads.rac_sequence map:^id(XEJThread *thread) {
                    return [[XEJThreadListCellViewModel alloc] initWithModel:thread];
                }] array];
            }];
    
}















@end
