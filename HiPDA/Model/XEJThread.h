//
//  XEJThread.h
//  HiPDA
//
//  Created by Blink on 17/1/23.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJModel.h"
#import <Ono/Ono.h>

@class XEJUser;

@interface XEJThread : XEJModel

@property (nonatomic, copy) NSString *fid;

@property (nonatomic, assign) BOOL stick;  //是否置顶
@property (nonatomic, copy) NSString *tid;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *titleColor;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) XEJUser *author;
@property (nonatomic, assign) NSInteger replyCount;
@property (nonatomic, assign) NSInteger viewCount;  //阅读数
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, assign) BOOL hasImageAttach;
@property (nonatomic, assign) BOOL hasCommonAttach;
@property (nonatomic, assign) BOOL agreed;  //被评分
@property (nonatomic, assign) BOOL digested;  //精华帖


@end
