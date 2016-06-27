//
//  XZXCalendarViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZXCalendarVMServices.h"

#import "XZXDayBlockCVCellViewModel.h"

@class XZXDay;

@interface XZXCalendarViewModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSMutableArray<XZXDayBlockCVCellViewModel *> *cellViewModels;


//- (instancetype)initWithDays:(XZXDay *)days;

- (instancetype)initWithServices:(id<XZXCalendarVMServices>)services;

@end
