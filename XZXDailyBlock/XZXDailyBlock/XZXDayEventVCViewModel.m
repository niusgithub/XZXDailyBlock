//
//  XZXDayEventVCViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEventVCViewModel.h"
#import "XZXDayEventTVCellViewModel.h"
#import "XZXDay.h"
#import "XZXDayEvent.h"
#import "XZXCalendarPage.h"

@interface XZXDayEventVCViewModel ()
@property (nonatomic, weak) id<XZXCalendarVMServices> services;
@end

@implementation XZXDayEventVCViewModel

- (instancetype)initWithServices:(id<XZXCalendarVMServices>)services {
    if (self = [super init]) {
        self.dayBlockVMs = [NSMutableArray new];
        self.services = services;
        [self initialize];
    }
    return self;
}

- (void)initialize {
    [self fetchDate];
}


- (void)fetchDate {
    id<XZXFetchDays> temp = [self.services getServices];
    
    XZXCalendarPage *page = [temp date4Page];
    
    for (int i = 0; i < page.days.count; ++i) {
        XZXDay *day = page.days[i];
        
        XZXDayBlockCVCellViewModel *dayBlockViewModel = [[XZXDayBlockCVCellViewModel alloc] initWithDay:day];
        [self.dayBlockVMs addObject:dayBlockViewModel];
    }
}

@end
