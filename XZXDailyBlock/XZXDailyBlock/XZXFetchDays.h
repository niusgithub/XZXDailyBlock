//
//  XZXFetchDays.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/22.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@import UIKit;

@class XZXCalendarPage;

@protocol XZXFetchDays <NSObject>

- (RACSignal *)fetchDaysFromRealm;

// 可以通过调用一个封装AFN的Util实现
- (RACSignal *)fetchDaysFromServer;

//- (XZXCalendarPage *)date4Page;

//- (NSDate *)today;

@end
