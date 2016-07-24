//
//  XZXUpdateDays.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/18.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reactivecocoa/Reactivecocoa.h>

@class XZXDay,XZXDayEvent;

@protocol XZXUpdateDays <NSObject>

//- (RACSignal *)updateDays:(NSArray *)days;

- (void)addDayEvent:(XZXDayEvent *)event toDay:(XZXDay *)day;

@end
