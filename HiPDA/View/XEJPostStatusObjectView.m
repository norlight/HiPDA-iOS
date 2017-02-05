//
//  XEJPostStatusObjectView.m
//  HiPDA
//
//  Created by Blink on 17/2/3.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJPostStatusObjectView.h"
#import <Masonry/Masonry.h>

@interface XEJPostStatusObjectView ()

@property (nonatomic, strong) UILabel *postStatusLabel;

@end

@implementation XEJPostStatusObjectView

-(void)setupViews
{
    self.postStatusLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"本帖最后由 username 于今天 00:00 编辑";
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor lightGrayColor];
        label.textAlignment = NSTextAlignmentCenter;
        
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

- (void)bindViewModel:(XEJPostStatusObjectViewModel *)viewModel
{
    _viewModel = viewModel;
    _postStatusLabel.text = [NSString stringWithFormat:@"本帖最后由 %@ 于 %@ 编辑", viewModel.username, viewModel.updatedAtString];
    
    
}

@end
