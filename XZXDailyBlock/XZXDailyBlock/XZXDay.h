//
//  XZXDay.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XZXDayEvent.h"

typedef NS_ENUM(NSInteger, XZXDayLevel) {
    XZXDayLevel1,
    XZXDayLevel2,
    XZXDayLevel3,
    XZXDayLevel4
};

@interface XZXDay : NSObject

@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSMutableArray<XZXDayEvent *> *events;
@property (nonatomic, assign) XZXDayLevel *dayLevel;

@end
