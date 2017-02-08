//
//  XEJRevealViewController.h
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <SWRevealViewController/SWRevealViewController.h>
#import "XEJViewControllerProtocol.h"
#import "XEJRevealViewModel.h"

@interface XEJRevealViewController : SWRevealViewController <XEJViewControllerProtocol>

@property (nonatomic, strong) XEJRevealViewModel *viewModel;

@end
