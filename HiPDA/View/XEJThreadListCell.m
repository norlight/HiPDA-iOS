//
//  XEJThreadListCell.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadListCell.h"
#import "XEJAvatarView.h"
#import <Masonry/Masonry.h>
#import <YYKit/UIImage+YYAdd.h>

@interface XEJThreadListCell ()

@property (nonatomic, strong) UIImage *commonAttach;
@property (nonatomic, strong) UIImage *imageAttach;

@property (nonatomic, strong) XEJAvatarView *avatarView;
@property (nonatomic, strong) UIImageView *attachImageView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *createdAtLabel;
@property (nonatomic, strong) UILabel *numberLabel;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation XEJThreadListCell

- (void)xej_initialize
{
    self.commonAttach = [[UIImage imageNamed:@"icon_attach_common"] imageByTintColor:XEJMainColor];
    self.imageAttach = [[UIImage imageNamed:@"icon_attach_image_day"] imageByTintColor:XEJMainColor];
}

- (void)setupViews
{
    self.avatarView = ({
        XEJAvatarView *view = [XEJAvatarView new];
        
        [self.contentView addSubview:view];
        view;
    });
    
    self.attachImageView = ({
        UIImageView *imageView = [UIImageView new];
        imageView.image = self.imageAttach;
        
        [self.contentView addSubview:imageView];
        imageView;
    });
    
    self.usernameLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"username";
        label.font = [UIFont systemFontOfSize:14.0f];
        //label.textColor = [UIColor colorWithRed:0.25f green:0.70f blue:0.90f alpha:1.00f];
        label.textColor = XEJMainColor;
        
        [self.contentView addSubview:label];
        label;
    });
    
    self.createdAtLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"date";
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:label];
        label;
    });
    
    self.numberLabel = ({
        
        UILabel *label = [UILabel new];
        label.text = @"1/99";
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:label];
        label;
    });
    
    self.titleLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"title";
        label.numberOfLines = 2;
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
    
    [self.numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView);
        make.right.offset(-10);
    }];
    
    [self.attachImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(16, 16));
        make.centerY.equalTo(self.numberLabel);
        make.right.equalTo(self.numberLabel.mas_left).offset(-2);
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(10).priorityMedium();
        make.left.offset(10);
        make.right.offset(-10);
        make.bottom.offset(-5);
    }];
    
    [super updateConstraints];
}

- (void)bindViewModel:(XEJThreadListCellViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.avatarView bindViewModel:viewModel.avatarViewModel];
    
    self.usernameLabel.text = viewModel.username;
    self.createdAtLabel.text = viewModel.createdAtString;
    self.numberLabel.text = [NSString stringWithFormat:@"%@/%@", viewModel.replyCountString, viewModel.viewCountString];
    self.titleLabel.text = viewModel.title;
    self.titleLabel.textColor = viewModel.titleColor;
    //self.attachmentImageView.hidden = !viewModel.hasImageAttach;
    if (viewModel.hasCommonAttach) {
        self.attachImageView.image = self.commonAttach;
        self.attachImageView.hidden = NO;
    } else if (viewModel.hasImageAttach) {
        self.attachImageView.image = self.imageAttach;
        self.attachImageView.hidden = NO;
    } else {
        self.attachImageView.hidden = YES;
    }
}








@end
