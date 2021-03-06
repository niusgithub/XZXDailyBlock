//
//  XZXDayEvent.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/19.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@interface XZXDayEvent : RLMObject

//typedef NS_ENUM(NSInteger, XZXDayEventLevel) {
//    XZXDayEventLevel0,
//    XZXDayEventLevel1,
//    XZXDayEventLevel2,
//    XZXDayEventLevel3,
//    XZXDayEventLevel4
//};

@property (nonatomic, copy) NSString *eventID;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, assign) NSInteger eventLevel;
@property (nonatomic, copy) NSString *eventAbstruct;

@property (readonly) RLMLinkingObjects *owners;

@end

RLM_ARRAY_TYPE(XZXDayEvent)
