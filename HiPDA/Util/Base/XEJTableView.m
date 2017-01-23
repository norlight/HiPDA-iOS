//
//  XEJTableView.m
//  HiPDA
//
//  Created by Blink on 17/1/15.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJTableView.h"

@implementation XEJTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        //去除分割线
        //self.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        //空白footer，隐藏多余分割线
        self.tableFooterView = [UIView new];
        
        if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
            self.separatorInset = UIEdgeInsetsZero;
        }
        if ([self respondsToSelector:@selector(layoutMargins)]) {
            self.layoutMargins = UIEdgeInsetsZero;
        }
    }
    
    return self;
}

@end
