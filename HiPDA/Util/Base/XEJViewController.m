//
//  XEJViewController.m
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import "XEJViewController.h"

@implementation XEJViewController

#pragma mark - Life Cycle
+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    XEJViewController *vc = [super allocWithZone:zone];
    
    @weakify(vc);
    [[vc rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        @strongify(vc);
        [vc setupViews];

        //[vc bindViewModel];
    }];
    
    [[vc rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        [vc setupNavigation];
    }];
    
    return vc;
}
- (instancetype)initWithViewModel:(id<XEJViewModelProtocol>)viewModel
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}






#pragma mark - Setup
- (void)setupViews {};
//- (void)bindViewModel {};
- (void)setupNavigation {};
@end
