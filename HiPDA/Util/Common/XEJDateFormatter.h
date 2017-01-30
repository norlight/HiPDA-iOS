//
//  XEJDateFormatter.h
//  HiPDA
//
//  Created by Blink on 17/1/26.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XEJDateFormatter : NSObject

//字符串转为NSDate
+ (NSDate *)dateFromString:(NSString *)dateString;  //yyyy-MM-dd
+ (NSDate *)timeFromString:(NSString *)timeString;  //yyyy-MM-dd HH:mm

//NSDate转为字符串
+ (NSString *)stringFromDate:(NSDate *)date;
+ (NSString *)stringFromTime:(NSDate *)time;
@end
