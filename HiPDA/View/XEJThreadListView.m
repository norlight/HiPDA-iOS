//
//  XEJThreadListView.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadListView.h"
#import "XEJThreadListViewModel.h"
#import "XEJThreadListCell.h"
#import "XEJTableView.h"
#import <Masonry/Masonry.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

@interface XEJThreadListView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XEJThreadListViewModel *viewModel;
@property (nonatomic, strong) XEJTableView *mainTableView;

@end

@implementation XEJThreadListView

/*
- (instancetype)initWithViewModel:(XEJThreadListViewModel *)viewModel
{
    self.viewModel = viewModel;
    return [super initWithViewModel:viewModel];
}
 */

- (void)setupViews
{
    self.mainTableView = ({
        XEJTableView *tableView = [[XEJTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView registerClass:[XEJThreadListCell class] forCellReuseIdentifier:NSStringFromClass([XEJThreadListCell class])];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [self addSubview:tableView];
        tableView;
    });
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)bindViewModel:(XEJThreadListViewModel *)viewModel
{
    self.viewModel = viewModel;
    [self.viewModel.updateUI subscribeNext:^(id x) {
        [self.mainTableView reloadData];
    }];
    
    [self.viewModel.fetchDataCommand execute:nil];
}

- (void)updateConstraints {
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}


#pragma mark - UITableViewDataSouuce、Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return 3;
    return self.viewModel.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([XEJThreadListCell class])
                                       configuration:^(XEJThreadListCell *cell) {
                                           [cell bindViewModel:self.viewModel.dataArray[indexPath.row]];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEJThreadListCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XEJThreadListCell class])
                                                             forIndexPath:indexPath];
    [cell bindViewModel:self.viewModel.dataArray[indexPath.row]];
    return cell;
}

@end
