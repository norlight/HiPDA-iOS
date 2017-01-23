//
//  XEJThreadCell.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadCell.h"
#import "XEJAvatarView.h"
#import "XEJQuoteView.h"
#import <Masonry/Masonry.h>


@interface XEJThreadCell ()

@property (nonatomic, strong) XEJAvatarView *avatarView;
@property (nonatomic, strong) XEJQuoteView *quoteView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *createdAtLabel;
@property (nonatomic, strong) UILabel *updatedAtLabel;
@property (nonatomic, strong) UILabel *floorLabel;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation XEJThreadCell

- (void)setupViews
{
    self.avatarView = ({
        XEJAvatarView *view = [XEJAvatarView new];
        
        [self.contentView addSubview:view];
        view;
    });
    
    self.quoteView = ({
        XEJQuoteView *view = [XEJQuoteView new];
        
        [self.contentView addSubview:view];
        view;
    });
    
    self.usernameLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"用户名username";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithRed:0.25f green:0.70f blue:0.90f alpha:1.00f];
        
        [self.contentView addSubview:label];
        label;
    });
    
    self.createdAtLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"今天date";
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:label];
        label;
    });
    
    self.updatedAtLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"本帖最后由 username 于今天 00:00 编辑";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:label];
        label;
    });
    
    self.floorLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"20";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:label];
        label;
    });
    
    self.contentLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"内容内容内容";
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:label];
        label;
    });
}

- (void)updateConstraints
{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.offset(5);
        make.left.offset(10);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_top).offset(3);
        make.left.equalTo(self.avatarView.mas_right).offset(5);
    }];
    
    [self.createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel);
        make.bottom.equalTo(self.avatarView.mas_bottom).offset(-3);
    }];
    
    [self.floorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView);
        make.right.offset(-10);
    }];
    
    [self.updatedAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.centerX;
        make.top.equalTo(self.avatarView.mas_bottom).offset(20);
    }];
    
    
    [self.quoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updatedAtLabel.mas_bottom).offset(20);
        make.left.offset(8);
        make.right.offset(-8);
    }];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.updatedAtLabel.mas_bottom);
        make.top.equalTo(self.quoteView.mas_bottom);
        make.left.equalTo(self.quoteView);
        make.bottom.offset(-5);
    }];
    
    [super updateConstraints];
}

- (void)bindViewModel:(XEJXEJThreadCellViewModel *)viewModel
{

}

@end
