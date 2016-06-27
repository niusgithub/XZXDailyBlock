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
@property (nonatomic, strong) NSDate *minDate;
@property (nonatomic, strong) NSDate *maxDate;
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

#pragma mark - initialize

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
    
    [self initializeMinAndMaxDate];
}

- (void)datesAboutToday {
    // 当前月份的第一天
    self.firstDateOfCurrentMonth = [self firstDayOfMonth:_today];
    // 当前月份第一天开始的偏移天数
    self.numbersOfOffset = [self weekdayOfDate:_firstDateOfCurrentMonth];
    //NSLog(@"numbersOfOffset:%ld", _numbersOfOffset);
    // 当前页面的第一天
    self.firstDateOfCurrentPage = [self dateByAddingDays:-_numbersOfOffset toDate:_firstDateOfCurrentMonth];
    //NSLog(@"firstDateOfCurrentPage:%@", [self localDateOfDate:_firstDateOfCurrentPage]);
}

- (void)initializeMinAndMaxDate {
    self.minDate = [self dateWithYear:2016 month:5 day:1];
    self.maxDate = [self dateWithYear:2115 month:5 day:1];
}



#pragma mark -

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



- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger rows = indexPath.item / 7;
    NSUInteger colums = indexPath.item % 7;
    NSUInteger daysOffset = 7*rows + colums;
    
    return [self dateByAddingDays:daysOffset toDate:_firstDateOfCurrentPage];
}

- (NSDate *)dateByAddingDays:(NSUInteger)days toDate:(NSDate *)date {
    NSDateComponents *components = self.dateComponents;
    components.day = days;
    NSDate *day = [self.calendar dateByAddingComponents:components toDate:date options:0];
    components.day = NSUIntegerMax;
    
    return day;
}


//---------------------------
//Tool
//---------------------------
- (NSDate *)localDateOfDate:(NSDate *)date {
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    
    return [date dateByAddingTimeInterval:interval];
}

- (NSInteger)weekdayOfDate:(NSDate *)date {
    return [self.calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];;
}

- (NSInteger)dayOfDate:(NSDate *)date {
    NSDateComponents *component = [self.calendar components:NSCalendarUnitDay fromDate:date];
    return component.day;
}

- (NSInteger)hourOfDate:(NSDate *)date {
    NSDateComponents *component = [self.calendar components:NSCalendarUnitDay fromDate:date];
    return component.hour;
}

- (BOOL)isDateToday:(NSDate *)date {
    return [self.calendar isDateInToday:date];
}

- (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
    NSDateComponents *components = _dateComponents;
    components.year = year;
    components.month = month;
    components.day = day;
    components.hour = 0;
    NSDate *date = [self.calendar dateFromComponents:components];
    
    return date;
}

//---------------------------
//Formatter
//---------------------------
- (NSString *)dateStringOf24H:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    return [formatter stringFromDate:date];
}

- (NSString *)dateStringOfMonthAndDay:(NSDate *)date {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM.dd"];
    
    return [formatter stringFromDate:date];
}

//---------------------------
//temp
//---------------------------
#warning temp
- (NSDate *)tempDateForIndex:(NSInteger)index {
    NSUInteger rows = index / 7;
    NSUInteger colums = index % 7;
    NSUInteger daysOffset = 7*rows + colums;
    
    return [self dateByAddingDays:daysOffset toDate:_firstDateOfCurrentPage];
}

@end
