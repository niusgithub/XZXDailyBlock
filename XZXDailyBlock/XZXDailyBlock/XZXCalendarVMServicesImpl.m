//
//  XZXCalendarVMServicesImpl.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/22.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarVMServicesImpl.h"
#import "XZXFetchDaysImpl.h"

@interface XZXCalendarVMServicesImpl ()
@property (nonatomic, strong) XZXFetchDaysImpl *searchService;
@end

@implementation XZXCalendarVMServicesImpl

- (instancetype)init {
    if (self = [super init]) {
        _searchService = [XZXFetchDaysImpl new];
    }
    
    return self;
}

- (id<XZXFetchDays>)getServices {
    return self.searchService;
}


@end
