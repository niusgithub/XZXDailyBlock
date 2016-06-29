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



#import "XZXCalendarUtil.h"

@interface XZXFetchDaysImpl ()
@property (nonatomic, strong) XZXCalendarUtil *calendarUtil;
@end

@implementation XZXFetchDaysImpl

- (instancetype)init {
    if (self = [super init]) {
        self.calendarUtil = [[XZXCalendarUtil alloc] init];
    }
    return self;
}

- (RACSignal *)realmSearchSingal:(NSDate *)date {
    return [[[[RACSignal empty] logAll] delay:1.0] logAll];
}

#warning temp
- (XZXCalendarPage *)temporayData {
//    XZXDateHelper *helper = [[XZXDateHelper alloc] init];
    
    XZXCalendarPage *page = [[XZXCalendarPage alloc] init];
    
    for (int i = 0; i < 210; ++i) {
        XZXDay *day = [[XZXDay alloc] init];
        day.date = [_calendarUtil tempDateForIndex:i];
        NSLog(@"day.date:%@", day.date);
        
        day.dayLevel = i % 5;
        
        [page.days addObject:day];
    }
    
    return page;
}

@end
