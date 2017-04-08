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
#import <MJRefresh/MJRefresh.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
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
        //注意MVVM下tableView的视图层次，vc-view-view-tableview，自由定制时一些非预期情况需要注意
        //tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
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
    @weakify(self);
    [self.viewModel.updateUI subscribeNext:^(id x) {
        [self.mainTableView reloadData];
    }];
    
    self.mainTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.fetchDataCommand execute:nil];
    }];
    self.mainTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        @strongify(self);
        [self.viewModel.nextPageCommand execute:nil];
    }];
    self.mainTableView.mj_footer.hidden = YES;
    
    [[self.viewModel.fetchDataCommand.executing skip:1] subscribeNext:^(NSNumber *executing) {
        self.mainTableView.mj_footer.hidden = executing.boolValue;
        
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            
        } else {
            [MBProgressHUD hideHUDForView:self animated:YES];
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
            
            [JDStatusBarNotification showWithStatus:@"刷新成功" dismissAfter:2 styleName:@"JDStatusBarStyleSuccess"];
        }
    }];
    
    [[self.viewModel.nextPageCommand.executing skip:1] subscribeNext:^(NSNumber *executing) {
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self animated:YES];
            
        } else {
            [MBProgressHUD hideHUDForView:self animated:YES];
            [self.mainTableView.mj_header endRefreshing];
            [self.mainTableView.mj_footer endRefreshing];
        }
    }];

    [[self.viewModel.fetchDataCommand.errors merge:self.viewModel.nextPageCommand.errors] subscribeNext:^(id x) {
        [self.mainTableView.mj_header endRefreshing];
        [self.mainTableView.mj_footer endRefreshing];
        [JDStatusBarNotification showWithStatus:@"刷新失败" dismissAfter:2 styleName:@"JDStatusBarStyleError"];

    }];
    
    [self.viewModel.fetchDataCommand execute:nil];
}

- (void)updateConstraints {
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [super updateConstraints];
}


#pragma mark - UITableViewDataSource、Delegate
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.viewModel.cellSelectedSubject sendNext:indexPath];
}

@end
