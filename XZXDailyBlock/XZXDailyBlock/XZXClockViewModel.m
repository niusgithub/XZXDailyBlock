//
//  XZXClockViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/7.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXClockViewModel.h"
#import "XZXDay.h"
#import "XZXDayEvent.h"
#import "XZXDateUtil.h"

@interface XZXClockViewModel ()

@property (nonatomic, strong) RACCommand *eventFinishCommand;
@property (nonatomic, weak) id<XZXClockVMServices> services;

// 开始计时改为RAC时也需要RACCommand
@end

@implementation XZXClockViewModel

- (instancetype)initWithServices:(id<XZXClockVMServices>)services {
    if (self = [super init]) {
        self.services = services;
        
        @weakify(self)
//        self.eventFinishCommand = [[RACCommand alloc] initWithEnabled:[self eventFinishSignal] signalBlock:^RACSignal *(id input) {
//            @strongify(self)
//            NSLog(@"eventFinishCommand");
//            [self addDayEvent];
//            return [[[[RACSignal empty] logAll] delay:1.0] logAll];
//        }];
        
        self.eventFinishCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self)
            [self addDayEvent];
            return [[[[RACSignal empty] logAll] delay:1.0] logAll];
        }];
    }
    
    return self;
}

- (RACSignal *)eventFinishSignal {
    return [RACObserve(self, clockStatus)
            map:^id(id value) {
                NSLog(@"XZXClockStatus%@",value);
                return @([value integerValue] == XZXClockStatusFinish);
            }];    
}

- (void)addDayEvent {
    //添加event到相应的day中
    NSDate *currentDate = [XZXDateUtil dateOfYMD:[NSDate date]];
    
    XZXDayEvent *event = [[XZXDayEvent alloc] init];
    event.eventID = [XZXDateUtil dateStringOfYMDHM:self.startTime];
    event.date = currentDate;
    event.startTime = self.startTime;
    event.endTime = self.endTime;
    event.eventAbstruct = self.eventAbstruct;
    
    XZXDay *day = [XZXDay new];
    day.dateID = [XZXDateUtil dateStringOfYYMMDD:currentDate];
    day.date = currentDate;
    [day.events addObject:event];
    
    id<XZXUpdateDays> service = [self.services getServices];
    [service addDayEvent:event toDay:day];
}

@end
