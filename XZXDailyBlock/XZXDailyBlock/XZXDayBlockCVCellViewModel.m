//
//  XZXDateBlockCVCellViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/16.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayBlockCVCellViewModel.h"
#import "XZXDateHelper.h"
#import "XZXDay.h"

@interface XZXDayBlockCVCellViewModel ()
@property (nonatomic, strong) XZXDateHelper *dateHelper;
@end

@implementation XZXDayBlockCVCellViewModel

- (instancetype)initWithDay:(XZXDay *)day {
    if (self = [super init]) {
        
        self.dateHelper = [[XZXDateHelper alloc] init];
        
        //
        _dataTitle = [NSString stringWithFormat:@"%ld", [_dateHelper dayOfDate:day.date]];
        self.level = day.dayLevel;
        
        self.isToday = [_dateHelper isDateToday:day.date];
        
        // 先去确定时间在今天之后 然后根据events数确定
        //self.hasSchedule =
        
    }
    return self;
}

//- (instancetype)initWithDate:(NSDate *)date {
//    if (self = [super init]) {
//        self.dataTitle = [NSString stringWithFormat:@"%ld", [self dayOfDate:date]];
//    }
//    return self;
//}

//- (NSInteger)dayOfDate:(NSDate *)date {
//#warning temp
//    NSCalendar *calendar = [NSCalendar currentCalendar];
//    NSDateComponents *component = [calendar components:NSCalendarUnitDay
//                                                   fromDate:date];
//    return component.day;
//}

@end
