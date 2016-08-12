//
//  XZXCalendarViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarViewModel.h"
#import "XZXDayBlockCVCellViewModel.h"
#import "XZXCalendarPage.h"
#import "XZXDateUtil.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XZXCalendarViewModel ()
@property (nonatomic, weak) id<XZXCalendarVMServices> services;
@end

@implementation XZXCalendarViewModel

- (instancetype)initWithServices:(id<XZXCalendarVMServices>)services {
    if (self = [super init]) {
        self.title = [XZXDateUtil dateStringOfHomeTitleWithMouthOffset:0];
        _services = services;
        self.cellViewModels = [NSMutableArray new];
        
        RAC(self, cellViewModels) = [self fetchDaysFromRealmSignal];
        //[self initialize];
    }
    return self;
}

- (RACSignal *)fetchDaysFromRealmSignal {
    id<XZXFetchDays> service = [self.services getServices];
    
    return [[service fetchDaysFromRealm] map:^id(NSArray *array) {
        return [[[array rac_sequence] map:^id(XZXDay *day) {
            return [[XZXDayBlockCVCellViewModel alloc] initWithDay:day];
        }] array];
    }];
}

//- (XZXDayBlockCVCellViewModel *)fetchTodayVM {
//    id<XZXFetchDays> service = [self.services getServices];
//    // 与Realm中NSDate格式统一   [XZXDateUtil dateOfYMD:[NSDate date]]
//    return [[XZXDayBlockCVCellViewModel alloc] initWithDay:[service fetchDayWithDate:[XZXDateUtil dateOfYMD:[NSDate date]]]];
//}

//- (void)initialize {
//    [self fetchDate];
//}
//
//- (void)fetchDate {
//    id<XZXFetchDays> fetchDateSerivce = [self.services getServices];
//    
//    self.title = [XZXDateUtil dateStringOfHomeTitleWithMouthOffset:0];
//    
////    for (NSString *s in [NSCalendar currentCalendar].monthSymbols) {
////        NSLog(@"weekSymbols:%@",s);
////    }
//    
//    
//    XZXCalendarPage *page = [fetchDateSerivce date4Page];
//    
//    for (int i = 0; i < page.days.count; ++i) {
//        XZXDayBlockCVCellViewModel *cellViewModel = [[XZXDayBlockCVCellViewModel alloc] initWithDay:page.days[i]];
//        
//        [self.cellViewModels addObject:cellViewModel];
//    }
//}

@end
