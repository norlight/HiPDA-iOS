//
//  XEJForum.h
//  HiPDA
//
//  Created by Blink on 17/1/23.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJModel.h"

@interface XEJForum : XEJModel

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL private;  //是否为隐私版块（需登录才能查看）

@end
