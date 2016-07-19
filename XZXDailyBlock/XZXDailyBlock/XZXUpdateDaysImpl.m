//
//  XZXUpdateDaysImpl.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/18.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXUpdateDaysImpl.h"
#import "XZXDay.h"
#import "XZXDayEvent.h"

#import <Realm/Realm.h>

@implementation XZXUpdateDaysImpl

//- (RACSignal *)updateDays:(NSArray *)days {
//    //
//    
//    
//    RLMRealm *realm = [RLMRealm defaultRealm];
//    [realm beginWriteTransaction];
//    for (XZXDay *day in days) {
//        [realm addObject:day];
//    }
//    [realm commitWriteTransaction];
//    
//    return [[[[RACSignal empty] logAll] delay:1.0] logAll];
//}

- (void)addDayEvent:(XZXDayEvent *)event toDay:(XZXDay *)day {
    __block XZXDay *blockDay = day;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"dateID=%@", blockDay.dateID];
        //
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        RLMResults<XZXDay *> *dayResults = [XZXDay objectsWithPredicate:pred];
        if (dayResults.count<1) {
            [blockDay calculateDayLevel];
            [realm addObject:blockDay];
        } else {
            blockDay = [dayResults firstObject];
            [blockDay.events addObject:event];
            [blockDay calculateDayLevel];
        }
        [realm commitWriteTransaction];
    });
}

@end
