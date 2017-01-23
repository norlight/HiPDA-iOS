//
//  XEJTableViewCell.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJTableViewCell.h"

@implementation XEJTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //取消选择风格
        //self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //去除分割线左边空白
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            self.separatorInset = UIEdgeInsetsZero;
        }
        if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
        
        if ([self respondsToSelector:@selector(setupViews)]) {
            [self setupViews];
        }
    }
    
    return self;
}


@end
