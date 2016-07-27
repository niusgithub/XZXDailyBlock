//
//  XZXDBHelper.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/27.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "XZXDayEvent.h"
#import "XZXDay.h"

@interface XZXDBHelper : NSObject

+ (void)insertRealmWithEvent:(XZXDayEvent *)event toDay:(XZXDay *)day success:(void(^)())successBlock failure:(void(^)(NSError *error))failureBlock;

@end
