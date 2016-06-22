//
//  XZXDay.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDay.h"

@implementation XZXDay

- (void)calculateDayLevel {
    
}

- (NSString *)description {
    return [NSString stringWithFormat:@"date:%@--event.count:%ld--level:%ld", self.date, self.events.count, self.dayLevel];
}

@end
