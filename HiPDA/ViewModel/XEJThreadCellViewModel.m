//
//  XEJXEJThreadCellViewModel.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadCellViewModel.h"
#import "XEJAvatarViewModel.h"
#import "XEJFloorViewModel.h"
#import "XEJLockedObjectViewModel.h"
#import "XEJPostStatusObjectViewModel.h"
#import "XEJReplyObjectViewModel.h"

#import "XEJPost.h"
#import "XEJUser.h"

#import "XEJDateFormatter.h"

#import <RegexKitLite-NoWarning/RegexKitLite.h>
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
    //原始HTML转为HTMLElement进行处理，最后再取出HTML进行显示
    
    HTMLDocument *doc = [HTMLDocument documentWithString:model.body];
    
    //处理特殊状态的楼层（被屏蔽、投票等）
    NSString *postMessageSelector = @"div.t_msgfontfix table tbody tr td.t_msgfont";  //正常内容
    HTMLElement *postMessage = [doc querySelector:postMessageSelector];
    if (!postMessage) {
        //如果获取不到正常内容，则楼层可能被屏蔽，或者为投票贴，投票贴则不止主楼该页全部楼层都会是另一个选择器
        NSString *lockedSelector = @"div.locked";
        HTMLElement *lockedElement = [doc querySelector:lockedSelector];

        
        if (lockedElement) {
            //帖子被屏蔽
            XEJLocked *model = [[XEJLocked alloc] initWithElement:lockedElement];
            XEJLockedObjectViewModel *viewModel = [[XEJLockedObjectViewModel alloc] initWithModel:model];
            HTMLElement *objectElement = viewModel.objectElement;
            postMessage = objectElement;
        } else {
            //投票贴
            NSString *postMessageSelector = @"div.specialmsg table tbody tr td.t_msgfont";  //各楼层内容，顶楼投票部分单独有一个form，暂不处理，只显示内容不显示投票
            //NSString *pollFormSelector = @"form#poll";
            postMessage = [doc querySelector:postMessageSelector];
        }
        
    }
    
    //除了正常内容、被屏蔽、投票外的其他情况
    if (!postMessage) {
        //
        NSLog(@"%@", @"[[无内容，帖子可能已被移除]]");
    }
    
    
    //开始处理postMessage内的特殊内容，图片、附件、链接等
    
    //post status
    NSString *postStatusSelector = @"i.pstatus";
    HTMLElement *postStatusElement = [postMessage querySelector:postStatusSelector];
    if (postStatusElement) {
        XEJPostStatus *model = [[XEJPostStatus alloc] initWithElement:postStatusElement];
        XEJPostStatusObjectViewModel *viewModel = [[XEJPostStatusObjectViewModel alloc] initWithModel:model];
        _postStatusObjectViewModel = viewModel;
        
        [postMessage replaceChildNode:postStatusElement withNode:viewModel.objectElement];
    }
    
    //reply
    NSString *replySelector = @"strong";
    HTMLElement *replyElement = [postMessage querySelector:replySelector];
    if (replyElement && [replyElement.textContent isMatchedByRegex:@"回复.*\\d+#.*"]) {
        
        [replyElement removeFromParentNode];
        
        //去除开头多余空白行、首行缩进
        NSString *innerHTML = postMessage.innerHTML;
        __block NSInteger currentIndex = 0;
        __block BOOL match = YES;
        NSArray<NSString *> *blanks = @[@"<br>",
                                        @"\r",  //回车
                                        @"\n",  //换行
                                        @"\t",  //Tab
                                        @"\u00A0",  //不换行空格(No-Break Space)，HTML-&nbsp; 实体编码：160
                                        @"\x20"  //普通半角空格
                                        ];
        while (match) {
            match = NO;
            [blanks enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if (innerHTML.length > currentIndex + obj.length &&[[innerHTML substringWithRange:NSMakeRange(currentIndex, obj.length)] isEqualToString:obj]) {
                    currentIndex += obj.length;
                    match = YES;
                    *stop = YES;
                }
            }];
        }
        
        if (currentIndex > 0) {
            postMessage.innerHTML = [innerHTML substringFromIndex:currentIndex];
        }
       
        
        XEJReply *model = [[XEJReply alloc] initWithElement:replyElement];
        XEJReplyObjectViewModel *viewModel = [[XEJReplyObjectViewModel alloc] initWithModel:model];
        _replyObjectViewModel = viewModel;
        
        //[postMessage replaceChildNode:replyElement withNode:viewModel.objectElement];
        [postMessage insertNode:viewModel.objectElement beforeChildNode:postMessage.firstChild];
    }
     
    

    
    
    
    
    
    
    
    //NSString *html = model.body;  //原始HTML
    NSString *html = postMessage.outerHTML;
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
