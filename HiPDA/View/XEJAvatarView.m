//
//  XEJAvatarView.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJAvatarView.h"
#import <YYKit/UIImage+YYAdd.h>
#import <YYKit/UIButton+YYWebImage.h>
#import <Masonry/Masonry.h>

@interface XEJAvatarView ()

@property (nonatomic, strong) UIImage *placeholder;


@property (nonatomic, strong) UIButton *avatarButton;

@end

@implementation XEJAvatarView

- (void)xej_initialize
{
    self.placeholder = ({
        UIImage *placeholder = [UIImage imageNamed:@"icon_avatar_placeholder"];
        placeholder = [placeholder imageByTintColor:[UIColor colorWithWhite:0.8f alpha:1.0f]];
        placeholder = [placeholder imageByRoundCornerRadius:placeholder.size.width / 2
                                                borderWidth:0.8f
                                                borderColor:[UIColor colorWithWhite:0.7f alpha:1.0f]];
        placeholder;
    });
}

- (void)setupViews
{
    self.avatarButton = ({
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:self.placeholder
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

- (void)bindViewModel:(XEJAvatarViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    [self.avatarButton setImageWithURL:[NSURL URLWithString:viewModel.avatarUrlString]
                              forState:UIControlStateNormal
                           placeholder:self.placeholder
                               options:YYWebImageOptionShowNetworkActivity
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  //
                              }
                             transform:^UIImage * _Nullable(UIImage * _Nonnull image, NSURL * _Nonnull url) {
                                 image = [image imageByResizeToSize:self.placeholder.size contentMode:UIViewContentModeScaleAspectFit];
                                  
                                 image = [image imageByRoundCornerRadius:MIN(image.size.width, image.size.height) / 2
                                                            borderWidth:0.8f
                                                            borderColor:[UIColor colorWithWhite:0.7f alpha:1.0f]];
                                 return image;
                             }
                            completion:^(UIImage * _Nullable image, NSURL * _Nonnull url, YYWebImageFromType from, YYWebImageStage stage, NSError * _Nullable error) {
                                //
                            }];
}

@end
