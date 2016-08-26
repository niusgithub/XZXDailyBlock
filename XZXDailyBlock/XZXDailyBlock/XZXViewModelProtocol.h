//
//  XZXViewModelProtocol.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XZXViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

- (void)xzx_initialize;

@end
