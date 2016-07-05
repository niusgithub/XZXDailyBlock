//
//  XZXDateBlockCVCellViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/16.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayBlockCVCellViewModel.h"
#import "XZXCalendarUtil.h"
#import "XZXDateUtil.h"
#import "XZXDay.h"

@interface XZXDayBlockCVCellViewModel ()

@end

@implementation XZXDayBlockCVCellViewModel

- (instancetype)initWithDay:(XZXDay *)day {
    if (self = [super init]) {
//        NSLog(@"date:%@", day);
        self.dayEventVMs = [NSMutableArray new];

        _dateTitle = [NSString stringWithFormat:@"%ld", [XZXDateUtil dayOfDate:day.date]];

        self.level = day.dayLevel;
        
        self.isToday = [XZXDateUtil isDateToday:day.date];
        
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

@end
