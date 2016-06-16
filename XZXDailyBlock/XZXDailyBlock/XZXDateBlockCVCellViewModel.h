//
//  XZXDateBlockCVCellViewModel.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/16.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface XZXDateBlockCVCellViewModel : NSObject

@property (nonatomic, strong) NSString *dataTitle;

- (instancetype)initWithDate:(NSDate *)date;

@end
