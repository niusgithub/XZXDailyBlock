//
//  XZXTableViewCellProtocol.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XZXTableViewCellProtocol <NSObject>

@optional

- (void)xzx_configureViews;
- (void)xzx_bindViewModel;

@end
