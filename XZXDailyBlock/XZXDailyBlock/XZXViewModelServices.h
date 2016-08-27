//
//  XZXViewModelServices.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/27.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZXFetchDays.h"
#import "XZXUpdateDays.h"

@protocol XZXViewModelServices <NSObject>

@property (nonatomic, strong, readonly) id<XZXFetchDays> fetchDaysService;
@property (nonatomic, strong, readonly) id<XZXUpdateDays> updateDaysService;

@end
