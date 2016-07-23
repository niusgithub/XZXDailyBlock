//
//  XZXMetamacro.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/23.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#ifndef XZXMetamacro_h
#define XZXMetamacro_h

// 调试状态，打开log
#ifdef DEBUG
#define XZXLog(...) NSLog(__VA_ARGS__)
#else // 发布状态,关闭log功能
#define XZXLog(...)
#endif

// System
#define MainScreenHeight [[UIScreen mainScreen] bounds].size.height
#define MainScreenWidth [[UIScreen mainScreen] bounds].size.width
#define DeviceSysVer [[[UIDevice currentDevice] systemVersion] doubleValue]
#define RootViewController [UIApplication sharedApplication].keyWindow.rootViewController
#define RootWindow [UIApplication sharedApplication].keyWindow
#define MainFrame [[UIScreen mainScreen] bounds]

#endif /* XZXMetamacro_h */
