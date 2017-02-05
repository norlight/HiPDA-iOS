//
//  XEJThreadContentLockedViewModel.h
//  HiPDA
//
//  Created by Blink on 17/1/31.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJObjectViewModel.h"
#import "XEJLocked.h"

@interface XEJLockedObjectViewModel : XEJObjectViewModel

@property (nonatomic, strong) XEJLocked *model;

@property (nonatomic, strong) UIImage *attachment;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *boldText;
@property (nonatomic, copy) NSAttributedString *attrText;
@property (nonatomic, assign) CGFloat borderWidth;  //描边大小
@property (nonatomic, assign) UIEdgeInsets insets;  //描边内嵌大小
@property (nonatomic, assign) CGSize size;

@property (nonatomic, strong) HTMLElement *objectElement;

@end
