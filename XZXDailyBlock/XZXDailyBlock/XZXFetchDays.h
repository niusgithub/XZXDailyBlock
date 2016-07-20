//
//  XZXFetchDays.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/22.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Reactivecocoa/Reactivecocoa.h>

@import UIKit;

@class XZXCalendarPage;

@protocol XZXFetchDays <NSObject>

- (RACSignal *)realmSearchSingal:(NSDate *)date;

- (XZXCalendarPage *)date4Page;

//- (NSDate *)today;

@end
