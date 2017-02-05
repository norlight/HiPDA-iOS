//
//  XEJReplyObjectViewModel.m
//  HiPDA
//
//  Created by Blink on 17/2/4.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJReplyObjectViewModel.h"

@implementation XEJReplyObjectViewModel

- (instancetype)initWithModel:(XEJReply *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    XEJReply *model = _model;
    _username = model.username;
    _floorString = [NSString stringWithFormat:@"%ld", (long)model.floor];
    _pid = model.pid;
    _tid = model.tid;
    
    CGSize size = [_username sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:14.0f]}];
    _size = CGSizeMake(SCREENWIDTH - 8 * 2, size.height * 2);
}


- (HTMLElement *)objectElement
{
    if (!_objectElement) {
        HTMLElement *objectElement = [[HTMLElement alloc] initWithTagName:@"object"
                                                               attributes:@{@"style" : @"display:block;",
                                                                            @"width" : [NSString stringWithFormat:@"%f", _size.width],
                                                                            @"height" : [NSString stringWithFormat:@"%f", _size.height],
                                                                            @"postType" : @"reply",
                                                                            }];
        [objectElement appendNode:[_model.element cloneNodeDeep:YES]];
        _objectElement = objectElement;
    }
    
    return _objectElement;
}

@end
