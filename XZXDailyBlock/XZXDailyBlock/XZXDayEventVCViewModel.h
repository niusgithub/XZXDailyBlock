//
//  XZXDayEventVCViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XZXWeekCalendarCVViewModel, XZXDayEventTVCellViewModel;

@interface XZXDayEventVCViewModel : NSObject

@property (nonatomic, copy) NSString *title;
//@property (nonatomic, strong) NSMutableArray<XZXWeekCalendarCVViewModel *> *collectionViewVM;
//@property (nonatomic, strong) NSMutableArray<XZXDayEventTVCellViewModel *> *tableViewVM;

- (void)initWithCollectionViewModel:(XZXWeekCalendarCVViewModel *)cvViewModel andTableViewModel:(XZXDayEventVCViewModel *)tViewModel;

@end
