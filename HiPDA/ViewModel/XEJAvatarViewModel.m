//
//  XEJAvatarViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJAvatarViewModel.h"

@implementation XEJAvatarViewModel

- (instancetype)initWithModel:(XEJUser *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    self.uid = self.model.uid;
    self.avatarUrlString = [NSString stringWithFormat:@"%@%@", XEJAvatarBaseUrl, self.model.avatarUrlString];
}

@end
