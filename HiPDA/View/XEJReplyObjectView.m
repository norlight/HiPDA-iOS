//
//  XEJReplyObjectView.m
//  HiPDA
//
//  Created by Blink on 17/2/4.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJReplyObjectView.h"
#import "XEJReplyObjectViewModel.h"
#import <Masonry/Masonry.h>

@interface XEJReplyObjectView ()

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *floorLabel;

@end

@implementation XEJReplyObjectView

- (void)setupViews

{
    self.backgroundColor = XEJGrayColor;
    self.layer.cornerRadius = 2.0f;
    self.layer.borderWidth = 0.8f;
    self.layer.borderColor = [UIColor colorWithWhite:0.92f alpha:1.0f].CGColor;
    
    self.usernameLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"回复 用户名username";
        label.font = [UIFont boldSystemFontOfSize:14.0f];
        label.textColor = [UIColor blackColor];
        
        [self addSubview:label];
        label;
    });
    
    self.floorLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"0#";
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
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(8);
        (void)make.centerY;
    }];
    
    [self.floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-8);
        (void)make.centerY;
    }];
    
    [super updateConstraints];
}

- (void)bindViewModel:(XEJReplyObjectViewModel *)viewModel
{
    _viewModel = viewModel;
    _usernameLabel.text = [NSString stringWithFormat:@"回复 %@", viewModel.username];
    _floorLabel.text = [NSString stringWithFormat:@"%@#", viewModel.floorString];
}

@end
