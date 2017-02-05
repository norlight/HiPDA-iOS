//
//  XEJReply.m
//  HiPDA
//
//  Created by Blink on 17/2/4.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJReply.h"
#import <RegexKitLite-NoWarning/RegexKitLite.h>

@implementation XEJReply

- (instancetype)initWithElement:(HTMLElement *)element
{
    _element = element;
    return [super initWithElement:element];
}

- (void)xej_initialize
{
    //<strong>回复 <a target="_blank" href="http://www.hi-pda.com/forum/redirect.php?goto=findpost&amp;pid=37540985&amp;ptid=1905647">27#</a> <i>swsw009</i> </strong>
    
    NSString *innerHTML = _element.innerHTML;
    _username = [innerHTML stringByMatching:@"(?<=<i>).*(?=</i>)"];
    _floor = [innerHTML stringByMatching:@"\\d+(?=#)"].integerValue;
    _pid = [innerHTML stringByMatching:@"(?<=pid=)\\d+"];
    _tid = [innerHTML stringByMatching:@"(?<=ptid=)\\d+"];
    
    
}

@end
