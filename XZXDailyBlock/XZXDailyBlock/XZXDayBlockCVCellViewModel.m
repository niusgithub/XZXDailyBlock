//
//  XZXDateBlockCVCellViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/16.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayBlockCVCellViewModel.h"
#import "XZXDay.h"

@implementation XZXDayBlockCVCellViewModel

- (instancetype)initWithDay:(XZXDay *)day {
    if (self = [super init]) {
        //
        _dataTitle = [NSString stringWithFormat:@"%ld", [self dayOfDate:day.date]];
        self.level = day.dayLevel;
    }
    return self;
}

//- (instancetype)initWithDate:(NSDate *)date {
//    if (self = [super init]) {
//        self.dataTitle = [NSString stringWithFormat:@"%ld", [self dayOfDate:date]];
//    }
//    return self;
//}

- (NSInteger)dayOfDate:(NSDate *)date {
#warning temp
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *component = [calendar components:NSCalendarUnitDay
                                                   fromDate:date];
    return component.day;
}

@end
