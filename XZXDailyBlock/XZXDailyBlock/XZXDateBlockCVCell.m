//
//  XZXDateBlockCVCell.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDateBlockCVCell.h"


@interface XZXDateBlockCVCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@end


@implementation XZXDateBlockCVCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UILabel *dateTitle = [[UILabel alloc] initWithFrame:frame];
        dateTitle.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:dateTitle];
        self.titleLabel = dateTitle;
    }
    
    return self;
}

- (void)configureCellWithViewModel:(XZXDateBlockCVCellViewModel *)viewModel atIndexPath:(NSIndexPath*)indexPath {
    self.titleLabel.text = viewModel.dataTitle;
    //self.titleLabel.text = [NSString stringWithFormat:@"%ld" ,indexPath.item];
}

- (void)layoutSubviews {
    self.titleLabel.frame = self.bounds;
}

@end
