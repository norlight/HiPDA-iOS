//
//  XEJThreadView.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadView.h"
#import "XEJThreadViewModel.h"

#import "XEJTableView.h"
#import "XEJThreadCell.h"
#import "XEJThreadContentQuoteView.h"


#import <Masonry/Masonry.h>
#import <DTCoreText/DTCoreText.h>
#import <UITableView+FDTemplateLayoutCell/UITableView+FDTemplateLayoutCell.h>

@interface XEJThreadView () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) XEJThreadViewModel *viewModel;
@property (nonatomic, strong) XEJTableView *mainTableView;

@end

@implementation XEJThreadView

- (void)setupViews
{
    self.mainTableView = ({
        XEJTableView *tableView = [[XEJTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        [tableView registerClass:[XEJThreadCell class] forCellReuseIdentifier:NSStringFromClass([XEJThreadCell class])];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        [self addSubview:tableView];
        tableView;
    });
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)bindViewModel:(XEJThreadViewModel *)viewModel
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
    return self.viewModel.dataArray[indexPath.row].cellHeight;
    return 300;
    return [tableView fd_heightForCellWithIdentifier:NSStringFromClass([XEJThreadCell class])
                                       configuration:^(XEJThreadCell *cell) {
                                           [cell bindViewModel:self.viewModel.dataArray[indexPath.row]];
                                       }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    XEJThreadCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([XEJThreadCell class])
                                                              forIndexPath:indexPath];
    [cell bindViewModel:self.viewModel.dataArray[indexPath.row]];
    return cell;
}

@end
