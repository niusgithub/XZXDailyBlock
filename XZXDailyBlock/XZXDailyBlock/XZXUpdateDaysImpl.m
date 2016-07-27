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
#import "XZXDBHelper.h"
#import "XZXMetamacro.h"

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

- (RACSignal *)addToDBDayEvent:(XZXDayEvent *)event toDay:(XZXDay *)day {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [XZXDBHelper insertRealmWithEvent:event toDay:day success:^{
            [subscriber sendCompleted];
        } failure:^(NSError *error) {
            XZXLog(@"addToRealmDayEvent ERR:%@",error);
            [subscriber sendError:[NSError errorWithDomain:@"addToRealmDayEvent" code:0 userInfo:@{NSLocalizedDescriptionKey: @"Insert DB error."}]];
        }];
        
        return nil;
    }];
}


//- (void)addDayEvent:(XZXDayEvent *)event toDay:(XZXDay *)day {
//    __block XZXDay *blockDay = day;
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        
//        //NSPredicate *pred = [NSPredicate predicateWithFormat:@"dateID=%@", blockDay.dateID];
//        //RLMResults<XZXDay *> *dayResults = [XZXDay objectsWithPredicate:pred];
//        RLMRealm *realm = [RLMRealm defaultRealm];
//        [realm beginWriteTransaction];
//        RLMResults<XZXDay *> *dayResults = [XZXDay objectsWhere:@"dateID=%@", day.dateID];
//        
//        if (dayResults.count<1) {
//            [blockDay calculateDayLevel];
//            [realm addObject:blockDay];
//        } else {
//            blockDay = [dayResults firstObject];
//            [blockDay.events addObject:event];
//            [blockDay calculateDayLevel];
//        }
//        [realm commitWriteTransaction];
//    });
//}

@end
