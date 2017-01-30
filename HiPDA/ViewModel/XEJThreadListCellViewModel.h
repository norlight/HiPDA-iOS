//
//  XEJThreadListCellViewModel.h
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJAvatarViewModel.h"
#import "XEJThread.h"

@interface XEJThreadListCellViewModel : XEJViewModel

@property (nonatomic, strong) XEJThread *model;

@property (nonatomic, strong) XEJAvatarViewModel *avatarViewModel;

@property (nonatomic, copy) NSString *fid;

@property (nonatomic, assign) BOOL stick;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *createdAtString;
@property (nonatomic, copy) NSString *replyCountString;
@property (nonatomic, copy) NSString *viewCountString;
@property (nonatomic, copy) NSString *pageCountString;
@property (nonatomic, assign) BOOL hasImageAttach;
@property (nonatomic, assign) BOOL hasCommonAttach;
@property (nonatomic, assign) BOOL agreed;
@property (nonatomic, assign) BOOL digested;

- (instancetype)initWithModel:(XEJThread *)model;

@end
