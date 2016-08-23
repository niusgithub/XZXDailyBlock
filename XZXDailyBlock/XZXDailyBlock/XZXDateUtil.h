//
//  XZXDateUtil.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/29.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZXDateUtil : NSObject

+ (instancetype)sharedDateUtil;

// 当前本地日期(除去时间差)
+ (NSDate *)localDateOfDate:(NSDate *)date;

// 周
+ (NSInteger)weekdayOfDate:(NSDate *)date;

// 日期
+ (NSInteger)dayOfDate:(NSDate *)date;

// 时
+ (NSInteger)hourOfDate:(NSDate *)date;

+ (BOOL)isDateToday:(NSDate *)date;

+ (NSDate *)dateWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

+ (NSDate *)dateWithYear:(NSInteger)year
                   month:(NSInteger)month
                     day:(NSInteger)day
                    hour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

+ (NSDate *)dateByAddingSeconds:(NSUInteger)seconds toDate:(NSDate *)formerDate;


//---------------------------
//Formatter
//---------------------------
+ (NSString *)dateStringOf24H:(NSDate *)date;

+ (NSString *)dateStringOfMonthAndDay:(NSDate *)date;

+ (NSString *)dateStringOfHomeTitleWithMouthOffset:(NSInteger)offset;

+ (NSString *)dateStringOfYMD:(NSDate *)date;

+ (NSString *)dateStringOfYYMMDD:(NSDate *)date;

+ (NSString *)dateStringOfYMDHM:(NSDate *)date;

+ (NSDate *)dateOfYMD:(NSDate *)date;
@end
