//
//  XZXDayEventTVCell.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEventTVCell.h"
#import "XZXDateUtil.h"
#import <DKNightVersion/DKNightVersion.h>

@implementation XZXDayEventTVCell

- (void)configureCellWithViewModel:(XZXDayEventTVCellViewModel *)viewModel {
    self.startTimeLabel.text = viewModel.startTime;
    self.endTimeLabel.text = viewModel.endTime;
    
    switch (viewModel.level) {
        case 0:
            self.levelView.dk_backgroundColorPicker = DKColorPickerWithKey(LV0);
            break;
        case 1:
            self.levelView.dk_backgroundColorPicker = DKColorPickerWithKey(LV1);
            break;
        case 2:
            self.levelView.dk_backgroundColorPicker = DKColorPickerWithKey(LV2);
            break;
        case 3:
            self.levelView.dk_backgroundColorPicker = DKColorPickerWithKey(LV3);
            break;
        case 4:
            self.levelView.dk_backgroundColorPicker = DKColorPickerWithKey(LV4);
            break;
    }
    self.levelView.layer.borderWidth = 1.f;
    self.levelView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
    self.eventLabel.text = viewModel.eventAbstruct;
    self.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
