//
//  XEJThreadListViewController.h
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewController.h"
#import "XEJThreadListViewModel.h"

@interface XEJThreadListViewController : XEJViewController

@property (nonatomic, strong) XEJThreadListViewModel *viewModel;

- (instancetype)initWithViewModel:(XEJThreadListViewModel *)viewModel;

@end
