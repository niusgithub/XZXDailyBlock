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
        self.days = [[NSArray alloc] init];
    }
    return self;
}

@end
