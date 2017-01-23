//
//  XEJThreadListCell.h
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJTableViewCell.h"
#import "XEJThreadListCellViewModel.h"

@interface XEJThreadListCell : XEJTableViewCell

@property (nonatomic, strong) XEJThreadListCellViewModel *viewModel;

- (void)bindViewModel:(XEJThreadListCellViewModel *)viewModel;

@end
