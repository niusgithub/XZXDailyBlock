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
//    NSMutableArray *tempArray = [day.events mutableCopy];
//    [tempArray addObject:event];
//    day.events = [tempArray copy];
    
    
    RLMRealm *realm = [RLMRealm defaultRealm];
    [realm beginWriteTransaction];
    [realm addObject:event];
    [realm addObject:day];
//    [day.events addObject:event];
    [realm commitWriteTransaction];
}

@end
