//
//  XEJFloorViewModel.m
//  HiPDA
//
//  Created by Blink on 17/2/1.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJFloorViewModel.h"
#import <YYKit/YYKit.h>

@implementation XEJFloorViewModel

- (instancetype)init
{
    return [self initWithFloor:0];
}

- (instancetype)initWithFloor:(NSInteger)floor
{
    _floor = floor;
    return [super init];
}

- (void)xej_initialize
{
    _insets = UIEdgeInsetsMake(-2, -8, -2, -8);
    
    _floorAttrString = ({
        NSString *text = [NSString stringWithFormat:@"%ld", (long)_floor];
        NSMutableAttributedString *attrText = [[NSMutableAttributedString alloc] initWithString:text];
        attrText.font = [UIFont systemFontOfSize:14.0f];
        attrText.color = [UIColor grayColor];
        
        YYTextBorder *border = [YYTextBorder new];
        border.fillColor = [UIColor colorWithWhite:0.8f alpha:1.0f];
        border.insets = UIEdgeInsetsMake(-2, -8, -2, -8);
        border.cornerRadius = 100;  //任意一个大于高度一半的数值即可
        attrText.textBackgroundBorder = border;
        
        attrText;
    });
    
    _size = ({
        CGSize containerSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
        YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:containerSize text:_floorAttrString];
        CGSize attrTextSize = layout.textBoundingSize;
        CGFloat width = fabs(_insets.left) + fabs(_insets.right) + attrTextSize.width + 2;
        CGFloat height = fabs(_insets.top) + fabs(_insets.bottom) + attrTextSize.height + 2;
        CGSizeMake(width, height);
    });
}

@end
