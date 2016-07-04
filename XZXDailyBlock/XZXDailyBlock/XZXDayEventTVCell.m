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

/*
 //开发用日期显示
 self.titleLabel.text = viewModel.dateTitle;
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
 */

- (void)configureCellWithViewModel:(XZXDayEventTVCellViewModel *)viewModel {
//    @property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
//    @property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
//    @property (weak, nonatomic) IBOutlet UIView *levelView;
//    @property (weak, nonatomic) IBOutlet UILabel *eventLabel;
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
    
    self.eventLabel.text = viewModel.eventAbstruct;
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
