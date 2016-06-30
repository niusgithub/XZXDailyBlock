//
//  XZXDayBlockCVLayout.h
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/28.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZXDayBlockCVLayout : UICollectionViewLayout

// item行间距
@property (nonatomic, assign) CGFloat minimunLineSpacing;
// item 左右间距
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, assign) UIEdgeInsets sectionInset;

@end
