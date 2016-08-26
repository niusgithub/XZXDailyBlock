//
//  XZXViewControllerProtocol.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol XZXViewModelProtocol;

@protocol XZXViewControllerProtocol <NSObject>

@optional
- (instancetype)initWithViewModel:(id<XZXViewModelProtocol>)viewModel;

- (void)xzx_bindViewModel;
- (void)xzx_addSubViews;
- (void)xzx_layoutNavgation;
- (void)xzx_refreshData;

@end
