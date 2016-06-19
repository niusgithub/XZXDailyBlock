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

@property (nonatomic, strong) NSTimeZone *timeZone;
@property (nonatomic, strong) NSLocale *locale;
@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateComponents *dateComponents;
//@property (nonatomic, strong) NSDate *minDate;
//@property (nonatomic, strong) NSDate *maxDate;
@property (nonatomic, strong) NSDate *today;

// 当前月份的第一天
@property (nonatomic, strong) NSDate *firstDateOfCurrentMonth;
// 当前月份第一天开始的偏移天数
@property (nonatomic, assign) NSInteger numbersOfOffset;
// 当前页面的第一天
@property (nonatomic, strong) NSDate *firstDateOfCurrentPage;

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
//    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    _timeZone = [NSTimeZone localTimeZone];
    _locale = [NSLocale currentLocale];
    _calendar = [NSCalendar currentCalendar];
    _dateComponents = [[NSDateComponents alloc] init];
    _dateFormatter = [[NSDateFormatter alloc] init];
    
    _calendar.locale = _locale;
    _calendar.timeZone = _timeZone;
    _calendar.firstWeekday = 2; //第一个工作日为周一 Sunday=1
    
    _dateComponents.calendar = _calendar;
    _dateComponents.timeZone = _timeZone;
    _dateFormatter.calendar = _calendar;
    _dateFormatter.timeZone = _timeZone;
    _dateFormatter.locale = _locale;
    
    _today = [self dateOfToday:[self localDateOfDate:[NSDate date]]];
//    _minDate = [self firstDayOfMonth:_today];
//    _maxDate = [self lastDayOfMonth:_today];
    
    [self datesAboutToday];
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

- (void)datesAboutToday {
    // 当前月份的第一天
    self.firstDateOfCurrentMonth = [self firstDayOfMonth:_today];
    // 当前月份第一天开始的偏移天数
    self.numbersOfOffset = [self weekdayOfDate:_firstDateOfCurrentMonth];
    NSLog(@"numbersOfOffset:%ld", _numbersOfOffset);
    // 当前页面的第一天
    self.firstDateOfCurrentPage = [self dateByAddingDays:-_numbersOfOffset toDate:_firstDateOfCurrentMonth];
    NSLog(@"firstDateOfCurrentPage:%@", [self localDateOfDate:_firstDateOfCurrentPage]);
}

- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger rows = indexPath.item / 7;
    NSUInteger colums = indexPath.item % 7;
    NSUInteger daysOffset = 7*rows + colums;
    
    return [self dateByAddingDays:daysOffset toDate:_firstDateOfCurrentPage];
}


//---------------------------
- (NSInteger)dayOfDate:(NSDate *)date {
    NSDateComponents *component = [self.calendar components:NSCalendarUnitDay fromDate:date];
    return component.day;
}

- (NSInteger)weekdayOfDate:(NSDate *)date {
    return [self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];;
}

- (NSDate *)dateByAddingDays:(NSUInteger)days toDate:(NSDate *)date {
    NSDateComponents *components = self.dateComponents;
    components.day = days;
    NSDate *day = [self.calendar dateByAddingComponents:components toDate:date options:0];
    components.day = NSUIntegerMax;
    
    return day;
}

- (NSDate *)localDateOfDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    return [date dateByAddingTimeInterval:interval];
}
@end
