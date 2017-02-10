//
//  XEJRearViewModel.h
//  HiPDA
//
//  Created by Blink on 17/2/8.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"
#import "XEJForum.h"

@interface XEJRearViewModel : XEJViewModel

@property (nonatomic, copy) NSArray<XEJForum *> *forums;
@property (nonatomic, copy) NSDictionary<NSString *, UIImage *> *icons;
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, strong) RACCommand *logoutCommand;

@end
