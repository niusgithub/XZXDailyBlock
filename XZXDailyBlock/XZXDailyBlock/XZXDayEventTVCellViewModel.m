//
//  XZXDayEventTVCellViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEventTVCellViewModel.h"
#import "XZXDateUtil.h"

@interface XZXDayEventTVCellViewModel ()

@end

@implementation XZXDayEventTVCellViewModel

- (instancetype)initWithDayEvent:(XZXDayEvent *)dayEvent {
    if (self = [super init]) {
        self.date = dayEvent.date;
        self.startTime = [XZXDateUtil dateStringOf24H:dayEvent.startTime];
        self.endTime = [XZXDateUtil dateStringOf24H:dayEvent.endTime];
        self.level = dayEvent.eventLevel;
        self.eventAbstruct = dayEvent.eventAbstruct;
    }
    return self;
}

@end
