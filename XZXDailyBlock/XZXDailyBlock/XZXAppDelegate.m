//
//  XZXAppDelegate.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/8.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXAppDelegate.h"
#import <AVOSCloud/AVOSCloud.h>
#import <DKNightVersion/DKNightVersion.h>
#import "AVOSCloudCrashReporting.h"

@interface XZXAppDelegate ()

@end

@implementation XZXAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //AVOSCloud
    //崩溃报告
    [AVOSCloudCrashReporting enable];
    
    [AVOSCloud setApplicationId:@"hLjOfUjeDqeGWXlyeTU2DiMj-gzGzoHsz" clientKey:@"1jLtH1xn7U7bI1QK1GKvyAOB"];
    // 跟踪统计
    [AVAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //DKNightVersion
    [DKColorTable sharedColorTable].file = @"XZXColor.txt";
    
    //如果已经获得发送通知的授权则创建本地通知，否则请求授权(注意：如果不请求授权在设置中是没有对应的通知设置项的，也就是说如果从来没有发送过请求，即使通过设置也打不开消息允许设置)
    if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone) {
        UIUserNotificationSettings *setting = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:setting];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
}

@end
