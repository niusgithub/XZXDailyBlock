//
//  XZXDayBlockCVCell.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayBlockCVCell.h"


#import <DKNightVersion/DKNightVersion.h>

@interface XZXDayBlockCVCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation XZXDayBlockCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *dateTitle = [[UILabel alloc] initWithFrame:frame];
        dateTitle.textAlignment = NSTextAlignmentCenter;
        dateTitle.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:dateTitle];
        self.titleLabel = dateTitle;
    }
    
    return self;
}

- (void)configureCellWithViewModel:(XZXDayBlockCVCellViewModel *)viewModel {
    //开发用日期显示
    self.titleLabel.text = viewModel.dataTitle;
    
    switch (viewModel.level) {
        case 0:
            self.backgroundColor = [UIColor whiteColor];
            break;
        case 1:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV1);
            break;
        case 2:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV2);
            break;
        case 3:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV3);
            break;
        case 4:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV4);
            break;
    }
    
    if (viewModel.isToday) {
        self.layer.borderColor = [[UIColor blackColor] CGColor];
        self.layer.borderWidth = 1.0f;
    }
}

- (void)layoutSubviews {
    self.titleLabel.frame = self.bounds;
}

@end
