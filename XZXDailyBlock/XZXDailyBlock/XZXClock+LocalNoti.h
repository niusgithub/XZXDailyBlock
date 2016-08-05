//
//  XZXClock+LocalNoti.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/5.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXClock.h"

@interface XZXClock (LocalNoti)

- (void)showLocalNotiWithTimeIntervalSinceNow:(NSTimeInterval)secs;

- (void)canelLocalNoti;

@end
