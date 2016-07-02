
//
//  XZXTransitionAnimator.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/12.
//  Copyright © 2016年 陈知行. All rights reserved.
//

@import UIKit;

@interface XZXTransitionAnimator : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithDuration:(NSTimeInterval)duration splitLineY:(CGFloat)splitLineY barHeight:(CGFloat)height;

@end
