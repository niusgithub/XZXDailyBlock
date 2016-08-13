//
//  XZXDayEventVC.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/14.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZXHorizontalWeekCV.h"

@interface XZXDayEventVC : UIViewController

@property (nonatomic, assign) NSInteger selectedItemIndex;

@property (nonatomic, weak) UIButton *startEventBtn;

#warning temp
@property (nonatomic, assign) CGFloat height;

@end
