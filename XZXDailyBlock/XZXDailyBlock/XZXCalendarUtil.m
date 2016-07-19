//
//  XZXDateHelper.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarUtil.h"
#import "XZXDateUtil.h"

static id sharedDateHelper;

@interface XZXCalendarUtil ()

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

// 上月份的第一天
@property (nonatomic, strong) NSDate *firstDateOfLastMonth;
// 上月份第一天开始的偏移天数
@property (nonatomic, assign) NSInteger numbersOfOffsetOfLastMonth;
// 上月页面的第一天
@property (nonatomic, strong) NSDate *firstDateOfLastPage;

// 两月前月份的第一天
@property (nonatomic, strong) NSDate *firstDateOf2MonthAgo;
// 两月前月份第一天开始的偏移天数
@property (nonatomic, assign) NSInteger numbersOfOffsetOf2MonthAgo;
// 两月前月页面的第一天
@property (nonatomic, strong) NSDate *firstDateOf2MonthAgoPage;

// 下月份的第一天
@property (nonatomic, strong) NSDate *firstDateOfNextMonth;
// 下月份第一天开始的偏移天数
@property (nonatomic, assign) NSInteger numbersOfOffsetOfNextMonth;
// 下月页面的第一天
@property (nonatomic, strong) NSDate *firstDateOfNextPage;

// 两月后月份的第一天
@property (nonatomic, strong) NSDate *firstDateOf2MonthLater;
// 两月后月份第一天开始的偏移天数
@property (nonatomic, assign) NSInteger numbersOfOffsetOf2MonthLater;
// 两月后月页面的第一天
@property (nonatomic, strong) NSDate *firstDateOf2MonthLaterPage;

@end

@implementation XZXCalendarUtil

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

#pragma mark - initialize

- (void)initialize {
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
    
    _today = [self dateOfToday:[XZXDateUtil localDateOfDate:[NSDate date]]];
//    _minDate = [self firstDayOfMonth:_today];
//    _maxDate = [self lastDayOfMonth:_today];
    
    [self datesAboutMonths];
    
    [self initializeMinAndMaxDate];
}

- (void)datesAboutMonths {
    // 当前月份的第一天
    self.firstDateOfCurrentMonth = [self firstDayOfMonth:_today];
    //NSLog(@"firstDateOfCurrentMonth%@",[XZXDateUtil localDateOfDate:_firstDateOfCurrentMonth]);
    // 当前月份第一天开始的偏移天数
    self.numbersOfOffset = [XZXDateUtil weekdayOfDate:_firstDateOfCurrentMonth] - 1;
    // 当前页面的第一天
    self.firstDateOfCurrentPage = [self dateByAddingDays:-_numbersOfOffset toDate:_firstDateOfCurrentMonth];
    //NSLog(@"firstDateOfCurrentPage:%@", [XZXDateUtil localDateOfDate:_firstDateOfCurrentPage]);

    NSDateComponents *monthComponents = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:_today];
    
    
    monthComponents.month--;
    NSDate *lastMonthDate = [self.calendar dateFromComponents:monthComponents];
    // 上月份
    self.firstDateOfLastMonth = [self firstDayOfMonth:lastMonthDate];
    //NSLog(@"firstDateOfLastMonth%@",[XZXDateUtil localDateOfDate:_firstDateOfLastMonth]);
    // 上月份第一天开始的偏移天数
    self.numbersOfOffsetOfLastMonth = [XZXDateUtil weekdayOfDate:_firstDateOfLastMonth] - 1;
    // 上月页面的第一天
    self.firstDateOfLastPage = [self dateByAddingDays:-_numbersOfOffsetOfLastMonth toDate:_firstDateOfLastMonth];
    //NSLog(@"firstDateOfLastPage:%@", [XZXDateUtil localDateOfDate:_firstDateOfLastPage]);
    
    monthComponents.month--;
    NSDate *twoMonthAgoDate = [self.calendar dateFromComponents:monthComponents];
    // 两月前月份的第一天
    self.firstDateOf2MonthAgo = [self firstDayOfMonth:twoMonthAgoDate];
    //NSLog(@"firstDateOf2MonthAgo%@",[XZXDateUtil localDateOfDate:_firstDateOf2MonthAgo]);
    // 两月前月份第一天开始的偏移天数
    self.numbersOfOffsetOf2MonthAgo = [XZXDateUtil weekdayOfDate:_firstDateOf2MonthAgo] - 1;
    // 两月前月页面的第一天
    self.firstDateOf2MonthAgoPage = [self dateByAddingDays:-_numbersOfOffsetOf2MonthAgo toDate:_firstDateOf2MonthAgo];
    //NSLog(@"firstDateOf2MonthAgoPage%@",[XZXDateUtil localDateOfDate:_firstDateOf2MonthAgoPage]);
    
    monthComponents.month+=3;
    NSDate *nextMonthDate = [self.calendar dateFromComponents:monthComponents];
    // 下月份的第一天
    self.firstDateOfNextMonth = [self firstDayOfMonth:nextMonthDate];
    //NSLog(@"firstDateOfNextMonth:%@",[XZXDateUtil localDateOfDate:_firstDateOfNextMonth]);
    // 下月份第一天开始的偏移天数
    self.numbersOfOffsetOfNextMonth = [XZXDateUtil weekdayOfDate:_firstDateOfNextMonth] - 1;
    // 下月页面的第一天
    self.firstDateOfNextPage = [self dateByAddingDays:-_numbersOfOffsetOfNextMonth toDate:_firstDateOfNextMonth];
    //NSLog(@"firstDateOfNextPage:%@",[XZXDateUtil localDateOfDate:_firstDateOfNextPage]);
    
    monthComponents.month+=1;
    NSDate *twoMonthLaterDate = [self.calendar dateFromComponents:monthComponents];
    // 下月份的第一天
    self.firstDateOf2MonthLater = [self firstDayOfMonth:twoMonthLaterDate];
    //NSLog(@"firstDateOf2MonthLater:%@",[XZXDateUtil localDateOfDate:_firstDateOf2MonthLater]);
    // 下月份第一天开始的偏移天数
    self.numbersOfOffsetOf2MonthLater = [XZXDateUtil weekdayOfDate:_firstDateOf2MonthLater] - 1;
    // 下月页面的第一天
    self.firstDateOf2MonthLaterPage = [self dateByAddingDays:-_numbersOfOffsetOf2MonthLater toDate:_firstDateOf2MonthLater];
    //NSLog(@"firstDateOf2MonthLaterPage:%@",[XZXDateUtil localDateOfDate:_firstDateOf2MonthLaterPage]);
    
}

- (void)initializeMinAndMaxDate {
    self.minDate = [XZXDateUtil dateWithYear:2016 month:5 day:1];
    self.maxDate = [XZXDateUtil dateWithYear:2115 month:5 day:1];
}



#pragma mark - Calendar

- (NSDate *)firstDayOfMonth:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:date];
    components.day = 1;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)lastDayOfMonth:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:date];
    components.month++;
    components.day = 0;
    return [self.calendar dateFromComponents:components];
}

- (NSDate *)firstDayOfNextMonth:(NSDate *)date {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour fromDate:date];
    components.month++;
    components.day = 1;
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
    //NSLog(@"days:%ld, todate%@",days,date);
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.day = days;
    NSDate *day = [self.calendar dateByAddingComponents:components toDate:date options:0];
    //components.day = NSUIntegerMax;
    
    //NSLog(@"date:%@",day);
    
    return day;
}

- (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate {
    NSDateComponents *components = [self.calendar components:NSCalendarUnitMonth
                                                    fromDate:fromDate
                                                      toDate:toDate
                                                     options:0];
    return components.month;
}

- (NSInteger)totalMonths {
    return [self monthsFromDate:_minDate toDate:_maxDate];
}

- (NSDate *)dateForIndex:(NSInteger)index {
    NSUInteger rows = index / 7;
    NSUInteger colums = index % 7;
    NSUInteger daysOffset = 7*rows + colums;
    //NSLog(@"row%ld col%ld daysoffset%ld",rows,colums,daysOffset);
    
    if (index <= 41) {
        return [self dateByAddingDays:daysOffset toDate:_firstDateOf2MonthAgoPage];
    } else if (index <= 83) {
        return [self dateByAddingDays:daysOffset-42 toDate:_firstDateOfLastPage];
    } else if (index <= 125) {
        return [self dateByAddingDays:daysOffset-84 toDate:_firstDateOfCurrentPage];
    } else if (index <= 167) {
        return [self dateByAddingDays:daysOffset-126 toDate:_firstDateOfNextPage];
    } else if (index <= 209) {
        return [self dateByAddingDays:daysOffset-168 toDate:_firstDateOf2MonthLaterPage];
    }
    
    return nil;
}


////---------------------------
////Tool
////---------------------------
//+ (NSDate *)localDateOfDate:(NSDate *)date {
//    NSTimeZone *zone = [NSTimeZone systemTimeZone];
//    NSInteger interval = [zone secondsFromGMTForDate:date];
//    
//    return [date dateByAddingTimeInterval:interval];
//}
//
//+ (NSInteger)weekdayOfDate:(NSDate *)date {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    return [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:date];;
//}
//
//+ (NSInteger)dayOfDate:(NSDate *)date {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:date];
//    return component.day;
//}
//
//+ (NSInteger)hourOfDate:(NSDate *)date {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:date];
//    return component.hour;
//}
//
//+ (BOOL)isDateToday:(NSDate *)date {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    return [calendar isDateInToday:date];
//}
//
//+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day {
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *components = [[NSDateComponents alloc] init];
//    components.year = year;
//    components.month = month;
//    components.day = day;
//    components.hour = 0;
//    NSDate *date = [calendar dateFromComponents:components];
//    
//    return date;
//}





@end
