//
//  XZXDayBlockCVCell.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZXDayBlockCVCellViewModel.h"

@interface XZXDayBlockCVCell : UICollectionViewCell

- (void)configureCellWithViewModel:(XZXDayBlockCVCellViewModel *)viewModel atIndexPath:(NSIndexPath *)indexPath;

@end
