//
//  XZXCalendarVMServices.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/22.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "XZXViewModelServices.h"
#import "XZXFetchDays.h"

@protocol XZXCalendarVMServices <NSObject, XZXViewModelServices>

- (id<XZXFetchDays>)getServices;

@end
