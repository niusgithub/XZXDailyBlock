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



#import "XZXDateHelper.h"

@implementation XZXFetchDaysImpl

- (RACSignal *)realmSearchSingal:(NSDate *)date {
    return [[[[RACSignal empty] logAll] delay:1.0] logAll];
}

#warning temp
- (XZXCalendarPage *)temporayData {
    XZXDateHelper *helper = [[XZXDateHelper alloc] init];
    
    XZXCalendarPage *page = [[XZXCalendarPage alloc] init];
    
    for (int i = 0; i < 42; ++i) {
        XZXDay *day = [[XZXDay alloc] init];
        day.date = [helper tempDateForIndex:i];
        day.dayLevel = i % 4;
        
        [page.days addObject:day];
    }
    
    return page;
}

@end
