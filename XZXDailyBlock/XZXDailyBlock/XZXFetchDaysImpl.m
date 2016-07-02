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
            
            day.dayLevel = i % 5;
            
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
