//
//  XZXCalendarViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarViewModel.h"
#import "XZXDateBlockCVCellViewModel.h"

@implementation XZXCalendarViewModel

- (instancetype)initWithDates:(XZXDate *)dates {
    if (self = [super init]) {
        [self initialize];
        
//        _dates = [XZXCalendar ]
    }
    return self;
}

- (void)initialize {
    self.title = @"AIMeow";
}

@end
