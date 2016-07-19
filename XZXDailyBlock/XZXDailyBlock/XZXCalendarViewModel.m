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

@interface XZXCalendarViewModel ()
@property (nonatomic, weak) id<XZXCalendarVMServices> services;
@end

@implementation XZXCalendarViewModel

- (instancetype)initWithServices:(id<XZXCalendarVMServices>)services {
    if (self = [super init]) {
        self.cellViewModels = [[NSMutableArray alloc] initWithCapacity:42];
        _services = services;
        [self initialize];
    }
    
    return self;
}

- (void)initialize {
    self.title = @"AIMeow";
    
    [self fetchDate];
}

- (void)fetchDate {
    id<XZXFetchDays> temp = [self.services getServices];
    
    XZXCalendarPage *page = [temp date4Page];
    
    for (int i = 0; i < page.days.count; ++i) {
        XZXDayBlockCVCellViewModel *cellViewModel = [[XZXDayBlockCVCellViewModel alloc] initWithDay:page.days[i]];
        
        [self.cellViewModels addObject:cellViewModel];
    }
}

@end
