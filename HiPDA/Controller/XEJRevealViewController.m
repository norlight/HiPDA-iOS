//
//  XEJRevealViewController.m
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJRevealViewController.h"
#import "XEJRearViewController.h"
#import "XEJThreadListViewController.h"
#import "XEJNavigationController.h"

@implementation XEJRevealViewController

- (instancetype)init
{
    return [self initWithViewModel:[XEJRevealViewModel new]];
}

- (instancetype)initWithViewModel:(XEJRevealViewModel *)viewModel
{
    _viewModel = viewModel;
    XEJRearViewController *rearVc = [[XEJRearViewController alloc] initWithViewModel:viewModel.rearViewModel];
    XEJThreadListViewController *frontVc = [[XEJThreadListViewController alloc] initWithViewModel:(XEJThreadListViewModel *)viewModel.frontViewModel];
    
    return [super initWithRearViewController:rearVc frontViewController:[[XEJNavigationController alloc] initWithRootViewController:frontVc]];
}


@end
