//
//  XEJAvatarView.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJAvatarView.h"
#import <YYKit/UIImage+YYAdd.h>
#import <Masonry/Masonry.h>

@interface XEJAvatarView ()

@property (nonatomic, strong) UIButton *avatarButton;

@end

@implementation XEJAvatarView

- (void)setupViews
{
    self.avatarButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        UIImage *avatar = [UIImage imageNamed:@"icon_avatar_placeholder"];
        [button setImage:[avatar imageByRoundCornerRadius:avatar.size.width
                                              borderWidth:0.8f
                                              borderColor:[UIColor lightGrayColor]]
                forState:UIControlStateNormal];
        
         [self addSubview:button];
        button;
    });
    
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
}

- (void)updateConstraints
{
    [self.avatarButton mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.edges;
    }];
    
    [super updateConstraints];
}

@end
