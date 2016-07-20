//
//  XZXDay.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDay.h"
#import "XZXDateUtil.h"

@implementation XZXDay

+ (NSString *)primaryKey {
    return @"dateID";
}

+ (NSArray *)indexedProperties {
    return @[@"date"];
}

- (void)calculateDayLevel {
    // ceil 向上取整   floor 向下取整
    if (self.events.count <= 8) {
        self.dayLevel = ceil(self.events.count / 2.0);
    } else {
        self.dayLevel = 4;
    }
}

- (NSString *)description {
    return [NSString stringWithFormat:@"date:%@--event.count:%ld--level:%ld", self.date, self.events.count, self.dayLevel];
}

@end
