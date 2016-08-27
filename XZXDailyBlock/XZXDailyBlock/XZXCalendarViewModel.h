//
//  XZXCalendarViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXViewModel.h"
#import "XZXDayBlockCVCellViewModel.h"

@interface XZXCalendarViewModel : XZXViewModel

@property (nonatomic, strong) NSMutableArray<XZXDayBlockCVCellViewModel *> *cellViewModels;

@end
