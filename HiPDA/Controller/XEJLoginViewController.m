//
//  XEJLoginViewController.m
//  HiPDA
//
//  Created by Blink on 17/2/7.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJLoginViewController.h"
#import <YYKit/YYKit.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import <RETableViewManager/RETableViewManager.h>
#import <JDStatusBarNotification/JDStatusBarNotification.h>
#import <RETableViewManager/RETableViewOptionsController.h>

@interface XEJLoginViewController () <RETableViewManagerDelegate>

@property (nonatomic, strong) RETableViewManager *manager;
@property (nonatomic, strong) RETableViewSection *basicControlsSection;
@property (nonatomic, strong) RETableViewSection *buttonSection;

@property (nonatomic, strong) RETextItem *usernameItem;
@property (nonatomic, strong) RETextItem *passwordItem;
@property (nonatomic, strong) RERadioItem *questionItem;
@property (nonatomic, strong) RETextItem *answerItem;
@property (nonatomic, strong) RETableViewItem *loginItem;

@end


@implementation XEJLoginViewController

- (instancetype)init
{
    return [self initWithViewModel:[XEJLoginViewModel new]];
}

- (instancetype)initWithViewModel:(XEJLoginViewModel *)viewModel
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
    self.title = @"用户登录";
    
    [self setupViews];
    [self bindViewModel:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupNavigation];
}

- (void)setupViews
{
    @weakify(self);
    self.tableView.backgroundView = nil;
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];

    self.manager =({
        RETableViewManager *manager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self];
        manager.style.cellHeight = 44;

        UIImage *backgroundImage = [UIImage imageWithColor:[UIColor whiteColor]
                                                      size:CGSizeMake(40, 40)];
        UIImage *first = [ backgroundImage imageByRoundCornerRadius:4.0f
                                                            corners:UIRectCornerTopLeft | UIRectCornerTopRight
                                                        borderWidth:0.8f
                                                        borderColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                     borderLineJoin:kCGLineJoinRound];

        UIImage *middle = [backgroundImage imageByRoundCornerRadius:0.0f
                                                        borderWidth:0.8f
                                                        borderColor:[UIColor colorWithWhite:0.85f alpha:1.0f]];

        UIImage *last = [backgroundImage imageByRoundCornerRadius:4.0f
                                                          corners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                      borderWidth:0.8f
                                                      borderColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                   borderLineJoin:kCGLineJoinRound];
        
        UIImage *single = [backgroundImage imageByRoundCornerRadius:4.0f
                                                            corners:UIRectCornerAllCorners
                                                        borderWidth:0.8f
                                                        borderColor:[UIColor colorWithWhite:0.85f alpha:1.0f]
                                                     borderLineJoin:kCGLineJoinRound];
        
        [manager.style setBackgroundImage:[first resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                   forCellType:RETableViewCellTypeFirst];
        [manager.style setBackgroundImage:[middle resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                   forCellType:RETableViewCellTypeMiddle];
        [manager.style setBackgroundImage:[last resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                   forCellType:RETableViewCellTypeLast];
        [manager.style setBackgroundImage:[single resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                   forCellType:RETableViewCellTypeSingle];
        [manager.style setSelectedBackgroundImage:[first resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                           forCellType:RETableViewCellTypeFirst];
        [manager.style setSelectedBackgroundImage:[middle resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                           forCellType:RETableViewCellTypeMiddle];
        [manager.style setSelectedBackgroundImage:[last resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                           forCellType:RETableViewCellTypeLast];
        [manager.style setSelectedBackgroundImage:[single resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)]
                                           forCellType:RETableViewCellTypeSingle];
        manager.style.backgroundImageMargin = 10.0f;
        
        
        manager;
    });
    
    
    
    //用户名、密码、安全问题部分
    self.basicControlsSection = ({
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@" "];
        
        self.usernameItem = ({
            RETextItem *item = [RETextItem itemWithTitle:@"用户名" value:nil];
            
            [section addItem:item];
            item;
        });
        
        self.passwordItem = ({
            RETextItem *item = [RETextItem itemWithTitle:@"密码" value:nil];
            item.secureTextEntry = YES;
            
            [section addItem:item];
            item;
        });
        
        self.questionItem = ({
            @strongify(self);
            RERadioItem *item = [RERadioItem itemWithTitle:@"安全提问" value:@"无" selectionHandler:^(RERadioItem *item) {
                //
                [item deselectRowAnimated:YES];
                NSArray *questions = @[@"无",
                                       @"母亲的名字",
                                       @"爷爷的名字",
                                       @"父亲出生的城市",
                                       @"您其中一位老师的名字",
                                       @"您个人计算机的型号",
                                       @"您最喜欢的餐馆名称",
                                       @"驾驶执照后四位数字"];
                

                RETableViewOptionsController *optionsController = [[RETableViewOptionsController alloc] initWithItem:item options:questions multipleChoice:NO completionHandler:^(RETableViewItem *selectedItem){
                    [self.navigationController popViewControllerAnimated:YES];
                    
                    [item reloadRowWithAnimation:UITableViewRowAnimationNone];
                }];
                
              
                optionsController.delegate = self;
                optionsController.style = section.style;
                if (self.tableView.backgroundView == nil) {
                    optionsController.tableView.backgroundColor = self.tableView.backgroundColor;
                    optionsController.tableView.backgroundView = nil;
                }
                

                [self.navigationController pushViewController:optionsController animated:YES];
            }];
            
            [section addItem:item];
            item;
        });
        
        self.answerItem = ({
            RETextItem *item = [RETextItem itemWithTitle:@"答案" value:nil placeholder:@"无"];
            
            [section addItem:item];
            item;
        });
        
        [self.manager addSection:section];
        section;
    });
    
    //登录按钮部分
    self.buttonSection = ({
        RETableViewSection *section = [RETableViewSection sectionWithHeaderTitle:@" "];
        
        self.loginItem = ({
            RETableViewItem *item = [RETableViewItem itemWithTitle:@"登录"];
            item.textAlignment = NSTextAlignmentCenter;
            
            [section addItem:item];
            item;
        });
        
        [self.manager addSection:section];
        section;
    });
}

- (void)bindViewModel:(XEJLoginViewModel *)viewModel
{
    @weakify(self);
    RAC(viewModel, username) = RACObserve(self.usernameItem, value);
    RAC(viewModel, password) = RACObserve(self.passwordItem, value);
    RAC(viewModel, questionId) = [[RACObserve(self.questionItem, value) ignore:@"无"] map:^NSString *(NSString *question){
        NSDictionary *mapping = @{
                                  @"母亲的名字" : @"1",
                                  @"爷爷的名字" : @"2",
                                  @"父亲出生的城市" : @"3",
                                  @"您其中一位老师的名字" : @"4",
                                  @"您个人计算机的型号" : @"5",
                                  @"您最喜欢的餐馆名称" : @"6",
                                  @"驾驶执照后四位数字" : @"7"
            
        };
        return mapping[question];
    }];
    RAC(viewModel, answer) = RACObserve(self.answerItem, value);
    
    //RAC(self.loginItem, enabled) = [viewModel.loginCommand.enabled startWith:@(NO)];
    
    [[viewModel.loginCommand.executing skip:1] subscribeNext:^(NSNumber *executing) {
        @strongify(self);
        if (executing.boolValue) {
            [MBProgressHUD showHUDAddedTo:self.tableView animated:YES];
            
        } else {
            [MBProgressHUD hideHUDForView:self.tableView animated:YES];
        }
        self.loginItem.title = executing.boolValue ? @"正在登录..." : @"登录";
        [self.loginItem reloadRowWithAnimation:UITableViewRowAnimationAutomatic];
    }];
    [[viewModel.loginCommand.executionSignals switchToLatest] subscribeNext:^(NSNumber *success) {
        if (success.boolValue) {
            [JDStatusBarNotification showWithStatus:@"登录成功" dismissAfter:2 styleName:@"JDStatusBarStyleSuccess"];
        } else {
            [JDStatusBarNotification showWithStatus:@"登录失败" dismissAfter:2 styleName:@"JDStatusBarStyleError"];
        }
        
    }];
    [viewModel.loginCommand.errors subscribeNext:^(id x) {
        [JDStatusBarNotification showWithStatus:@"登录出错" dismissAfter:2 styleName:@"JDStatusBarStyleError"];
    }];
    
    self.loginItem.selectionHandler = ^(RETableViewItem *item) {
        [viewModel.loginCommand execute:nil];
    };
}


- (void)setupNavigation
{

    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.dismissCommand;
}




@end
