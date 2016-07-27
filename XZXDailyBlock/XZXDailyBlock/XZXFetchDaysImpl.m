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

#import <Realm/Realm.h>

@interface XZXFetchDaysImpl ()
@property (nonatomic, strong) XZXCalendarUtil *calendarUtil;
//@property (nonatomic, strong) NSArray *dateArray;
@end

@implementation XZXFetchDaysImpl

- (instancetype)init {
    if (self = [super init]) {
        self.calendarUtil = [[XZXCalendarUtil alloc] init];
        //self.dateArray = [NSArray array];
        
//        NSMutableArray *dateArray = [NSMutableArray array];
//        
//        // index 0~125  前3页
//        
//        for (int i = 0; i <=125; ++i) {
//            XZXDay *day = [[XZXDay alloc] init];
//            
//            NSDate *date = [_calendarUtil dateForIndex:i];
//            
//            RLMResults<XZXDay *> *dayResults = [XZXDay objectsWhere:@"date=%@", date];
//            if (dayResults.count > 0) {
//                day = [dayResults firstObject];
//                // day.dayLevel = day
//                // NSLog(@"exist day:%@ eventCount:%ld",day,day.events.count);
//            } else {
//                // 当天没有活动不会记录在realm中，只提供首页的显示用XZXDay
//                day.date = date;
//                day.dayLevel = 0;
//            }
//            [dateArray addObject:day];
//        }
//        
//        // 预留给以后添加计划任务
//        for (int i = 126; i < 210; ++i) {
//            XZXDay *day = [[XZXDay alloc] init];
//            NSDate *date = [_calendarUtil dateForIndex:i];
//            day.date = date;
//            day.dayLevel = 0;
//            
//            [dateArray addObject:day];
//        }
//        self.dateArray = [dateArray copy];
    }
    return self;
}

//- (RACSignal *)realmSearchSingal:(NSDate *)date {
//    return [[[[RACSignal empty] logAll] delay:1.0] logAll];
//}

/*
 暂不改动原因：在for循环中每次开启异步线程执行单条查询消耗估计比现在还大
 优化思路：将Realm查询解耦放在XZXDBHelper中，在fetchDaysFromRealm中只通过minDate和maxDate查询。
 */
- (RACSignal *)fetchDaysFromRealm {
    @weakify(self)
    
    RACSignal *fetchDaysSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self)
        NSMutableArray *date = [NSMutableArray arrayWithCapacity:210];
        for (int i = 0; i < 210; ++i) {
            [date addObject:[self.calendarUtil dateForIndex:i]];
        }
        [subscriber sendNext:date];
        [subscriber sendCompleted];
        
        return nil;
    }];
    
    return [fetchDaysSignal map:^id(NSArray *array) {
        return [[array.rac_sequence map:^id(NSDate* date) {
            XZXDay *day = [[XZXDay alloc] init];
            
            RLMResults<XZXDay *> *dayResults = [XZXDay objectsWhere:@"date=%@", date];
            if (dayResults.count > 0) {
                day = [dayResults firstObject];
                // day.dayLevel = day
                // NSLog(@"exist day:%@ eventCount:%ld",day,day.events.count);
            } else {
                // 当天没有活动不会记录在realm中，只提供首页的显示用XZXDay
                day.date = date;
                day.dayLevel = 0;
            }
            
            return day;
        }] array];
    }];
}

#warning temp
//- (XZXCalendarPage *)date4Page {
//    XZXCalendarPage *page = [[XZXCalendarPage alloc] init];
//    page.days = [self.dateArray copy];
//    
//    return page;
//}

//- (NSDate *)today {
//    return [XZXDateUtil localDateOfDate:[NSDate date]];
//}

@end
