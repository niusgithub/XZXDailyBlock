//
//  XZXCalendarViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarViewModel.h"

@implementation XZXCalendarViewModel

- (instancetype)init {
    if (self = [super init]) {
        [self initialize];
    }
    return self;
}

- (void)initialize {
    self.title = @"AIMeow";
}

@end
