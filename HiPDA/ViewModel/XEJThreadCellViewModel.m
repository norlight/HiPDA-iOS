//
//  XEJXEJThreadCellViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadCellViewModel.h"
#import "XEJUser.h"
#import "XEJAvatarViewModel.h"
#import "XEJFloorViewModel.h"

#import "XEJPost.h"

#import "XEJDateFormatter.h"

#import <DTCoreText/DTCoreText.h>
#import <HTMLKit/HTMLKit.h>
#import <YYKit/YYKit.h>

@implementation XEJThreadCellViewModel

- (instancetype)initWithModel:(XEJPost *)model
{
    _model = model;
    return [super initWithModel:model];
}

- (void)xej_initialize
{
    XEJPost *model = _model;
    
    self.avatarViewModel = [[XEJAvatarViewModel alloc] initWithModel:model.author];
    
    self.pid = model.pid;
    self.username = model.author.username;
    self.createdAtString = [XEJDateFormatter stringFromTime:model.createdAt];
    self.floorSting = [NSString stringWithFormat:@"%ld", (long)model.floor];
    
    _floorViewModel = [[XEJFloorViewModel alloc] initWithFloor:model.floor];
    

    
    
    
    
    //流程：1.Ono-string，提取；2.HTMLKit-string，编辑、清理；3.DTCoreText-attrString，显示
    NSString *html;
    HTMLDocument *doc = [HTMLDocument documentWithString:model.body];
    //正常内容
    NSString *postMessageSelector = @"div.t_msgfontfix table tbody tr td.t_msgfont";
    HTMLElement *postMessage = [doc querySelector:postMessageSelector];
    if (!postMessage) {
        //楼层被屏蔽
        NSString *lockedSelector = @"div.locked";
        HTMLElement *locked = [doc querySelector:lockedSelector];

        if (locked) {
            HTMLElement *element = [[HTMLElement alloc] initWithTagName:@"object"
                                                             attributes:@{@"style" : @"display:block;",
                                                                          @"width" : @"300",
                                                                          @"height" : @"80",
                                                                          @"postType" : @"locked",
                                                                          }];
            [element appendNode:locked];
            html = element.outerHTML;
            NSLog(@"%@", html);
            
        }
    } else {
        html = model.body;
    }

    
    
    
    
    
    
    
    //NSString *html = model.body;
    NSData *data = [html dataUsingEncoding:NSUTF8StringEncoding];
    
    CGSize maxImageSize = CGSizeMake(SCREENWIDTH - 20.0, CGFLOAT_HEIGHT_UNKNOWN);
    void (^callBackBlock)(DTHTMLElement *element) = ^(DTHTMLElement *element) {
        [element.childNodes enumerateObjectsUsingBlock:^(DTHTMLElement *oneChildElement, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            //有出现附件的，改为块显示，并增大字体行高使其与附件齐高
            if (oneChildElement.displayStyle == DTHTMLElementDisplayStyleInline && oneChildElement.textAttachment.displaySize.height > 2.0 * oneChildElement.fontDescriptor.pointSize)
            {
                oneChildElement.displayStyle = DTHTMLElementDisplayStyleBlock;
                oneChildElement.paragraphStyle.minimumLineHeight = element.textAttachment.displaySize.height;
                oneChildElement.paragraphStyle.maximumLineHeight = element.textAttachment.displaySize.height;
            }
        }];
    };
    NSDictionary *options = @{NSTextSizeMultiplierDocumentOption : @(1.4),  //字体比例缩放
                              DTMaxImageSize : [NSValue valueWithCGSize:maxImageSize],
                              DTDefaultLinkColor : XEJMainColor,
                              DTWillFlushBlockCallBack : callBackBlock};
    
    NSAttributedString *attr = [[NSAttributedString alloc] initWithHTMLData:data options:options documentAttributes:nil];

    self.bodyAttrString = attr;
}

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        //正文高度
        DTCoreTextLayouter *layouter = [[DTCoreTextLayouter alloc] initWithAttributedString:_bodyAttrString];
        CGRect maxRect = CGRectMake(0, 0, SCREENWIDTH - 30, CGFLOAT_HEIGHT_UNKNOWN);
        NSRange entireStringRange = NSMakeRange(0, _bodyAttrString.length);
        DTCoreTextLayoutFrame *layoutFrame = [layouter layoutFrameWithRect:maxRect range:entireStringRange];
        CGSize sizeNeeded = layoutFrame.frame.size;
        CGFloat bodyHeight = sizeNeeded.height;
        
        //行高，字面量为各View间隔，需与View中布局约束对应
        //行高过小不是越界显示，而是会直接不显示
        CGFloat avatarHeight = 40;
        _cellHeight = 5 + avatarHeight + 20 + bodyHeight + 5;
    }
    
    return _cellHeight;
}

@end
