//
//  XZXCalendarViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarViewModel.h"
#import "XZXDayBlockCVCellViewModel.h"

@interface XZXCalendarViewModel ()
@property (nonatomic, weak) id<XZXCalendarVMServices> services;
@end

@implementation XZXCalendarViewModel

- (instancetype)initWithServices:(id<XZXCalendarVMServices>)services {
    if (self = [super init]) {
        _services = services;
        [self initialize];
    }
    
    return self;
}

- (instancetype)initWithDays:(XZXDay *)days {
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
