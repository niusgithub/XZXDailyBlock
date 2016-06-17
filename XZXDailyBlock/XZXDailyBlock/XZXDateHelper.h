//
//  XZXDateHelper.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/15.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
@import UIKit;

@interface XZXDateHelper : NSObject

//+ (instancetype)sharedDateHelper;

// Date的日期
- (NSInteger)dayOfDate:(NSDate *)date;


// 
- (NSDate *)dayForIndexPath:(NSIndexPath *)indexPath;

// 当前本地日期
- (NSDate *)localDate;

@end
