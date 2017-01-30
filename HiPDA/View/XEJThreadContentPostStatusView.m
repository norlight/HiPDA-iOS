//
//  ThreadContentPostStatusView.m
//  HiPDA
//
//  Created by Blink on 17/1/25.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadContentPostStatusView.h"
#import <Masonry/Masonry.h>

@interface XEJThreadContentPostStatusView ()

@property (nonatomic, strong) UILabel *postStatusLabel;

@end

@implementation XEJThreadContentPostStatusView

-(void)setupViews
{
    self.postStatusLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"本帖最后由 username 于今天 00:00 编辑";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor lightGrayColor];
        
        [self addSubview:label];
        label;
    });
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [self.postStatusLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.edges;
    }];
    
    [super updateConstraints];
}

@end
