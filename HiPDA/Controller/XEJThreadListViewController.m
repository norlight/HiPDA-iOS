//
//  XEJThreadListViewController.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadListViewController.h"
#import "XEJThreadListView.h"
#import "XEJRevealViewController.h"
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>

@interface XEJThreadListViewController ()


@property (nonatomic, strong) XEJThreadListView *mainView;

@end

@implementation XEJThreadListViewController

- (instancetype)init
{
    return [self initWithViewModel:[XEJThreadListViewModel new]];
}

- (instancetype)initWithViewModel:(XEJThreadListViewModel *)viewModel
{
    self = [super initWithViewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
    }
    
    return self;
}

- (void)setupViews
{
    //self.viewModel = [XEJThreadListViewModel new];
    self.mainView = ({
        XEJThreadListView *view = [[XEJThreadListView alloc] initWithViewModel:self.viewModel];
        
        [self.view addSubview:view];
        view;
    });
    
}

- (void)setupNavigation
{
    self.title = self.viewModel.title;
    
    SWRevealViewController *revealController = [self revealViewController];
    [revealController panGestureRecognizer];
    [revealController tapGestureRecognizer];
    
    UIImage *icon = [[UIImage imageNamed:@"icon_reveal"]
                      imageByResizeToSize:CGSizeMake(20, 20) contentMode:UIViewContentModeScaleAspectFit]
                     ;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] bk_initWithImage:icon style:UIBarButtonItemStylePlain handler:^(id sender) {
        [revealController revealToggle:sender];
    }];
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
