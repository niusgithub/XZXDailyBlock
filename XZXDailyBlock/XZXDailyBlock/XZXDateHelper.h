//
//  XZXDateHelper.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

@interface XZXDateHelper : NSObject

// 
- (NSDate *)dateForIndexPath:(NSIndexPath *)indexPath;



// 当前本地日期(除去时间差)
- (NSDate *)localDateOfDate:(NSDate *)date;

// 周
- (NSInteger)weekdayOfDate:(NSDate *)date;

// 日期
- (NSInteger)dayOfDate:(NSDate *)date;

// 时
- (NSInteger)hourOfDate:(NSDate *)date;


//
- (NSString *)dateStringOf24H:(NSDate *)date;

- (NSString *)dateStringOfMonthAndDay:(NSDate *)date;

@end
