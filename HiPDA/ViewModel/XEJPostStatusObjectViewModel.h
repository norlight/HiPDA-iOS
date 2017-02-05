//
//  XEJPostStatusObjectViewModel.h
//  HiPDA
//
//  Created by Blink on 17/2/3.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJObjectViewModel.h"
#import "XEJPostStatus.h"

@interface XEJPostStatusObjectViewModel : XEJObjectViewModel

@property (nonatomic, strong) XEJPostStatus *model;

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *updatedAtString;
@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) HTMLElement *objectElement;

- (instancetype)initWithModel:(XEJPostStatus *)model;

@end
