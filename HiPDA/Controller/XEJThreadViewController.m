//
//  XEJThreadViewController.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadViewController.h"
#import "XEJThreadViewModel.h"
#import "XEJThreadView.h"
#import <Masonry/Masonry.h>

@interface XEJThreadViewController ()

@property (nonatomic, strong) XEJThreadViewModel *viewModel;
@property (nonatomic, strong) XEJThreadView *mainView;

@end

@implementation XEJThreadViewController

- (instancetype)init
{
    XEJThread *thread = [XEJThread new];
    thread.tid = @"1905647";
    XEJThreadViewModel *viewModel = [[XEJThreadViewModel alloc] initWithModel:thread];
    return [self initWithViewModel:viewModel];
}

- (instancetype)initWithViewModel:(XEJThreadViewModel *)viewModel
{
    self = [super initWithViewModel:viewModel];
    if (self) {
        _viewModel = viewModel;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)setupViews
{
    self.mainView = ({
        XEJThreadView *view = [[XEJThreadView alloc] initWithViewModel:self.viewModel];
        
        [self.view addSubview:view];
        view;
    });
    
}

- (void)setupNavigation
{
    self.title = @"Thread Detail";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
