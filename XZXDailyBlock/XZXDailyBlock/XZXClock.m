//
//  XZXClock.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/7.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXClock.h"
#import "XZXDayEvent.h"
#import "XZXClockViewModel.h"
#import "XZXDateUtil.h"

#import <DKNightVersion/DKNightVersion.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef NS_ENUM(NSInteger, XZXClockStatus) {
    XZXClockStatusTicking,
    XZXClockStatusPause,
    XZXClockStatusOnResume,
    XZXClockStatusStop,
    XZXClockStatusCancel,
    XZXClockStatusFinish
};

NSString* const kFlipStartAnim = @"flipTAnim";
NSString* const kFlipEndAnim = @"flipFAnim";
NSString* const kTickingAnim = @"tickingAnim";

@interface XZXClock ()
//@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) XZXClockViewModel *viewModel;
//@property (nonatomic, weak) XZXDayEvent *currentEvent;
//@property (nonatomic, strong) NSArray<XZXDayEvent *> *todayEvents;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *eventsView;
@property (nonatomic, strong) UILabel *eventTitle;

// clock View
@property (nonatomic, strong) UIView *clockView;
@property (nonatomic, strong) UILabel *clockLabel;
@property (nonatomic, strong) UIView *pointerView;
@property (nonatomic, assign) CGFloat pointerViewR;
@property (nonatomic, strong) NSDate *startTime;
@property (nonatomic, strong) NSDate *endTime;
@property (nonatomic, assign) NSTimeInterval timeLength; // float
@property (nonatomic, assign) NSTimeInterval timeSincePause;
@property (nonatomic, assign) NSTimeInterval setTimeLength; // float
@property (nonatomic, strong) NSTimer *countDownTimer;

// clock control
@property (nonatomic, strong) UIButton *cancelBtn;

@property (nonatomic, strong) CAKeyframeAnimation *addOneSecond;
//@property (nonatomic, assign) CGRect clockViewOriginFrame;
@property (nonatomic, assign) XZXClockStatus clockStatus;

@end

@implementation XZXClock

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDefaultSetting];
    
    [self initialize];
    
    [self bindViewModel];
}

/**
 *  初始化各个视图
 */
- (void)initialize {
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    // 完成设置后在UserDefault取出
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    
    // back button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"stop"] forState:UIControlStateNormal];
    [backBtn setImage:[UIImage imageNamed:@"stop_highlighted"] forState:UIControlStateHighlighted];
    [backBtn addTarget:self action:@selector(backButtonOnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:backBtn];
    self.backBtn = backBtn;
    
    
    // event block view
    //    UIView *eventsView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, _sideLength)];
    ////    eventsView.backgroundColor = [UIColor clearColor];
    //    eventsView.backgroundColor = [UIColor redColor];
    //    [self.view addSubview:eventsView];
    //    self.eventsView = eventsView;
    
    // clock view
    CGFloat clockViewD = width * 0.6;
    CGFloat clockViewR = width * 0.3;
    CGFloat centerX = width/2;
    CGFloat centerY = 64 + width/2;

    //    UIVisualEffectView *clockView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight]];
    //    clockView.frame = CGRectMake(centerX-clockViewR, centerY-clockViewR, clockViewD, clockViewD);
    UIView *clockView = [[UIView alloc] initWithFrame:CGRectMake(centerX-clockViewR, centerY-clockViewR, clockViewD, clockViewD)];
    clockView.backgroundColor = [UIColor clearColor];
    [clockView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clockViewOnClick)]];
    clockView.layer.cornerRadius = clockViewR;
    clockView.layer.borderWidth = 2.f;
    clockView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    clockView.clipsToBounds = YES;
    [self.view addSubview:clockView];
    self.clockView = clockView;
    
    self.pointerViewR = 20.f;
    
    UIView *pointerView = [[UIView alloc] initWithFrame:CGRectMake(centerX-10, centerY-clockViewR, _pointerViewR, _pointerViewR)];
    pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
    pointerView.layer.cornerRadius = 10.f;
    pointerView.layer.borderWidth = 2.f;
    pointerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view insertSubview:pointerView aboveSubview:self.clockView];
    self.pointerView = pointerView;
    
    UILabel *clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX-clockViewR, centerY-clockViewR, clockViewD, clockViewD)];
    //clockLabel.text = [NSString stringWithFormat:@"%@:00", [self textOfTime:self.timeLength/60]];
    clockLabel.text = [NSString stringWithFormat:@"开始"];
    clockLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    clockLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:clockLabel aboveSubview:clockView];
    self.clockLabel = clockLabel;
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(centerX-20 , centerY+clockViewR+20, 40, 40)];
    [cancelBtn setImage:[UIImage imageNamed:@"redStop"] forState:UIControlStateNormal];
    [cancelBtn setImage:[UIImage imageNamed:@"stop_highlighted"] forState:UIControlStateHighlighted];
    cancelBtn.backgroundColor = [UIColor clearColor];
    cancelBtn.layer.cornerRadius = 20.f;
    cancelBtn.layer.borderWidth = 1.f;
    cancelBtn.layer.borderColor = [UIColor redColor].CGColor;
    cancelBtn.alpha = 0; //  先通过透明隐藏
    [cancelBtn addTarget:self action:@selector(cancelButtonOnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    self.cancelBtn = cancelBtn;
}

- (void)initDefaultSetting {
//    self.level = 0;
    self.clockStatus = XZXClockStatusStop;
    
    self.setTimeLength = 1 * 60;
    self.timeLength = _setTimeLength;
}

- (void)bindViewModel {
//    [[RACObserve(self, level) distinctUntilChanged] subscribeNext:^(id x) {
//        [self changePointerColorWithLevel:[x integerValue]];
//    }];
    [RACObserve(self, clockStatus)
     subscribeNext:^(id x) {
        NSLog(@"status:%@",x);
    }];
}

// deprecated 实现复杂且不好看
// 四个时间段 四种不同的指针渐变色
//- (void)changePointerColorWithLevel:(NSInteger)level {
//    __weak __typeof__(self) weakSelf = self;
//    switch (level) {
//        case 0:
//            self.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
//            break;
//        case 1: {
//            [UIView animateWithDuration:self.setTimeLength/4 delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
//                __strong __typeof__(weakSelf) strongSelf = weakSelf;
//                strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV1);
//            } completion:NULL];
//        }
//            break;
//        case 2: {
//            [UIView animateWithDuration:8.f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
//                __strong __typeof__(weakSelf) strongSelf = weakSelf;
//                strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV2);
//            } completion:NULL];
//        }
//            break;
//        case 3: {
//            [UIView animateWithDuration:8.f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
//                __strong __typeof__(weakSelf) strongSelf = weakSelf;
//                strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV3);
//            } completion:NULL];
//        }
//            break;
//            // 只有全部完成才会LV4
//        case 4:
//            self.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV4);
//            break;
//    }
//}


#pragma mark - Click Event

- (void)backButtonOnClick {
    self.clockStatus = XZXClockStatusStop;
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}


/**
 *  大量快速点击后会有计时混乱的bug
 */
- (void)clockViewOnClick {
    // 判断状态
    // 开始
    if (self.clockStatus == XZXClockStatusStop) {
        self.clockStatus = XZXClockStatusTicking;
        [self flipClockView];
        return;
    }
    
    // 暂停
    if (self.clockStatus == XZXClockStatusTicking) {
        self.clockStatus = XZXClockStatusPause;
        [self pauseTicking];
        return;
    }
    
    // 恢复
    if (self.clockStatus == XZXClockStatusPause) {
        self.clockStatus = XZXClockStatusOnResume;
        [self resumeTicking];
        return;
    }
}

- (void)cancelButtonOnclick {
    // 取消当前任务
    self.clockStatus = XZXClockStatusCancel;
    // 动画
    UIView *maskView = [[UIView alloc] init];
    maskView.frame = self.cancelBtn.frame;
    maskView.layer.cornerRadius = 20.f;
    maskView.backgroundColor = [UIColor redColor];
    maskView.alpha = 0.75f;
    [self.view insertSubview:maskView aboveSubview:self.cancelBtn];
    
    CGAffineTransform zoom = CGAffineTransformScale(maskView.transform, 2, 2);
    
    [UIView animateWithDuration:0.5 animations:^{
        [maskView setTransform:zoom];
        maskView.alpha = 0;
        self.cancelBtn.alpha = 0;
    } completion:^(BOOL finished) {
        [maskView removeFromSuperview];
    }];
    
    // 移除番茄钟动画
    [self cancelLayer:self.pointerView.layer];
    [self.pointerView.layer removeAnimationForKey:kTickingAnim];
    
    // 翻转
    [self flipClockView];
    
    // 恢复计时初值
    self.timeLength = _setTimeLength;
    self.clockLabel.text = @"开始";
    self.timeSincePause = 0;
    self.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
}


#pragma mark - Ticking Animation

- (void)startTicking {
    
    self.startTime = [NSDate date];
    NSLog(@"startTime:%@",self.startTime);

    // animation
    CAKeyframeAnimation *tickingAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    //tickingAnim.keyPath = @"position";
    tickingAnim.path = [UIBezierPath bezierPathWithArcCenter:self.clockView.center radius:(self.clockView.frame.size.width-_pointerViewR)/2 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES].CGPath;
    tickingAnim.duration = 60.f;
    tickingAnim.repeatCount = self.timeLength/60;
    tickingAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    tickingAnim.delegate = self;
    [self.pointerView.layer addAnimation:tickingAnim forKey:kTickingAnim];
    
    // NSTimer
    self.countDownTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(countingTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}


- (void)pauseTicking {
    // 暂停指针动画
    [self pauseLayer:self.pointerView.layer];
    // 改变clockLabel文字并翻转
    [self flipClockView];
    // 淡入取消按钮
    [UIView animateWithDuration:0.25 animations:^{
        self.cancelBtn.alpha = 1.0;
    }];
    
    // 删除NSTimer
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}

- (void)resumeTicking {
    
    [self resumeLayer:self.pointerView.layer];
    
    [self flipClockView];
    
    // 淡出取消按钮
    [UIView animateWithDuration:0.25 animations:^{
        self.cancelBtn.alpha = 0;
    }];
    
    // 新建NSTimer并启动
    self.countDownTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(countingTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}


#pragma mark - Flip Animation

- (void)flipClockView {
    // 分两部分 第一部分先翻转90度
    CABasicAnimation *flipStartAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
    flipStartAnim.duration = 0.125;
    flipStartAnim.fromValue = @(0);
    flipStartAnim.toValue = @(M_PI_2);
    flipStartAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    flipStartAnim.fillMode = kCAFillModeForwards;
    flipStartAnim.removedOnCompletion = NO;
    flipStartAnim.delegate = self;
    [self.clockView.layer addAnimation:flipStartAnim forKey:kFlipStartAnim];
}


#pragma mark - Animation Control

- (void)animationDidStart:(CAAnimation *)anim {
    if ([anim isEqual:[self.pointerView.layer animationForKey:kTickingAnim]]) {
        
        _pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
        
        __weak __typeof__(self) weakSelf = self;
        [UIView animateWithDuration:self.setTimeLength delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV4);
        } completion:^(BOOL finished) {
            // 被中断也会进入该方法
            __strong __typeof__(weakSelf) strongSelf = weakSelf;
            
            self.endTime = [XZXDateUtil dateByAddingSeconds:strongSelf.setTimeLength - strongSelf.timeLength toDate:strongSelf.startTime];
            NSLog(@"self.stop:%@", self.endTime);
        }];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    
//    for (NSString *str in [self.pointerView.layer animationKeys]) {
//        NSLog(@"animationDidStop--animationKeys:%@",str);
//    }

    if ([anim isEqual:[self.clockView.layer animationForKey:kFlipStartAnim]]) {
        //
        if (self.clockStatus == XZXClockStatusPause) {
            self.clockLabel.text = @"暂停";
        } else if (self.clockStatus == XZXClockStatusOnResume || self.clockStatus == XZXClockStatusTicking) {
            self.clockLabel.text = [NSString stringWithFormat:@"%@:%@", [self textOfTime:self.timeLength/60], [self textOfTime:(long)self.timeLength%60]];
        }
        // 分两部分 第二部分再翻转90度
        CABasicAnimation *flipEndAnim = [CABasicAnimation animationWithKeyPath:@"transform.rotation.y"];
        flipEndAnim.duration = 0.125;
        flipEndAnim.fromValue = @(M_PI_2);
        flipEndAnim.toValue = @(M_PI);
        flipEndAnim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
        flipEndAnim.fillMode = kCAFillModeForwards;
        flipEndAnim.removedOnCompletion = NO;
        flipEndAnim.delegate = self;
        [self.clockView.layer addAnimation:flipEndAnim forKey:kFlipEndAnim];
    } else if ([anim isEqual:[self.clockView.layer animationForKey:kFlipEndAnim]]) {
        // 判断状态
        if (self.clockStatus == XZXClockStatusTicking) {
            // 反转结束后开始计时
            [self startTicking];
        } else if (self.clockStatus == XZXClockStatusOnResume) {
            // 改变状态
            self.clockStatus = XZXClockStatusTicking;
        } else if (self.clockStatus == XZXClockStatusCancel) {
            // 改变状态
            self.clockStatus = XZXClockStatusStop;
        }
    }
    
    // 未知BUG 能接收到animationDidStop<CAKeyframeAnimation: 0x7fb928e71bf0>~1但是判断失败
//    if ([anim isEqual:[self.pointerView.layer animationForKey:@"backgroundColor"]]) {
//        NSLog(@"animationDidStop%@",anim);
//        NSLog(@"stop");
//        
//        self.clockLabel.text = [NSString stringWithFormat:@"休息片刻"];
//        
//        self.endTime = [XZXDateUtil dateByAddingSeconds:_setTimeLength - _timeLength toDate:_startTime];
//        self.clockStatus = XZXClockStatusStop;
//        NSLog(@"self.stop:%@", self.endTime);
//    }

}

- (void)pauseLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
    layer.speed = 0.0;
    layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer {
    CFTimeInterval pausedTime = [layer timeOffset];
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
    self.timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
    layer.beginTime = _timeSincePause;
}

- (void)cancelLayer:(CALayer *)layer {
    layer.speed = 1.0;
    layer.timeOffset = 0.0;
    layer.beginTime = 0.0;
}


#pragma mark - Time

- (void)countingTime {
    // 更新时间
    NSTimeInterval pastTime = [[NSDate date] timeIntervalSinceDate:self.startTime] - self.timeSincePause;
    self.timeLength = self.setTimeLength - pastTime;
    self.clockLabel.text = [NSString stringWithFormat:@"%@:%@", [self textOfTime:self.timeLength/60], [self textOfTime:(long)self.timeLength%60]];
    //NSLog(@"time:%f text:%@", self.timeLength,self.clockLabel.text);
    
    // 更新等级
    //self.level = (int)(pastTime/self.setTimeLength*4);
    
    // 停止计时
    if (self.timeLength <= 0) {
        // 完成计时
        self.clockStatus = XZXClockStatusFinish;
        self.clockLabel.text = [NSString stringWithFormat:@"休息片刻"];
        
        self.endTime = [XZXDateUtil dateByAddingSeconds:self.setTimeLength - self.timeLength toDate:self.startTime];
        NSLog(@"self.stop:%@", self.endTime);
        
        [self.countDownTimer invalidate];
        self.countDownTimer = nil;
    }
}

- (NSString *)textOfTime:(NSInteger)time {
    if (time < 10) {
        return [NSString stringWithFormat:@"0%ld", time];
    } else {
        return [NSString stringWithFormat:@"%ld", time];
    }
}

- (void)dealloc {
    [_countDownTimer invalidate];
}
@end
