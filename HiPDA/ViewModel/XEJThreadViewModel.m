//
//  XEJThreadViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadViewModel.h"
#import "XEJPost.h"
#import "XEJNetworkManager.h"


@interface XEJThreadViewModel ()

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSNumber *pageCount;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XEJThreadViewModel



- (instancetype)initWithModel:(id<XEJModelProtocol>)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    _updateUI = [RACSubject subject];
    _refreshEndSubject = [RACSubject subject];
    _cellSelectedSubject = [RACSubject subject];
    
    [[self.fetchDataCommand.executionSignals switchToLatest] subscribeNext:^(id x) {
        
    }];
    [self.fetchDataCommand.errors subscribeNext:^(id x) {
        //
        NSLog(@"出错：%@", x);
    }];
    
}

- (RACCommand *)fetchDataCommand
{
    if (!_fetchDataCommand) {
        _fetchDataCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            self.currentPage = 1;
            return [self viewModelsSignal];
        }];
    }
    return _fetchDataCommand;
}

- (RACSignal *)viewModelsSignal
{
    NSString *path = [NSString stringWithFormat:XEJThreadPath, self.model.tid, @(self.currentPage)];
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
              
              doNext:^(ONOXMLDocument *document) {
                  //标题
                  self.title = [document firstChildWithXPath:@"//div[@id='threadtitle']/h1/text()"].stringValue;
                  //页数
                  ONOXMLElement *pageCountElement = [document firstChildWithXPath:@"//div[@class='forumcontrol']//div[@class='pages']"];
                  if (pageCountElement) {
                      self.pageCount = [[[[pageCountElement childrenWithTag:@"a"] rac_sequence]
                                        map:^id(ONOXMLElement *element) {
                                            return element.stringValue;
                                        }]
                                        filter:^BOOL(NSString *numString) {
                                            return numString.integerValue;
                                        }].array.lastObject;
                  } else {
                      self.pageCount = @(1);
                  }
                  
                  //todo
                  //您有新的消息
                  
              }]
             
             map:^id(ONOXMLDocument *document) {
                 static NSString *const kPostXPathString = @".//div[@id='postlist']/div[contains(@id, 'post_')]";
                 NSMutableArray<ONOXMLElement *> *elements = [NSMutableArray new];
                 [document enumerateElementsWithXPath:kPostXPathString
                                           usingBlock:^(ONOXMLElement *element, NSUInteger idx, BOOL *stop) {
                                               [elements addObject:element];
                                           }];
                 return [elements copy];
             }]
            
            map:^NSArray<XEJPost *>*(NSArray<ONOXMLElement *> *elements) {
                return [[elements.rac_sequence map:^id(ONOXMLElement *element) {
                    return [XEJPost modelWithElement:element];
                }] array];
            }];
    
}
















@end
