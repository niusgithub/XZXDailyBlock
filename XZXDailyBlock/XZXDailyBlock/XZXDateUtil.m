//
//  XZXDateUtil.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/29.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDateUtil.h"

@implementation XZXDateUtil

static id sharedDateUtil;

+ (instancetype)sharedDateUtil {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDateUtil = [[self alloc] init];
    });
    
    return sharedDateUtil;
}

//---------------------------
//Util
//---------------------------
+ (NSDate *)localDateOfDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    return [date dateByAddingTimeInterval:interval];
}

+ (NSInteger)weekdayOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];;
}

+ (NSInteger)dayOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:date];
    return component.day;
}

+ (NSInteger)hourOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:date];
    return component.hour;
}

+ (BOOL)isDateToday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDateInToday:date];
}

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = 0;
    NSDate *date = [calendar dateFromComponents:components];
    
    return date;
}

//---------------------------
//Formatter
//---------------------------
+ (NSString *)dateStringOf24H:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    return [formatter stringFromDate:date];
}

+ (NSString *)dateStringOfMonthAndDay:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM.dd"];
    
    return [formatter stringFromDate:date];
}

@end
