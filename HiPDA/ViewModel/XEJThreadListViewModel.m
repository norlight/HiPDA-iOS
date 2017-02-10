//
//  XEJThreadListViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadListViewModel.h"
#import "XEJThreadViewModel.h"
#import "XEJNetworkManager.h"
#import <Ono/Ono.h>
#import <RegexKitLite-NoWarning/RegexKitLite.h>

//static NSString *const kForumPathString = @"forum/forumdisplay.php?fid=%@&page=%ld";

@interface XEJThreadListViewModel ()


@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation XEJThreadListViewModel

- (instancetype)init
{
    _model = [XEJForum new];
    return [super init];
}

- (instancetype)initWithModel:(XEJForum *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    @weakify(self);
    _updateUI = [RACSubject subject];
    _refreshEndSubject = [RACSubject subject];
    _cellSelectedSubject = [RACSubject subject];
    
    _fid = _model.fid;
    _title = _model.title;
    _private = _model.private;
    
    [_cellSelectedSubject subscribeNext:^(NSIndexPath *indexPath) {
        @strongify(self);
        XEJThreadListCellViewModel *cellViewModel = self.dataArray[indexPath.row];
        XEJThreadViewModel *viewModel = [[XEJThreadViewModel alloc] initWithModel:cellViewModel.model];
        [self pushViewModel:viewModel animated:YES];
    }];
 
    [[self.fetchDataCommand.executionSignals switchToLatest] subscribeNext:^(NSArray<XEJThreadListCellViewModel *> *viewModels) {

        
        self.dataArray = viewModels;
        
        [self.updateUI sendNext:self];
    }];
    [self.fetchDataCommand.errors subscribeNext:^(NSError *error) {
        //
        NSLog(@"错误：%@", error);
    }];
    
    [[self.nextPageCommand.executionSignals switchToLatest] subscribeNext:^(NSArray<XEJThreadListCellViewModel *> *viewModels) {
        NSMutableArray *array = [NSMutableArray arrayWithArray:self.dataArray];
        [array addObjectsFromArray:viewModels];
        self.dataArray = array;
        
        [self.updateUI sendNext:self];
    }];
    [self.nextPageCommand.errors subscribeNext:^(NSError *error) {
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

    //NSString *fid = @"59";
    //NSNumber *page = @(1);
    NSString *path = [NSString stringWithFormat:XEJForumPath, _fid, @(_currentPage)];
    //NSLog(@"%@", _fid);
    return [[[[[[XEJNetworkManager sharedManager] GET:path parameters:nil]
               
               flattenMap:^RACStream *(RACTuple *tuple) {
                   NSData *response = tuple.second;
                   return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                       NSError *error = nil;
                       ONOXMLDocument *document = [ONOXMLDocument HTMLDocumentWithData:response error:&error];
                       //NSLog(@"%@", document.description);
                       //error ? [subscriber sendError:error] : [subscriber sendNext:document];
                       if (error) {
                           [subscriber sendError:error];
                       }
                       
                       [subscriber sendNext:document];
                       [subscriber sendCompleted];
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
