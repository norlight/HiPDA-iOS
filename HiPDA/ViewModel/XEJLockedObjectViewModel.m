//
//  XEJThreadContentLockedViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/31.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJLockedObjectViewModel.h"

#import <YYKit/YYKit.h>
#import <HTMLKit/HTMLKit.h>

@interface XEJLockedObjectViewModel ()

//@property (nonatomic, strong) HTMLElement *element;


@end

@implementation XEJLockedObjectViewModel

/*
- (instancetype)initWithElement:(HTMLElement *)element
{
    _element = element;
    return [super initWithElement:element];
}
 */

- (instancetype)initWithModel:(XEJLocked *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    _attachment = [UIImage imageNamed:@"icon_lock"];
    _text = @"  提示: 作者被禁止或删除 内容自动屏蔽";
    _boldText = @"  提示: ";
    _borderWidth = 1.0f;
    _insets = UIEdgeInsetsMake(-8, -4, -8, -4);
    
    
    NSAttributedString *attrText = self.attrText;
    CGSize containerSize = CGSizeMake(SCREENWIDTH - 16, CGFLOAT_MAX);
    YYTextLayout *layout = [YYTextLayout layoutWithContainerSize:containerSize text:attrText];
    //CGRect attrTextRect = layout.textBoundingRect;
    CGSize attrTextSize = layout.textBoundingSize;
    
    //文本的高度计算可能存在少许误差，加2个点做下补充
    //CGFloat width = _borderWidth * 2 + fabs(_insets.left) + fabs(_insets.right) + attrTextSize.width + 2;
    CGFloat width = SCREENWIDTH - 16;
    CGFloat height = _borderWidth * 2 + fabs(_insets.top) + fabs(_insets.bottom) + attrTextSize.height + 2;
    _size = CGSizeMake(width, height);
}

- (NSAttributedString *)attrText
{
    if (!_attrText) {
        NSMutableAttributedString *attrText = [NSMutableAttributedString new];
        NSString *content = _text;
        NSMutableAttributedString *attrContent = [[NSMutableAttributedString alloc] initWithString:content];
        UIFont *font = [UIFont systemFontOfSize:14.0f];
        attrContent.font = font;
        attrContent.color = [UIColor colorWithWhite:0.4f alpha:1.0f];
        NSRange boldRange = [content rangeOfString:_boldText];
        [attrContent setFont:[UIFont boldSystemFontOfSize:14.0f] range:boldRange];
        
        UIImage *attach = _attachment;
        NSMutableAttributedString *attachText = [NSMutableAttributedString attachmentStringWithContent:attach contentMode:UIViewContentModeCenter attachmentSize:attach.size alignToFont:font alignment:YYTextVerticalAlignmentCenter];
        
        [attrText appendAttributedString:attachText];
        [attrText appendAttributedString:attrContent];
        
        YYTextBorder *border = [YYTextBorder new];
        border.strokeWidth = _borderWidth;
        border.strokeColor = [UIColor colorWithRed:1.0f green:0.6f blue:0.5f alpha:1.0f];
        border.fillColor = XEJGrayColor;
        border.lineStyle = YYTextLineStylePatternDot;
        border.insets = _insets;
        attrText.textBackgroundBorder = border;
        
        
        _attrText = attrText;
    }
    
    return _attrText;
}

- (HTMLElement *)objectElement
{
    if (!_objectElement) {
        HTMLElement *objectElement = [[HTMLElement alloc] initWithTagName:@"object"
                                                               attributes:@{@"style" : @"display:block;",
                                                                            @"width" : [NSString stringWithFormat:@"%f", _size.width],
                                                                            @"height" : [NSString stringWithFormat:@"%f", _size.height],
                                                                            @"postType" : @"locked",
                                                                            }];
        [objectElement appendNode:[_model.element cloneNodeDeep:YES]];
        _objectElement = objectElement;
    }
    
    return _objectElement;
}



@end
