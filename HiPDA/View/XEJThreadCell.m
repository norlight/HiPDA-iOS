//
//  XEJThreadCell.m
//  HiPDA
//
//  Created by Blink on 17/1/22.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJThreadCell.h"
#import "XEJAvatarView.h"
#import "XEJThreadContentTextView.h"
#import "XEJQuoteObjectView.h"
#import "XEJThreadContentImageView.h"
#import "XEJThreadContentAttachmentView.h"
#import "XEJQuoteObjectView.h"

#import "XEJLockedObjectView.h"
#import "XEJPostStatusObjectView.h"
#import "XEJReplyObjectView.h"

#import "XEJFloorView.h"

#import "XEJThreadCellViewModel.h"

#import <DTCoreText/DTCoreText.h>
#import <Masonry/Masonry.h>
#import <YYKit/YYKit.h>


@interface XEJThreadCell () <DTAttributedTextContentViewDelegate>

@property (nonatomic, strong) XEJAvatarView *avatarView;
@property (nonatomic, strong) XEJQuoteObjectView *quoteView;
@property (nonatomic, strong) UILabel *usernameLabel;
@property (nonatomic, strong) UILabel *createdAtLabel;
@property (nonatomic, strong) UILabel *updatedAtLabel;
@property (nonatomic, strong) XEJFloorView *floorView;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, copy) NSArray<UIView *> *threadContentViews;

@property (nonatomic, strong) DTAttributedLabel *bodyLabel;

@end

@implementation XEJThreadCell

- (void)setupViews
{
    self.avatarView = ({
        XEJAvatarView *view = [XEJAvatarView new];
        
        [self.contentView addSubview:view];
        view;
    });
    

    
    self.usernameLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"用户名username";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor colorWithRed:0.25f green:0.70f blue:0.90f alpha:1.00f];
        
        [self.contentView addSubview:label];
        label;
    });
    
    self.createdAtLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"今天date";
        label.font = [UIFont systemFontOfSize:12.0f];
        label.textColor = [UIColor grayColor];
        
        [self.contentView addSubview:label];
        label;
    });
    self.floorView = ({
        XEJFloorView *view = [XEJFloorView new];
        
        [self.contentView addSubview:view];
        view;
    });
    /*
     self.quoteView = ({
     XEJThreadContentQuoteView *view = [XEJThreadContentQuoteView new];
     
     [self.contentView addSubview:view];
     view;
     });
     
    self.updatedAtLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"本帖最后由 username 于今天 00:00 编辑";
        label.font = [UIFont systemFontOfSize:14.0f];
        label.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:label];
        label;
    });
     */
    

    
    /*
    self.contentLabel = ({
        UILabel *label = [UILabel new];
        label.text = @"内容内容内容";
        label.font = [UIFont systemFontOfSize:18.0f];
        label.textColor = [UIColor blackColor];
        
        [self.contentView addSubview:label];
        label;
    });
     */
    
    
    /*
    self.threadContentViews = @[[XEJThreadContentPostStatusView new], [XEJThreadContentTextView new]];
    [self.threadContentViews enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
     */
 
    /*
    [self setNeedsUpdateConstraints];
    [self updateConstraintsIfNeeded];
     */
    
    
    self.bodyLabel = ({
        NSString *htmlString = @"<br>正文<br>";
        NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithHTMLData:data documentAttributes:NULL];
        
        DTAttributedLabel *label = [[DTAttributedLabel alloc] initWithFrame:CGRectMake(0, 0, CGFLOAT_WIDTH_UNKNOWN, CGFLOAT_HEIGHT_UNKNOWN)];
        label.numberOfLines = 0;
        label.attributedString = attrString;
        
        label.delegate = self;
        [self.contentView addSubview:label];
        label;
    });
     

}

- (void)updateConstraints
{
    [self.avatarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(40, 40));
        make.top.offset(4);
        make.left.offset(8);
    }];
    
    [self.usernameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_top).offset(2);
        make.left.equalTo(self.avatarView.mas_right).offset(4);
    }];
    
    [self.createdAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.usernameLabel);
        make.bottom.equalTo(self.avatarView.mas_bottom).offset(-2);
    }];
    
    [self.floorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.avatarView);
        make.right.offset(-8);
    }];
    
    /*
    [self.updatedAtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        (void)make.centerX;
        make.top.equalTo(self.avatarView.mas_bottom).offset(20);
    }];
    
    
    [self.quoteView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.updatedAtLabel.mas_bottom).offset(20);
        make.left.offset(8);
        make.right.offset(-8);
    }];
    
    
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.top.equalTo(self.updatedAtLabel.mas_bottom);
        make.top.equalTo(self.quoteView.mas_bottom);
        make.left.equalTo(self.quoteView);
        make.bottom.offset(-5);
    }];
     */
    
    /*
    [self.threadContentViews enumerateObjectsUsingBlock:^(UIView*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx == 0) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                //(void)make.centerX;
                make.top.equalTo(self.avatarView.mas_bottom).offset(20);
                make.left.offset(5);
                make.right.offset(-5);
            }];
        } else if (idx == self.threadContentViews.count - 1) {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                UIView *previousView = self.threadContentViews[idx - 1];
                //(void)make.centerX;
                make.top.equalTo(previousView.mas_bottom).offset(20);
                make.left.offset(5);
                make.right.offset(-5);
                make.bottom.offset(-20);
            }];
        } else {
            [obj mas_makeConstraints:^(MASConstraintMaker *make) {
                UIView *previousView = self.threadContentViews[idx - 1];
                //(void)make.centerX;
                make.top.equalTo(previousView.mas_bottom).offset(20);
                make.left.offset(5);
                make.right.offset(-5);
                
            }];
        }
    }];
     */
    
    
    [self.bodyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.avatarView.mas_bottom).offset(16);
        make.left.offset(8);
        make.bottom.offset(-4);
        make.right.offset(-8);
    }];
    
    
    [super updateConstraints];
}


- (void)bindViewModel:(XEJThreadCellViewModel *)viewModel
{
    /*
    [self.contentView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //if obj is kind of text||image...
        [obj removeFromSuperview];
    }];
    [self.threadContentViews enumerateObjectsUsingBlock:^(UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj mas_remakeConstraints:^(MASConstraintMaker *make) {
            //
        }];
    }];
    */
    
    self.viewModel = viewModel;
    
    [self.avatarView bindViewModel:viewModel.avatarViewModel];
    [self.floorView bindViewModel:viewModel.floorViewModel];
    
    self.usernameLabel.text = viewModel.username;
    self.createdAtLabel.text = viewModel.createdAtString;

    self.bodyLabel.attributedString = viewModel.bodyAttrString;

}


#pragma mark - DTAttributedTextContentViewDelegate
- (UIView *)attributedTextContentView:(DTAttributedTextContentView *)attributedTextContentView viewForAttachment:(DTTextAttachment *)attachment frame:(CGRect)frame
{
    if ([attachment isKindOfClass:[DTObjectTextAttachment class]]) {
        NSString *postType = attachment.attributes[@"posttype"];  //注意属性名全会变成小写
        
        /*
        DTObjectTextAttachment *attach = (DTObjectTextAttachment *)attachment;
        [attach.childNodes enumerateObjectsUsingBlock:^(DTHTMLElement *element, NSUInteger idx, BOOL * _Nonnull stop) {
            //
            NSLog(@"%@", element.debugDescription);
            
        }];
         */
        if ([postType isEqualToString:@"locked"]) {
            XEJLockedObjectView *view = [XEJLockedObjectView new];
            view.frame = frame;
            return view;
        }
        
        if ([postType isEqualToString:@"postStatus"]) {
            
            XEJPostStatusObjectView *view = [[XEJPostStatusObjectView alloc] initWithViewModel:self.viewModel.postStatusObjectViewModel];
            view.frame = frame;
            return view;
        }
        
        if ([postType isEqualToString:@"reply"]) {
            XEJReplyObjectView *view = [[XEJReplyObjectView alloc] initWithViewModel:self.viewModel.replyObjectViewModel];
            view.frame = frame;
            return view;
        }
    }
    
    return nil;
}















@end
