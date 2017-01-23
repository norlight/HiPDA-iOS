//
//  XEJThreadViewModel.h
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJXEJThreadCellViewModel.h"

@interface XEJThreadViewModel : XEJViewModel

@property (nonatomic, copy) NSArray<XEJXEJThreadCellViewModel *> *dataArray;

@property (nonatomic, strong) RACCommand *fetchDataCommand;
@property (nonatomic, strong) RACCommand *nextPageCommand;

@property (nonatomic, strong) RACSubject *updateUI;
@property (nonatomic, strong) RACSubject *refreshEndSubject;
@property (nonatomic, strong) RACSubject *cellSelectedSubject;

@end
