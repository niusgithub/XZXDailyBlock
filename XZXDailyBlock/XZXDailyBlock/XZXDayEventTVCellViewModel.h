//
//  XZXDayEventTVCellViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZXDayEvent.h"

@import UIKit;

@interface XZXDayEventTVCellViewModel : NSObject

@property (nonatomic, copy) NSDate *date;
@property (nonatomic, copy) NSString *startTime;
@property (nonatomic, copy) NSString *endTime;
@property (nonatomic, strong) UIColor *levelViewBGColor;
@property (nonatomic, copy) NSString *eventAbstruct;

- (instancetype)initWithDayEvent:(XZXDayEvent *)dayEvent;

@end
