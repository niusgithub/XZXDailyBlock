//
//  XZXClockViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/7.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "XZXClockVMServices.h"

typedef NS_ENUM(NSInteger, XZXClockStatus) {
    XZXClockStatusTicking,
    XZXClockStatusPause,
    XZXClockStatusOnResume,
    XZXClockStatusStop,
    XZXClockStatusCancel,
    XZXClockStatusFinish
};

@interface XZXClockViewModel : NSObject

//@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, copy) NSString *eventAbstruct;

@property (nonatomic, readonly) RACCommand *eventFinishCommand;
@property (nonatomic, assign) XZXClockStatus clockStatus;

- (instancetype)initWithServices:(id<XZXClockVMServices>)services;

@end
