//
//  XZXDayEventVCViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEventVCViewModel.h"
#import "XZXDay.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XZXDayEventVCViewModel ()
@property (nonatomic, weak) id<XZXCalendarVMServices> services;
@end

@implementation XZXDayEventVCViewModel

- (instancetype)initWithServices:(id<XZXCalendarVMServices>)services {
    if (self = [super init]) {
        self.dayBlockVMs = [NSMutableArray new];
        self.services = services;
        RAC(self, dayBlockVMs) = [self fetchDaysFromRealmSignal];
        //[self initialize];
    }
    return self;
}

//- (void)initialize {
//    [self fetchDate];
//}
//
//
//- (void)fetchDate {
//    id<XZXFetchDays> temp = [self.services getServices];
//    
//    XZXCalendarPage *page = [temp date4Page];
//    
//    for (int i = 0; i < page.days.count; ++i) {
//        XZXDay *day = page.days[i];
//        
//        XZXDayBlockCVCellViewModel *dayBlockViewModel = [[XZXDayBlockCVCellViewModel alloc] initWithDay:day];
//        [self.dayBlockVMs addObject:dayBlockViewModel];
//    }
//}

- (RACSignal *)fetchDaysFromRealmSignal {
    id<XZXFetchDays> service = [self.services getServices];
    
    return [[service fetchDaysFromRealm] map:^id(NSArray *array) {
         return [[[array rac_sequence] map:^id(XZXDay *day) {
             return [[XZXDayBlockCVCellViewModel alloc] initWithDay:day];
         }] array];
     }];
}

@end
