//
//  XEJFloorViewModel.h
//  HiPDA
//
//  Created by Blink on 17/2/1.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"

@interface XEJFloorViewModel : XEJViewModel

@property (nonatomic, assign) NSInteger floor;

@property (nonatomic, copy) NSAttributedString *floorAttrString;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGSize size;

- (instancetype)initWithFloor:(NSInteger)floor;

@end
