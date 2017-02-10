//
//  XEJRearViewController.m
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJRearViewController.h"
#import "XEJThreadListViewController.h"
#import "XEJNavigationController.h"
#import "XEJLoginViewModel.h"
#import <YYKit/YYKit.h>
#import <RETableViewManager/RETableViewManager.h>
#import <SWRevealViewController/SWRevealViewController.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>

@interface XEJRearViewController () <RETableViewManagerDelegate>

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *forumsSection;
@property (nonatomic, strong) RETableViewSection *logoutSection;

@property (nonatomic, strong) RETableViewItem *loggingItem;

@end


@implementation XEJRearViewController

- (instancetype)init
{
    return [self initWithViewModel:[XEJRearViewModel new]];
}

- (instancetype)initWithViewModel:(XEJRearViewModel *)viewModel
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _viewModel = viewModel;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    [self bindViewModel:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    //[self.navigationController setNavigationBarHidden:YES animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (void)setupViews
{
    //@weakify(self);
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    self.manager =({
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
        manager.style.cellHeight = 44;
        
        manager;
    });
    
    self.forumsSection = ({
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"版块"];
        section.footerHeight = 0.1f;
        
        [self.manager addSection:section];
        section;
    });
    
    self.logoutSection = ({
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@"设置"];
        
        [self.manager addSection:section];
        section;
    });
    
    
    
    self.loggingItem = ({
        RETableViewItem *item = [RETableViewItem itemWithTitle:@"" accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
            [item deselectRowAnimated:YES];
            if (self.viewModel.isLogin) {
                UIAlertView *alertView = [UIAlertView bk_showAlertViewWithTitle:@"退出登录" message:@"确定登出并清除当前用户登录信息？" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                    switch (buttonIndex) {
                        case 1:
                            //登出
                            [_viewModel.logoutCommand execute:nil];
                            break;
                            
                        default:
                            break;
                    }
                }];
                [alertView show];
                
            } else {
                [self.viewModel presentViewModel:[XEJLoginViewModel new] animated:YES completion:nil];
            }
        }];
        item.image = [[UIImage imageNamed:@"icon_exit"] imageByTintColor:XEJMainColor];
        
        [self.logoutSection addItem:item];
        item;
    });
}

- (void)bindViewModel:(XEJRearViewModel *)viewModel
{
    @weakify(self);
    [viewModel.forums enumerateObjectsUsingBlock:^(XEJForum * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RETableViewItem *item = [RETableViewItem itemWithTitle:obj.title accessoryType:UITableViewCellAccessoryNone selectionHandler:^(RETableViewItem *item) {
            [item deselectRowAnimated:YES];
            if (obj.private && !viewModel.isLogin) {
                NSLog(@"对不起，您还未登录，无权访问该版块。");
                [self.viewModel presentViewModel:[XEJLoginViewModel new] animated:YES completion:nil];
                return;
            }
            
            XEJThreadListViewModel *frontViewModel = [[XEJThreadListViewModel alloc] initWithModel:obj];
            XEJThreadListViewController *frontVc = [[XEJThreadListViewController alloc] initWithViewModel:frontViewModel];
            XEJNavigationController *nav = [[XEJNavigationController alloc] initWithRootViewController:frontVc];
            [self.revealViewController pushFrontViewController:nav animated:YES];
        }];
        item.image = [viewModel.icons[obj.fid] imageByTintColor:XEJMainColor];
        [self.forumsSection addItem:item];
    }];
    
    [RACObserve(viewModel, isLogin) subscribeNext:^(NSNumber *isLogin) {
        @strongify(self);
        self.loggingItem.title = isLogin.boolValue ? @"退出" : @"登录";
        [self.loggingItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    [[viewModel.logoutCommand.executionSignals switchToLatest] subscribeNext:^(NSNumber *success) {
        if (success.boolValue) {
            [JDStatusBarNotification showWithStatus:@"退出成功" dismissAfter:2 styleName:@"JDStatusBarStyleSuccess"];
        } else {
            [JDStatusBarNotification showWithStatus:@"退出失败" dismissAfter:2 styleName:@"JDStatusBarStyleError"];
        }
        
    }];
    
}

















@end
