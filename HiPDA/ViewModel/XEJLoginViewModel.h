//
//  XEJLoginViewModel.h
//  HiPDA
//
//  Created by Blink on 17/2/7.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJViewModel.h"

@interface XEJLoginViewModel : XEJViewModel


@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *questionId;
@property (nonatomic, copy) NSString *answer;
@property (nonatomic, strong) RACCommand *loginCommand;
@property (nonatomic, strong) RACCommand *dismissCommand;

@end
