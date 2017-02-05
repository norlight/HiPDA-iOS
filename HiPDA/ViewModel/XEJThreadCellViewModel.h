//
//  XEJXEJThreadCellViewModel.h
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"

@class XEJPost;
@class XEJAvatarViewModel;
@class XEJFloorViewModel;

@class XEJLockedObjectViewModel;
@class XEJPostStatusObjectViewModel;
@class XEJReplyObjectViewModel;

@interface XEJThreadCellViewModel : XEJViewModel

@property (nonatomic, strong) XEJPost *model;

@property (nonatomic, strong) XEJAvatarViewModel *avatarViewModel;
@property (nonatomic, strong) XEJFloorViewModel *floorViewModel;

@property (nonatomic, strong) XEJLockedObjectViewModel *lockedObjectViewModel;
@property (nonatomic, strong) XEJPostStatusObjectViewModel *postStatusObjectViewModel;
@property (nonatomic, strong) XEJReplyObjectViewModel *replyObjectViewModel;

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *createdAtString;
@property (nonatomic, copy) NSString *floorSting;
@property (nonatomic, copy) NSAttributedString *floorAttrString;
@property (nonatomic, copy) NSAttributedString *bodyAttrString;

@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithModel:(XEJPost *)model;

@end
