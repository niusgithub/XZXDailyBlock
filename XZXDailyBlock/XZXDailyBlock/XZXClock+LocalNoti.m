//
//  XZXClock+LocalNoti.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/5.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXClock+LocalNoti.h"

@implementation XZXClock (LocalNoti)

- (void)canelLocalNoti {
    // 获得UIApplication
    UIApplication *app = [UIApplication sharedApplication];
    
    //获取本地推送数组
    NSArray *localNotiArray = [app scheduledLocalNotifications];
    
    //声明本地通知对象
    UILocalNotification *localNotification = nil;
    if (localNotiArray) {
        for (UILocalNotification *noti in localNotiArray) {
            NSDictionary *dict = noti.userInfo;
            if (dict) {
                NSString *inKey = [dict objectForKey:@"localNoti"];
                if ([inKey isEqualToString:@"XZXDailyBlock"]) {
                    localNotification = noti;
                    break;
                }
            }
        }
        
        if (localNotification) {
            //取消本地推送
            [app cancelLocalNotification:localNotification];
            return;
        }
    }
}

- (void)showLocalNotiWithTimeIntervalSinceNow:(NSTimeInterval)secs {
    // 显示本地通知
    UILocalNotification *localNoti = [[UILocalNotification alloc] init];
    localNoti.timeZone = [NSTimeZone defaultTimeZone];
    localNoti.fireDate = [NSDate dateWithTimeIntervalSinceNow:secs];
    localNoti.soundName = UILocalNotificationDefaultSoundName;
    
    localNoti.alertBody = [NSString stringWithFormat:@"%@完成，休息一下吧。", self.eventTextField.text];
    localNoti.alertAction = @"打开";
    //localNoti.repeatInterval = 0;
    // localNoti.alertLaunchImage=@"Default";
    // localNoti.applicationIconBadgeNumber = 1;
    
    NSDictionary* localNotiDic = [NSDictionary dictionaryWithObject:@"XZXDailyBlock" forKey:@"localNoti"];
    localNoti.userInfo = localNotiDic;
    //发送通知
    [[UIApplication sharedApplication] scheduleLocalNotification:localNoti];
    // [[UIApplication sharedApplication] presentLocalNotificationNow:localNoti];
}

@end
