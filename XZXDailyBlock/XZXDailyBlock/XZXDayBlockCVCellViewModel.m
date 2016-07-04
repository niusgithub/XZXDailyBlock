//
//  XZXDateBlockCVCellViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/16.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayBlockCVCellViewModel.h"
#import "XZXCalendarUtil.h"
#import "XZXDay.h"

@interface XZXDayBlockCVCellViewModel ()

@end

@implementation XZXDayBlockCVCellViewModel

//- (instancetype)init {
//    if ([super init]) {
//        self.dateHelper = [[XZXDateHelper alloc] init];
//    }
//    return self;
//}

- (instancetype)initWithDay:(XZXDay *)day {
    if (self = [super init]) {
        NSLog(@"date:%@", day);
        self.dayEventVMs = [NSMutableArray new];

        _dateTitle = [NSString stringWithFormat:@"%ld", [self dayOfDate:day.date]];

        self.level = day.dayLevel;
        
        self.isToday = [self isDateToday:day.date];
        
        if (_isToday) {
            
        }
        
        // 先去确定时间在今天之后 然后根据events数确定
        //self.hasSchedule =
        
        for (XZXDayEvent *event in day.events) {
            XZXDayEventTVCellViewModel *dayEventViewModel = [[XZXDayEventTVCellViewModel alloc] initWithDayEvent:event];
            [self.dayEventVMs addObject:dayEventViewModel];
        }        
    }
    return self;
}

//- (instancetype)initWithDate:(NSDate *)date {
//    if (self = [super init]) {
//        self.dataTitle = [NSString stringWithFormat:@"%ld", [self dayOfDate:date]];
//    }
//    return self;
//}

#warning temp

- (NSInteger)dayOfDate:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay
                                                   fromDate:date];
    return component.day;
}

- (BOOL)isDateToday:(NSDate *)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar isDateInToday:date];
}

@end
