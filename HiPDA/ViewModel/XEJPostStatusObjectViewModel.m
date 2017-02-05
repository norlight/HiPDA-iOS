//
//  XEJPostStatusObjectViewModel.m
//  HiPDA
//
//  Created by Blink on 17/2/3.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJPostStatusObjectViewModel.h"
#import "XEJDateFormatter.h"

@interface XEJPostStatusObjectViewModel ()

@property (nonatomic, copy) NSString *text;

@end

@implementation XEJPostStatusObjectViewModel

-(instancetype)initWithModel:(XEJPostStatus *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    _username = _model.username;
    _updatedAtString = [XEJDateFormatter stringFromTime:_model.updatedAt];
    _text = [NSString stringWithFormat:@"本帖最后由 %@ 于 %@ 编辑", _username, _updatedAtString];
    UIFont *font = [UIFont systemFontOfSize:14.0f];
    //CGSize size = [_text sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14.0f]}];  //单行
    //_size = CGSizeMake(SCREENWIDTH - 20, size.height);
    CGSize size = [_text boundingRectWithSize:CGSizeMake(SCREENWIDTH - 16, CGFLOAT_MAX)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName : font}
                                      context:nil].size;
    
    _size = CGSizeMake(SCREENWIDTH - 16, size.height + 2);
    
}

- (HTMLElement *)objectElement
{
    if (!_objectElement) {
        HTMLElement *objectElement = [[HTMLElement alloc] initWithTagName:@"object"
                                                               attributes:@{@"style" : @"display:block;",
                                                                            @"width" : [NSString stringWithFormat:@"%f", _size.width],
                                                                            @"height" : [NSString stringWithFormat:@"%f", _size.height],
                                                                            @"postType" : @"postStatus",
                                                                            }];
        //将元素append到其他tag上，此时元素已经隶属属于该tag下的childNode，无法进行替代
        //故修改等操作得copy一个副本，在副本上进行
        [objectElement appendNode:[_model.element cloneNodeDeep:YES]];
        _objectElement = objectElement;
    }
    
    return _objectElement;
}

@end
