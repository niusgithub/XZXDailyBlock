//
//  XZXDBHelper.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/27.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDBHelper.h"
#import <Realm/Realm.h>

@implementation XZXDBHelper

+ (void)insertRealmWithEvent:(XZXDayEvent *)event toDay:(XZXDay *)day success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        RLMRealm *realm = [RLMRealm defaultRealm];
        [realm beginWriteTransaction];
        RLMResults<XZXDay *> *dayResults = [XZXDay objectsWhere:@"dateID=%@", day.dateID];
        if (dayResults.count<1) {
            [day calculateDayLevel];
            [realm addObject:day];
        } else {
            XZXDay *tempDay = [dayResults firstObject];
            [tempDay.events addObject:event];
            [tempDay calculateDayLevel];
        }
        
        NSError *error = nil;
        if([realm commitWriteTransaction:&error]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (successBlock) {
                    successBlock();
                }
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (failureBlock) {
                    successBlock(error);
                }
            });
        }
    });
}

@end
