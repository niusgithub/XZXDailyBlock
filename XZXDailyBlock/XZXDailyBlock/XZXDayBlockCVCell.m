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
        //dateTitle.font = [UIFont fontWithName:@"HelveticaNeue-UltraLight" size:20];
        [self.contentView addSubview:dateTitle];
        self.titleLabel = dateTitle;
    }
    
    return self;
}

- (void)configureCellWithViewModel:(XZXDayBlockCVCellViewModel *)viewModel {
    //开发用日期显示
    self.titleLabel.text = viewModel.dayNumber;
    self.titleLabel.textColor = [UIColor lightGrayColor];
    
    switch (viewModel.level) {
        case 0:
            self.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
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
        self.titleLabel.textColor = [UIColor blackColor];
    }
}

- (void)layoutSubviews {
    // 取消UICollectionView的隐式动画，然而和月历跳转周历时的布局抖动无关
//    [CATransaction begin];
//    [CATransaction setDisableActions:YES];
//    
//    self.titleLabel.frame = self.bounds;
//    
//    [CATransaction commit];
    
    self.titleLabel.frame = self.bounds;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    self.layer.borderWidth = 0;
}

@end
