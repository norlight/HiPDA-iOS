//
//  XEJThreadListViewController.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadListViewController.h"
#import "XEJThreadListViewModel.h"
#import "XEJThreadListView.h"
#import <Masonry/Masonry.h>

@interface XEJThreadListViewController ()

@property (nonatomic, strong) XEJThreadListViewModel *viewModel;
@property (nonatomic, strong) XEJThreadListView *mainView;

@end

@implementation XEJThreadListViewController

- (void)setupViews
{
    self.viewModel = [XEJThreadListViewModel new];
    self.mainView = ({
        XEJThreadListView *view = [[XEJThreadListView alloc] initWithViewModel:self.viewModel];
        
        [self.view addSubview:view];
        view;
    });
    
}

- (void)setupNavigation
{
    self.title = @"Discovery";
}

- (void)updateViewConstraints
{
    @weakify(self);
    [self.mainView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.view);
    }];
    
    [super updateViewConstraints];
}














@end
