//
//  XEJQuoteView.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJQuoteObjectView.h"
#import <Masonry/Masonry.h>

@interface XEJQuoteObjectView ()

@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UIView *line;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation XEJQuoteObjectView



- (void)setupViews

{
    self.backgroundColor = XEJGrayColor;
    //self.layer.cornerRadius = 3.0f;
    self.layer.borderWidth = 0.8f;
    self.layer.borderColor = [UIColor colorWithWhite:0.92f alpha:1.0f].CGColor;
    
    self.usernameLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"用户名username";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor blackColor];
        
        [self addSubview:label];
        label;
    });
    
    self.floorLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"21#";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor lightGrayColor];
        
        [self addSubview:label];
        label;
    });
    
    self.line = ({
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
        
        [self addSubview:view];
        view;
    });
    
    self.contentLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"Content内容";
        label.numberOfLines = 5;
        label.font = [UIFont systemFontOfSize:16.0f];
        label.textColor = [UIColor colorWithWhite:0.2f alpha:1.0f];
        
        [self addSubview:label];
        label;
    });
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}


- (void)updateConstraints
{
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(8);
        make.left.offset(8);
    }];
    
    [self.floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.usernameLabel);
        make.right.offset(-8);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(1.2f);
        make.top.equalTo(self.usernameLabel.mas_bottom).offset(8);
        (void)make.left.right;
    }];
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line.mas_bottom).offset(8);
        make.left.equalTo(self.line).offset(8);
        make.right.offset(-8);
        make.bottom.offset(-8).priorityMedium();
    }];
    
    [super updateConstraints];
}




@end
