//
//  XZXClockVMServicesImpl.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/18.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXClockVMServicesImpl.h"
#import "XZXUpdateDaysImpl.h"

@interface XZXClockVMServicesImpl ()
@property (nonatomic, strong) XZXUpdateDaysImpl *updateService;
@end

@implementation XZXClockVMServicesImpl

- (instancetype)init {
    if (self = [super init]) {
        self.updateService = [XZXUpdateDaysImpl new];
    }
    return self;
}

- (id<XZXUpdateDays>)getServices {
    return self.updateService;
}

@end
