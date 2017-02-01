//
//  XEJPost.h
//  HiPDA
//
//  Created by Blink on 17/1/29.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJModel.h"

@class XEJUser;

@interface XEJPost : XEJModel

@property (nonatomic, strong) XEJUser *author;
@property (nonatomic, copy) NSString *pid;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, assign) NSInteger floor;
//@property (nonatomic, copy) NSString *slogan;

@property (nonatomic, copy) NSString *body;  //html


@end
