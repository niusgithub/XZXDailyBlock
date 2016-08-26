//
//  XZXView.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXView.h"

@implementation XZXView

- (instancetype)init {
    if (self = [super init]) {
        [self xzx_configureViews];
        [self xzx_bindViewModel];
    }
    return self;
}

- (instancetype)initWithViewModel:(id<XZXViewModelProtocol>)viewModel {
    if (self = [super init]) {
        [self xzx_configureViews];
        [self xzx_bindViewModel];
    }
    return self;
}

- (void)xzx_configureViews {}

- (void)xzx_bindViewModel {}

@end
