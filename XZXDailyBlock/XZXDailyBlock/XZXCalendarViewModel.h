//
//  XZXCalendarViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@class XZXDay;

@interface XZXCalendarViewModel : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *dates;

- (instancetype)initWithDays:(XZXDay *)days;

@end
