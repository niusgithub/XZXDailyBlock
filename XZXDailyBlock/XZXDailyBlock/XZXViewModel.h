//
//  XZXViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZXViewModelServices.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XZXViewModel : NSObject 

@property (nonatomic, strong, readonly) id<XZXViewModelServices> services;
@property (nonatomic, copy) NSString *title;

@property (nonatomic, assign) BOOL shouldFetchLocalDataOnViewModelInitialize;
@property (nonatomic, assign) BOOL shouldRequestRemoteDataOnViewDidLoad;

@property (nonatomic, strong, readonly) RACSubject *willDisappearSignal;
// A RACSubject object, which representing all errors occurred in view model.
@property (nonatomic, strong, readonly) RACSubject *errors;

- (instancetype)initWithServices:(id<XZXViewModelServices>)services;

- (void)xzx_initialize;

@end
