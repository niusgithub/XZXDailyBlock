//
//  XZXCalendarViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarViewModel.h"
//#import "XZXCalendarVMServicesImpl.h"
#import "XZXDayBlockCVCellViewModel.h"
#import "XZXDateUtil.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

//@interface XZXCalendarViewModel ()
//@property (nonatomic, weak) id<XZXCalendarVMServices> services;
//@end

@implementation XZXCalendarViewModel

- (instancetype)initWithServices:(id<XZXViewModelServices>)services {
    if (self = [super initWithServices:services]) {
        self.cellViewModels = [NSMutableArray new];
    }
    return self;
}

- (void)xzx_initialize {
    [super xzx_initialize];
    
    self.title = [XZXDateUtil dateStringOfHomeTitleWithMouthOffset:0];

    RAC(self, cellViewModels) = [self fetchDaysFromRealmSignal];
}

- (RACSignal *)fetchDaysFromRealmSignal {
    id<XZXFetchDays> service = [self.services fetchDaysService];
    
    return [[service fetchDaysFromRealm] map:^id(NSArray *array) {
        return [[[array rac_sequence] map:^id(XZXDay *day) {
            return [[XZXDayBlockCVCellViewModel alloc] initWithDay:day];
        }] array];
    }];
}


@end
