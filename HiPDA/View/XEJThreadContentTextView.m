//
//  XEJThreadContentTextView.m
//  HiPDA
//
//  Created by Blink on 17/1/25.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadContentTextView.h"
#import <Masonry/Masonry.h>

@interface XEJThreadContentTextView ()

@property (nonatomic, strong) UILabel *textLabel;

@end

@implementation XEJThreadContentTextView

-(void)setupViews
{
    self.textLabel = ({
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
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.edges;
    }];
    
    [super updateConstraints];
}


@end
