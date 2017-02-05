//
//  XEJPostStatus.m
//  HiPDA
//
//  Created by Blink on 17/2/3.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJPostStatus.h"
#import "XEJDateFormatter.h"
#import <RegexKitLite-NoWarning/RegexKitLite.h>

@implementation XEJPostStatus

- (instancetype)initWithElement:(HTMLElement *)element
{

    _element = element;
    return [super initWithElement:element];
}

- (void)xej_initialize
{
    // 本帖最后由 xxx 于 2017-1-8 13:28 编辑
    NSString *text = _element.textContent;
    _username = [text stringByMatching:@" (?<=本帖最后由\\s).*(?=\\s于)"];
    NSString *timeString = [text stringByMatching:@"(?<=于\\s).*(?=\\s编辑)"];
    _updatedAt = [XEJDateFormatter timeFromString:timeString];
}

@end
