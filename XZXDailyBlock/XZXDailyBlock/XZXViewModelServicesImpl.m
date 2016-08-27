//
//  XZXViewModelServicesImpl.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/27.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXViewModelServicesImpl.h"
#import "XZXFetchDaysImpl.h"
#import "XZXUpdateDaysImpl.h"

@implementation XZXViewModelServicesImpl

@synthesize fetchDaysService = _fetchDaysService;
@synthesize updateDaysService = _updateDaysService;

- (instancetype)init {
    if (self = [super init]) {
        _fetchDaysService = [[XZXFetchDaysImpl alloc] init];
        _updateDaysService = [[XZXUpdateDaysImpl alloc] init];
    }
    return self;
}

@end
