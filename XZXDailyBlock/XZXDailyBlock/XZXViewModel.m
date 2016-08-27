//
//  XZXViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXViewModel.h"

@interface XZXViewModel ()

@property (nonatomic, strong, readwrite) id<XZXViewModelServices> services;

@property (nonatomic, strong, readwrite) RACSubject *errors;
@property (nonatomic, strong, readwrite) RACSubject *willDisappearSignal;

@end

@implementation XZXViewModel

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    XZXViewModel *viewModel = [super allocWithZone:zone];
    
    @weakify(viewModel)
    [[viewModel rac_signalForSelector:@selector(initWithServices:)]
     subscribeNext:^(id x) {
         @strongify(viewModel)
         [viewModel xzx_initialize];
     }];
    
    return viewModel;
}

- (instancetype)initWithServices:(id<XZXViewModelServices>)services {
    if (self = [super init]) {
        self.shouldFetchLocalDataOnViewModelInitialize = YES;
        self.shouldRequestRemoteDataOnViewDidLoad = YES;
        self.services = services;
    }
    return self;
}

- (RACSubject *)errors {
    if (!_errors) _errors = [RACSubject subject];
    return _errors;
}

- (RACSubject *)willDisappearSignal {
    if (!_willDisappearSignal) _willDisappearSignal = [RACSubject subject];
    return _willDisappearSignal;
}

- (void)xzx_initialize {}

@end
