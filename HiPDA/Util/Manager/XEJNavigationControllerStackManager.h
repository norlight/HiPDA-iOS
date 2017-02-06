//
//  XEJNavigationControllerStackManager.h
//  HiPDA
//
//  Created by Blink on 17/2/6.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEJViewModel.h"


@interface XEJNavigationControllerStackManager : NSObject

+ (instancetype)sharedManager;
- (void)resetRootViewModel:(XEJViewModel *)viewModel;

@end
