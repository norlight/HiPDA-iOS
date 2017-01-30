//
//  XEJThreadListCellViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadListCellViewModel.h"
#import "XEJDateFormatter.h"

@implementation XEJThreadListCellViewModel

- (instancetype)initWithModel:(XEJThread *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    XEJThread *model = _model;
    self.stick = model.stick;
    self.tid = model.tid;
    self.title = model.title;
    self.titleColor = model.titleColor;
    self.username = model.author.username;
    self.createdAtString = [XEJDateFormatter stringFromDate:model.createdAt];
    NSLog(@"%@", self.createdAtString);
    self.replyCountString = [NSString stringWithFormat:@"%ld", model.replyCount];
    self.viewCountString = [NSString stringWithFormat:@"%ld", model.viewCount];
    self.pageCountString = [NSString stringWithFormat:@"%ld", model.pageCount];
    self.hasImageAttach = model.hasImageAttach;
    self.hasCommonAttach = model.hasCommonAttach;
    self.agreed = model.agreed;
    self.digested = model.digested;
    
    self.avatarViewModel = [[XEJAvatarViewModel alloc] initWithModel:model.author];
}

@end
