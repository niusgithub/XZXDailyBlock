//
//  XZXCalendarPage.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/22.
//  Copyright © 2016年 陈知行. All rights reserved.
//

//  日历一页的所有XZXDay的集合

#import <Foundation/Foundation.h>

@interface XZXCalendarPage : NSObject

@property (nonatomic, strong) NSDate *date; //当前页的月份
@property (nonatomic, strong) NSArray *days;

@end
