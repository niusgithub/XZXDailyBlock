//
//  XZXDayEventVCViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZXCalendarVMServicesImpl.h"
#import "XZXDayBlockCVCellViewModel.h"

@class XZXDayEventTVCellViewModel;

@interface XZXDayEventVCViewModel : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSMutableArray<XZXDayBlockCVCellViewModel *> *cellViewModels;
//@property (nonatomic, strong) NSMutableArray<XZXDayEventTVCellViewModel *> *tableViewVM;

- (instancetype)initWithServices:(id<XZXCalendarVMServices>)services;

@end
