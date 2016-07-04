//
//  XZXDayBlockCVCellViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/16.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZXDayEventTVCellViewModel.h"

@class XZXDay;

@import UIKit;

@interface XZXDayBlockCVCellViewModel : NSObject

@property (nonatomic, strong) NSString *dateTitle;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) BOOL isToday;

@property (nonatomic, assign) BOOL hasSchedule;

@property (nonatomic, strong) NSMutableArray<XZXDayEventTVCellViewModel *> *dayEventVMs;

- (instancetype)initWithDay:(XZXDay *)day;

//- (instancetype)initWithDate:(NSDate *)date;


@end
