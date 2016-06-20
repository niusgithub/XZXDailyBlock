//
//  XZXDayEventTVCell.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/20.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZXDayEventTVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (weak, nonatomic) IBOutlet UIView *levelView;
@property (weak, nonatomic) IBOutlet UILabel *eventLabel;

@end
