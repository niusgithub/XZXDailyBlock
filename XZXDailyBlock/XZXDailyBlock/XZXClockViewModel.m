//
//  XZXClockViewModel.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/7.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXClockViewModel.h"

@interface XZXClockViewModel ()
@property (nonatomic, strong) RACCommand *finishCommand;
@end

@implementation XZXClockViewModel

- (instancetype)init {
    if (self = [super init]) {
        //self.finishCommand = [RACCommand alloc] initWithEnabled:<#(RACSignal *)#> signalBlock:<#^RACSignal *(id input)signalBlock#>
    }
    
    return self;
}

@end
