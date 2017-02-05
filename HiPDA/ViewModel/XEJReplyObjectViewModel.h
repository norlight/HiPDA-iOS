//
//  XEJReplyObjectViewModel.h
//  HiPDA
//
//  Created by Blink on 17/2/4.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJReply.h"


@interface XEJReplyObjectViewModel : XEJViewModel

@property (nonatomic, strong) XEJReply *model;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *floorString;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) HTMLElement *objectElement;

- (instancetype)initWithModel:(XEJReply *)model;

@end
