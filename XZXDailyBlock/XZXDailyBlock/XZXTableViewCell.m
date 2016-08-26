//
//  XZXTableViewCell.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/26.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXTableViewCell.h"

@implementation XZXTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self xzx_configureViews];
        [self xzx_bindViewModel];
    }
    return self;
}

- (void)xzx_configureViews {}
- (void)xzx_bindViewModel {}

@end
