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
- (instancetype)initWithViewModel:(id<XEJViewModelProtocol>)viewModel
{
    self = [super init];
    if (self) {
        //
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupViews];
    [self layoutViews];
    [self bindViewModel];
    
    [self fetchNewData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigation];
}


#pragma mark
- (void)setupViews {};
- (void)layoutViews {};
- (void)bindViewModel {};
- (void)setupNavigation {};
- (void)fetchNewData {};
@end
