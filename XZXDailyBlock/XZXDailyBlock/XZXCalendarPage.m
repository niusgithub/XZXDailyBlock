//
//  XZXCalendarPage.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/22.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarPage.h"

@implementation XZXCalendarPage

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.days = [[NSMutableArray alloc] initWithCapacity:42];
    }
    return self;
}

@end
