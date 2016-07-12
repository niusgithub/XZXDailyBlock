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
    XZXClockStatusStop
};

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
//@property (nonatomic, assign) NSInteger level;

// clock control
@property (nonatomic, strong) UIButton *stopBtn;

@property (nonatomic, strong) CAKeyframeAnimation *addOneSecond;
//@property (nonatomic, assign) CGRect clockViewOriginFrame;
@property (nonatomic, assign) XZXClockStatus clockStatus;

@end

@implementation XZXClock

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initDefaultSetting];
    
    [self initialize];
    
    //[self bindViewModel];
}

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
    [clockView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(startTicking)]];
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
    clockLabel.text = [NSString stringWithFormat:@"%@:00", [self textOfTime:self.timeLength/60]];
    clockLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:50];
    clockLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:clockLabel aboveSubview:clockView];
    self.clockLabel = clockLabel;
    
    UIButton *stopBtn = [[UIButton alloc] initWithFrame:CGRectMake(centerX-20 , centerY+clockViewR+20, 40, 40)];
    [stopBtn setImage:[UIImage imageNamed:@"redStop"] forState:UIControlStateNormal];
    [stopBtn setImage:[UIImage imageNamed:@"stop_highlighted"] forState:UIControlStateHighlighted];
    stopBtn.backgroundColor = [UIColor clearColor];
    stopBtn.layer.cornerRadius = 20.f;
    stopBtn.layer.borderWidth = 1.f;
    stopBtn.layer.borderColor = [UIColor redColor].CGColor;
    stopBtn.alpha = 0; //  先通过透明隐藏
    [self.view addSubview:stopBtn];
    self.stopBtn = stopBtn;
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
}

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


#pragma mark - Button Click

- (void)backButtonOnClick {
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Clock View

- (void)startTicking {
#warning 逻辑考虑不全 先测试暂停
    if (self.clockStatus == XZXClockStatusTicking) {
        // 暂停
        [self pauseTicking];
        return;
    }
    
    if (self.clockStatus == XZXClockStatusPause) {
        // 恢复
        [self resumeticking];
        return;
    }
    
//    if (self.clockStatus == XZXClockStatusStop) {
//        
//        return;
//    }
    
    NSLog(@"startTicking");
    self.clockStatus = XZXClockStatusTicking;
    self.startTime = [NSDate date];
    NSLog(@"startTime:%@",self.startTime);

    // animation
    CAKeyframeAnimation *addOneSecond = [CAKeyframeAnimation animationWithKeyPath:@"addOneSecond"];
    addOneSecond.keyPath = @"position";
    addOneSecond.path = [UIBezierPath bezierPathWithArcCenter:self.clockView.center radius:(self.clockView.frame.size.width-_pointerViewR)/2 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES].CGPath;
    addOneSecond.duration = 60.f;
    addOneSecond.repeatCount = self.timeLength/60;
    addOneSecond.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    //addOneSecond.fillMode = kCAFillModeForwards;
    addOneSecond.delegate = self;
    //addOneSecond.autoreverses = YES;
    [self.pointerView.layer addAnimation:addOneSecond forKey:nil];
    
    // NSTimer
    self.countDownTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(countingTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)pauseTicking {
    NSLog(@"pauseTicking");
    self.clockStatus = XZXClockStatusPause;
    [self pauseLayer:self.pointerView.layer];
    
    [self.countDownTimer invalidate];
    self.countDownTimer = nil;
}

- (void)resumeticking {
    NSLog(@"resumeTicking");
    self.clockStatus = XZXClockStatusTicking;
    [self resumeLayer:self.pointerView.layer];
    
    self.countDownTimer = [NSTimer timerWithTimeInterval:0.5 target:self selector:@selector(countingTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)stopTicking {
    //self.clockStatus =
}

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"start");
    
    
    _pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
    
    __weak __typeof__(self) weakSelf = self;
    [UIView animateWithDuration:self.setTimeLength delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        __strong __typeof__(weakSelf) strongSelf = weakSelf;
        strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV4);
    } completion:NULL];
    
    // deprecated 实现复杂且不好看
    // 四个时间段 四种不同的指针渐变色
//    switch (self.level) {
//        case 1: {
//            [UIView animateWithDuration:8.f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
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
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"stop");
    self.endTime = [XZXDateUtil dateByAddingSeconds:_setTimeLength - _timeLength toDate:_startTime];
    self.clockStatus = XZXClockStatusStop;
    NSLog(@"self.stop:%@", self.endTime);
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
