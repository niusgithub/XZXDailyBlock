//
//  XZXViewController.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXViewController.h"

@interface XZXViewController ()

@end

@implementation XZXViewController

- (instancetype)init {
    self = [super init];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self xzx_addSubViews];
    [self xzx_bindViewModel];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self xzx_layoutNavgation];
    [self xzx_refreshData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - RAC

- (void)xzx_addSubViews {}

- (void)xzx_bindViewModel {}

- (void)xzx_layoutNavgation {}

- (void)xzx_refreshData {}

@end
