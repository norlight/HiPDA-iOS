//
//  XEJRearViewController.h
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEJViewControllerProtocol.h"
#import "XEJRearViewModel.h"

@interface XEJRearViewController : UITableViewController <XEJViewControllerProtocol>

@property (nonatomic, strong) XEJRearViewModel *viewModel;

- (instancetype) initWithViewModel:(XEJRearViewModel *)viewModel;

@end
