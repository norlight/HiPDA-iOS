//
//  XEJDateFormatter.m
//  HiPDA
//
//  Created by Blink on 17/1/26.
//  Copyright © 2017年 norlight. All rights reserved.
//

#import "XEJDateFormatter.h"

@interface XEJDateFormatter ()


@property (nonatomic, strong) NSDateFormatter *shortDateFormatter;  //MM-dd
@property (nonatomic, strong) NSDateFormatter *mediumDateFormatter;  //yyyy-MM-dd
@property (nonatomic, strong) NSDateFormatter *longDateFormatter;  //yyyy-MM-dd HH:mm

@end

@implementation XEJDateFormatter

+ (instancetype)sharedDateFormatter
{
    static XEJDateFormatter *sharedDateFormatter;
    
    if (!sharedDateFormatter) {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            sharedDateFormatter = [[XEJDateFormatter alloc] initPrivate];
        });
    }
    return sharedDateFormatter;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        
        NSDateFormatter *shortDateFormatter = [NSDateFormatter new];
        shortDateFormatter.dateFormat = @"M-d";
        _shortDateFormatter = shortDateFormatter;
        
        NSDateFormatter *mediumDateFormatter = [NSDateFormatter new];
        mediumDateFormatter.dateFormat = @"yyyy-M-d";
        _mediumDateFormatter = mediumDateFormatter;
        
        NSDateFormatter *longDateFormatter = [NSDateFormatter new];
        longDateFormatter.dateFormat = @"yyyy-M-d HH:mm";
        _longDateFormatter = longDateFormatter;
    }
    
    return self;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"单例"
                                   reason:[NSString stringWithFormat:@"请使用 +[%@ sharedDateFormatter] 进行初始化", NSStringFromClass([XEJDateFormatter class])]
                                 userInfo:nil];
}

//传入
+ (NSDate *)dateFromString:(NSString *)dateString
{
    return [[self sharedDateFormatter] dateFromString:dateString];
}

- (NSDate *)dateFromString:(NSString *)dateString
{
    return [self.mediumDateFormatter dateFromString:dateString];
}


+ (NSDate *)timeFromString:(NSString *)timeString
{
    return [[self sharedDateFormatter] timeFromString:timeString];
}

- (NSDate *)timeFromString:(NSString *)timeString
{
    return [self.longDateFormatter dateFromString:timeString];
}


//输出
+ (NSString *)stringFromDate:(NSDate *)date
{
    return [[self sharedDateFormatter] stringFromDate:date];
}

- (NSString *)stringFromDate:(NSDate *)date
{
    //return [self.mediumDateFormatter stringFromDate:date];
    NSString *dateString = nil;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                             fromDate:date];
    NSDateComponents *nowComps = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute
                                              fromDate:[NSDate date]];
    if (dateComps.year == nowComps.year) {
        NSDateComponents *comps = [calendar components:NSCalendarUnitDay
                                                            fromDate:date
                                                              toDate:[NSDate date]
                                                             options:0];
        NSInteger dayInterval = comps.day;
        if (dayInterval == 0) {
            dateString = @"今天";
        } else if (dayInterval == 1) {
            dateString = @"昨天";
        } else if (dayInterval == 2) {
            dateString = @"前天";
        } else if (dayInterval <= 9) {
            dateString = [NSString stringWithFormat:@"%d天前", (int)dayInterval];
        } else {
            dateString = [self.shortDateFormatter stringFromDate:date];
        }
        
    } else {
        dateString = [self.mediumDateFormatter stringFromDate:date];
    }

    
    
    return dateString;
}


+ (NSString *)stringFromTime:(NSDate *)time
{
    return [[self sharedDateFormatter] stringFromTime:time];
}
- (NSString *)stringFromTime:(NSDate *)time
{
    return [self.longDateFormatter stringFromDate:time];
}






@end
