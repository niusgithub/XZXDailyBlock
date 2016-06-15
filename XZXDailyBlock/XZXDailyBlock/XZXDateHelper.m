//
//  XZXDateHelper.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDateHelper.h"

static id sharedDateHelper;

@interface XZXDateHelper ()
@property (nonatomic, strong) NSCalendar *calendar;
@end

@implementation XZXDateHelper

+ (instancetype)sharedDateHelper {
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedDateHelper = [[self alloc] init];
    });
    
    return sharedDateHelper;
}

- (instancetype)init {
    if (self = [super init]) {
        _calendar = [NSCalendar currentCalendar];
    }
    return self;
}

- (NSCalendar *)calendar {
    return _calendar;
}

@end
