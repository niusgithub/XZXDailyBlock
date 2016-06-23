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
//@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation XZXDayBlockCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        UILabel *dateTitle = [[UILabel alloc] initWithFrame:frame];
//        dateTitle.textAlignment = NSTextAlignmentCenter;
//        [self.contentView addSubview:dateTitle];
//        self.titleLabel = dateTitle;
    }
    
    return self;
}

- (void)configureCellWithViewModel:(XZXDayBlockCVCellViewModel *)viewModel {
    //self.titleLabel.text = viewModel.dataTitle;
    
    switch (viewModel.level) {
        case 0:
            //self.bgColor = [UIColor redColor];
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV1);
            break;
        case 1:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV2);
            break;
        case 2:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV3);
            break;
        case 3:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV4);
            break;
    }
    
    //self.backgroundColor = viewModel.bgColor;
}

- (void)layoutSubviews {
    //self.titleLabel.frame = self.bounds;
}

@end
