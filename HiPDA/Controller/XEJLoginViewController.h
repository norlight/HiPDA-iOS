//
//  XEJLoginViewController.h
//  HiPDA
//
//  Created by Blink on 17/2/7.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEJViewControllerProtocol.h"
#import "XEJLoginViewModel.h"

@interface XEJLoginViewController : UITableViewController <XEJViewControllerProtocol>

@property (nonatomic, strong) XEJLoginViewModel *viewModel;

- (instancetype)initWithViewModel:(XEJLoginViewModel *)viewModel;

@end
