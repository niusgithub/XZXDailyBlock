//
//  XZXDayEvent.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/19.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEvent.h"
#import "XZXDay.h"

@implementation XZXDayEvent

+ (NSDictionary *)linkingObjectsProperties {
    return @{
             @"owners": [RLMPropertyDescriptor descriptorWithClass:XZXDay.class propertyName:@"events"]
             };
}

@end
