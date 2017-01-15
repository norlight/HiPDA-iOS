//
//  XEJThreadListViewModel.h
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJThreadListCellViewModel.h"

@interface XEJThreadListViewModel : XEJViewModel

@property (nonatomic, copy) NSArray<XEJThreadListCellViewModel *> *dataArray;

@property (nonatomic, strong) RACCommand *fetchDataCommand;
@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACSubject *updateUI;
@property (nonatomic, strong) RACSubject *refreshEndSubject;
@property (nonatomic, strong) RACSubject *cellSelectedSubject;

@end

