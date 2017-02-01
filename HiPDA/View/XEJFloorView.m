//
//  XEJFloorView.m
//  HiPDA
//
//  Created by Blink on 17/2/1.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJFloorView.h"
#import <YYKit/YYKit.h>
#import <Masonry/Masonry.h>

@interface XEJFloorView ()

@property (nonatomic, strong) YYLabel *floorLabel;

@end

@implementation XEJFloorView

- (instancetype)init
{
    XEJFloorViewModel *viewModel = [XEJFloorViewModel new];
    return [super initWithViewModel:viewModel];
}

- (void)setupViews
{
    _floorLabel = ({
        YYLabel *label = [YYLabel new];
        
        [self addSubview:label];
        label;
    });
    
    [self setNeedsUpdateConstraints];
    [self updateConstraints];
}


- (void)bindViewModel:(XEJFloorViewModel *)viewModel
{
    self.viewModel = viewModel;
    self.floorLabel.attributedText = viewModel.floorAttrString;
    self.floorLabel.textAlignment = NSTextAlignmentCenter;
    self.floorLabel.textVerticalAlignment = YYTextVerticalAlignmentCenter;
    [self.floorLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(viewModel.size);
        (void)make.center;
        (void)make.edges;
    }];
    
}

@end
