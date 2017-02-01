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

@interface XEJThreadCellViewModel : XEJViewModel

@property (nonatomic, strong) XEJPost *model;

@property (nonatomic, strong) XEJAvatarViewModel *avatarViewModel;
@property (nonatomic, strong) XEJFloorViewModel *floorViewModel;

@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *createdAtString;
@property (nonatomic, copy) NSString *floorSting;
@property (nonatomic, copy) NSAttributedString *floorAttrString;
@property (nonatomic, copy) NSAttributedString *bodyAttrString;

@property (nonatomic, assign) CGFloat cellHeight;

- (instancetype)initWithModel:(XEJPost *)model;

@end
