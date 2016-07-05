//
//  XZXFetchDaysImpl.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/22.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXFetchDaysImpl.h"
#import "XZXCalendarPage.h"
#import "XZXDay.h"
#import "XZXDayEvent.h"

#import "XZXDateUtil.h"
#import "XZXCalendarUtil.h"

@interface XZXFetchDaysImpl ()
@property (nonatomic, strong) XZXCalendarUtil *calendarUtil;
@property (nonatomic, strong) NSArray *dateArray;
@end

@implementation XZXFetchDaysImpl

- (instancetype)init {
    if (self = [super init]) {
        self.calendarUtil = [[XZXCalendarUtil alloc] init];
        self.dateArray = [NSArray array];
        
        // temp
        NSMutableArray *tempDateArray = [NSMutableArray array];
        for (int i = 0; i < 210; ++i) {
            XZXDay *day = [[XZXDay alloc] init];
            day.date = [_calendarUtil tempDateForIndex:i];
#warning dayLevel临时值
            day.dayLevel = i % 5;
            
            NSCalendar *calendar = [NSCalendar currentCalendar];
            NSDateComponents *component = [calendar components:NSCalendarUnitDay fromDate:day.date];
            XZXDayEvent *event = [[XZXDayEvent alloc] init];
            event.date = day.date;
            event.startTime = [XZXDateUtil dateWithYear:component.year month:component.month day:component.day hour:i%12 minute:15 second:15];
            event.endTime = [XZXDateUtil dateWithYear:component.year month:component.month day:component.day hour:(i+1)%12 minute:15 second:15];
            event.eventLevel = day.dayLevel;
            event.eventAbstruct = @"一项工作";
            
            XZXDayEvent *event1 = [[XZXDayEvent alloc] init];
            event1.date = day.date;
            event1.startTime = [XZXDateUtil dateWithYear:component.year month:component.month day:component.day hour:(i+1)%24 minute:30 second:0];
            event1.endTime = [XZXDateUtil dateWithYear:component.year month:component.month day:component.day hour:(i+2)%24 minute:30 second:0];
            event1.eventLevel = (day.dayLevel + 2)%5;
            event1.eventAbstruct = @"另一项工作";
            
            
            day.events = [@[event, event1] copy];
            
            
            
            [tempDateArray addObject:day];
        }
        self.dateArray = [tempDateArray copy];
    }
    return self;
}

- (RACSignal *)realmSearchSingal:(NSDate *)date {
    return [[[[RACSignal empty] logAll] delay:1.0] logAll];
}

#warning temp
- (XZXCalendarPage *)temporayData {
    XZXCalendarPage *page = [[XZXCalendarPage alloc] init];
    page.days = [self.dateArray copy];
    
    return page;
}

@end
