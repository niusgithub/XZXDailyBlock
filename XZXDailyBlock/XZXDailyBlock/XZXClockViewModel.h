//
//  XZXClockViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/7.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface XZXClockViewModel : NSObject

@property (nonatomic, readonly) RACCommand *finishCommand;

@end
