//
//  XZXDay.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>
#import "XZXDayEvent.h"

//typedef NS_ENUM(NSInteger, XZXDayLevel) {
//    XZXDayLevel0,
//    XZXDayLevel1,
//    XZXDayLevel2,
//    XZXDayLevel3,
//    XZXDayLevel4
//};

@interface XZXDay : RLMObject

@property (nonatomic, copy) NSString *dateID;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) RLMArray<XZXDayEvent *><XZXDayEvent> *events;
@property (nonatomic, assign) NSInteger dayLevel;

- (void)calculateDayLevel;

@end

RLM_ARRAY_TYPE(XZXDay)
