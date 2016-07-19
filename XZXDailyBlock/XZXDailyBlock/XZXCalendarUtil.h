//
//  XZXCalendarUtil.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface XZXCalendarUtil : NSObject

// 
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;



//// 当前本地日期(除去时间差)
//+ (NSDate *)localDateOfDate:(NSDate *)date;
//
//// 周
//+ (NSInteger)weekdayOfDate:(NSDate *)date;
//
//// 日期
//+ (NSInteger)dayOfDate:(NSDate *)date;
//
//// 时
//+ (NSInteger)hourOfDate:(NSDate *)date;
//
//+ (BOOL)isDateToday:(NSDate *)date;
//
//+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

// 日期之间的所含的月数
- (NSInteger)monthsFromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

- (NSInteger)totalMonths;


//
//- (NSString *)dateStringOf24H:(NSDate *)date;

//- (NSString *)dateStringOfMonthAndDay:(NSDate *)date;


- (NSDate *)dateForIndex:(NSInteger)index;

@end
