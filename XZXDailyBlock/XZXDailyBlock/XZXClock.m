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
@property (nonatomic, assign) NSInteger timeLength; // 以秒为单位
@property (nonatomic, strong) NSTimer *countDownTimer;
@property (nonatomic, assign) NSInteger level;

@property (nonatomic, strong) CAKeyframeAnimation *addOneSecond;
//@property (nonatomic, assign) CGRect clockViewOriginFrame;
@property (nonatomic, assign) BOOL animating;

@end

@implementation XZXClock

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    // 完成设置后在UserDefault取出
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
//    self.sideLength = (width - 80) / 7;
    
    
    
    // back button
    UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 20, 40, 40)];
//    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    [backBtn setTitle:@"X" forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backButtonclick) forControlEvents:UIControlEventTouchUpInside];
    backBtn.backgroundColor = [UIColor orangeColor];
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
    

//    
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
    
    self.level = 1;
    
    UIView *pointerView = [[UIView alloc] initWithFrame:CGRectMake(centerX-10, centerY-clockViewR, _pointerViewR, _pointerViewR)];
    pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
    pointerView.layer.cornerRadius = 10.f;
    pointerView.layer.borderWidth = 2.f;
    pointerView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self.view insertSubview:pointerView aboveSubview:self.clockView];
    self.pointerView = pointerView;
    
    [self bindViewModel];
    
    UILabel *clockLabel = [[UILabel alloc] initWithFrame:CGRectMake(centerX-clockViewR, centerY-clockViewR, clockViewD, clockViewD)];
    clockLabel.text = [NSString stringWithFormat:@"%@:00", [self textOfTime:self.timeLength/60]];
    clockLabel.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:40];
    clockLabel.textAlignment = NSTextAlignmentCenter;
    [self.view insertSubview:clockLabel aboveSubview:clockView];
    self.clockLabel = clockLabel;
}

- (void)bindViewModel {
#warning 每次都需要设置timeLength
    self.timeLength = 2 * 60;
}

- (void)backButtonclick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startTicking {
    NSLog(@"startTicking");
    
    
    self.startTime = [XZXDateUtil localDateOfDate:[NSDate date]];
    NSLog(@"startTime:%@",self.startTime);
    
//    self.clockViewOriginFrame = self.clockView.frame;
//    
//    if (self.animating) {
//        // 暂停 暂未实现
//        return;
//    }
    
    // animation
    CAKeyframeAnimation *addOneSecond = [CAKeyframeAnimation animationWithKeyPath:@"addOneSecond"];
    addOneSecond.keyPath = @"position";
    addOneSecond.path = [UIBezierPath bezierPathWithArcCenter:self.clockView.center radius:(self.clockView.frame.size.width-_pointerViewR)/2 startAngle:-M_PI_2 endAngle:M_PI_2*3 clockwise:YES].CGPath;
    addOneSecond.duration = 60.f;
    addOneSecond.repeatCount = self.timeLength/60;
    
    addOneSecond.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    addOneSecond.delegate = self;
    
    
    //addOneSecond.autoreverses = YES;
    [self.pointerView.layer addAnimation:addOneSecond forKey:nil];
    
    
    // NSTimer
    self.countDownTimer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(countingTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.countDownTimer forMode:NSRunLoopCommonModes];
}

- (void)animationDidStart:(CAAnimation *)anim {
    NSLog(@"start");
    // 四个时间段 四种不同的指针渐变色
    _pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
    __weak __typeof__(self) weakSelf = self;
    switch (self.level) {
        case 1: {
            [UIView animateWithDuration:8.f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV1);
            } completion:NULL];
        }
            break;
        case 2: {
            [UIView animateWithDuration:8.f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV2);
            } completion:NULL];
        }
            break;
        case 3: {
            [UIView animateWithDuration:8.f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV3);
            } completion:NULL];
        }
            break;
        case 4: {
            [UIView animateWithDuration:8.f delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
                __strong __typeof__(weakSelf) strongSelf = weakSelf;
                strongSelf.pointerView.dk_backgroundColorPicker = DKColorPickerWithKey(LV4);
            } completion:NULL];
        }
            break;
    }
    
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    NSLog(@"stop");
    NSLog(@"startTime:%@",self.endTime);
}


#pragma mark - Time
- (void)countingTime {
    self.timeLength--;
    self.clockLabel.text = [NSString stringWithFormat:@"%@:%@", [self textOfTime:self.timeLength/60], [self textOfTime:self.timeLength%60]];
    NSLog(@"time--%@",[NSString stringWithFormat:@"%@:%@", [self textOfTime:self.timeLength/60], [self textOfTime:self.timeLength%60]]);
    if (self.timeLength == 0) {
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
