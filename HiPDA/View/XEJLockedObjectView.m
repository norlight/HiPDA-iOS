//
//  XEJThreadContentLockedView.m
//  HiPDA
//
//  Created by Blink on 17/1/31.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJLockedObjectView.h"
#import "XEJLockedObjectViewModel.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

@interface XEJLockedObjectView ()

@property (nonatomic, strong) YYLabel *lockedLabel;

@end

@implementation XEJLockedObjectView

- (instancetype)init
{
    XEJLockedObjectViewModel *viewModel = [XEJLockedObjectViewModel new];
    return [self initWithViewModel:viewModel];
}


- (void)setupViews
{
    self.lockedLabel = ({
        YYLabel *label = [YYLabel new];
        
        [self addSubview:label];
        label;
    });
    
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
    
    
}


- (void)bindViewModel:(XEJLockedObjectViewModel *)viewModel
{
    self.viewModel = viewModel;
    
    //注意对齐方式须在设置内容后才设置，否则会被重置
    self.lockedLabel.attributedText = viewModel.attrText;
    self.lockedLabel.textAlignment = NSTextAlignmentCenter;
    self.lockedLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    
    [self.lockedLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(viewModel.size);
        (void)make.center;
    }];
}

@end
