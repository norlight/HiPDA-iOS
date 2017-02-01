//
//  XEJThreadViewModel.h
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJThread.h"
#import "XEJThreadCellViewModel.h"

@interface XEJThreadViewModel : XEJViewModel

@property (nonatomic, strong) XEJThread *model;
@property (nonatomic, copy) NSArray<XEJThreadCellViewModel *> *dataArray;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) NSNumber *pageCount;

@property (nonatomic, strong) RACCommand *fetchDataCommand;
@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACSubject *updateUI;
@property (nonatomic, strong) RACSubject *refreshEndSubject;
@property (nonatomic, strong) RACSubject *cellSelectedSubject;

- (instancetype)initWithModel:(XEJThread *)model;

@end
