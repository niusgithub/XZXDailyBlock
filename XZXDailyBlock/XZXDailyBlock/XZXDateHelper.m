//
//  XZXDateHelper.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDateHelper.h"

static id sharedDateHelper;

@interface XZXDateHelper ()

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateComponents *dateComponents;
@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *today;

@end

@implementation XZXDateHelper

+ (instancetype)sharedDateHelper {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDateHelper = [[self alloc] init];
    });
    
    return sharedDateHelper;
}

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _calendar.locale = [NSLocale currentLocale];
    _calendar.timeZone = [NSTimeZone localTimeZone];
    _calendar.firstWeekday = 1;
    
    _dateComponents = [[NSDateComponents alloc] init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    _minDate = [self firstDayOfMonth:[self localDate]];
    _maxDate = [self lastDayOfMonth:[self localDate]];
    _today = [self dateOfToday:[self localDate]];
}

- (NSDate *)firstDayOfMonth:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:date];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)lastDayOfMonth:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:date];
#warning 12++?
    components.month++;
    components.day = 0;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)dateOfToday:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:date];
    components.hour = 0;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)dayForIndexPath:(NSIndexPath *)indexPath {
    // 当前页面的第一天
    
    // 当前月份第一天开始的偏移天数
    NSInteger *numbersOfOffset = 0;
    // 当前月份的第一天
    NSDate *firstDayOfCurrentMonth = [self firstDayOfMonth:[self localDate]];
    // NSLog(@"firstDayOfCurrentMonth:%@", [NSDate date]);
    
    NSUInteger rows = indexPath.item / 7;
    NSUInteger colums = indexPath.item % 7;
    NSUInteger daysOffset = 7*rows + colums;
    
    NSLog(@"daysOffset:%ld",daysOffset);
    
    return [self dateByAddingDays:daysOffset toDate:firstDayOfCurrentMonth];
}

- (NSInteger)dayOfDate:(NSDate *)date {
    NSDateComponents *component = [self.calendar components:NSCalendarUnitDay
                                                   fromDate:date];
    return component.day;
}

- (NSDate *)dateByAddingDays:(NSUInteger)days toDate:(NSDate *)date {
    NSDateComponents *components = self.dateComponents;
    components.day = days;
    NSDate *day = [self.calendar dateByAddingComponents:components toDate:date options:0];
    components.day = NSUIntegerMax;
    
    return day;
}

- (NSDate *)localDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    return [date dateByAddingTimeInterval:interval];
}
@end
