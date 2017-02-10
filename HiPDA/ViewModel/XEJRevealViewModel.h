//
//  XEJRevealViewModel.h
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJRearViewModel.h"

@interface XEJRevealViewModel : XEJViewModel

@property (nonatomic, strong) XEJRearViewModel *rearViewModel;
@property (nonatomic, strong) XEJViewModel *frontViewModel;

@end
