//
//  XZXDayEventTVCellViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEventTVCellViewModel.h"
#import "XZXDateHelper.h"

@interface XZXDayEventTVCellViewModel ()
@property (nonatomic, strong) XZXDateHelper *helper;
@end

@implementation XZXDayEventTVCellViewModel

- (instancetype)initWithDayEvent:(XZXDayEvent *)dayEvent {
    if (self = [super init]) {
        self.helper = [[XZXDateHelper alloc] init];
        
        self.date = dayEvent.date;
        self.startTime = [_helper dateStringOf24H:dayEvent.startTime];
        self.endTime = [_helper dateStringOf24H:dayEvent.endTime];
        // self.levelViewBGColor =
        self.eventAbstruct = dayEvent.eventAbstruct;
    }
    return self;
}



@end
