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

#import <DKNightVersion/DKNightVersion.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XZXClock ()
//@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, strong) XZXClockViewModel *viewModel;
//@property (nonatomic, weak) XZXDayEvent *currentEvent;
//@property (nonatomic, strong) NSArray<XZXDayEvent *> *todayEvents;

@property (nonatomic, strong) UIButton *backBtn;

@property (nonatomic, strong) UIView *eventsView;
@property (nonatomic, strong) UIView *clockView;
@property (nonatomic, strong) UILabel *eventTitle;

@property (nonatomic, assign) CGRect clockViewOriginFrame;
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
    clockView.layer.borderWidth = 5.f;
    clockView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    clockView.clipsToBounds = YES;
    [self.view addSubview:clockView];
    self.clockView = clockView;
}

- (void)backButtonclick {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)startTicking {
    NSLog(@"startTicking");
    
    self.clockViewOriginFrame = self.clockView.frame;
    
    if (self.animating) {
        // 暂停 暂未实现
        return;
    }
}
@end
