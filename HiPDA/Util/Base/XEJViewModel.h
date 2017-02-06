//
//  XEJViewModel.h
//  HiPDA
//
//  Created by Blink on 16/12/8.
//  Copyright © 2016年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XEJViewModelProtocol.h"
#import "XEJNavigationProtocol.h"
#import <ReactiveViewModel/ReactiveViewModel.h>

@interface XEJViewModel : NSObject <XEJViewModelProtocol, XEJNavigationProtocol>

@end
