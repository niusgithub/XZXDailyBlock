//
//  XZXWeekCVLayout.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/7/5.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXWeekCVLayout.h"

static CGFloat itemSpacing = 10;
static CGFloat lineSpacing = 10;
static NSInteger pageNumber = 1;

typedef NSInteger(^pageCalculateBlock)(NSInteger itemNumber);

@interface XZXWeekCVLayout ()
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableDictionary *heightDict;
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;
@property (nonatomic, copy) pageCalculateBlock calculatePage;
@property (nonatomic, assign) NSInteger row;
@property (nonatomic, assign) NSInteger column;
@end

@implementation XZXWeekCVLayout

- (instancetype)init {
    if (self = [super init]) {
        self.leftArray = [NSMutableArray new];
        self.heightDict = [NSMutableDictionary new];
        self.attributes = [NSMutableArray new];
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.column = 7;
    self.row = 1;

    NSInteger itemNumber = [self.collectionView numberOfItemsInSection:0];
    
    pageNumber = (itemNumber - 1)/(_row*_column) + 1;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(self.collectionView.bounds.size.width*pageNumber, self.collectionView.bounds.size.height);
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    
    CGRect frame;
    frame.size = self.itemSize;
    //下面计算每个cell的frame   可以自己定义
    long number = _row * _column;  // 7
    long page = 0;  //初始化 m p
    long leftOffset = 0;
    if (indexPath.item >= number) {
        leftOffset = indexPath.item/number;  // 计算页数不同时的左间距
        page = (indexPath.item%number)/_column;
    } else {
        page = indexPath.item/_column;
    }
    
    long indexOfPage = indexPath.item%_column;
    
    NSInteger x = indexOfPage*(self.itemSize.width+ itemSpacing) + self.sectionInset.left + (indexPath.section+leftOffset)*self.collectionView.frame.size.width;
    NSInteger y = page*self.itemSize.height + (page)*lineSpacing+self.sectionInset.top;
    
    frame.origin = CGPointMake(x, y);
    
    attribute.frame = frame;
    
    return attribute;
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    
    NSMutableArray *tmpAttributes = [NSMutableArray new];
    for (int j = 0; j < self.collectionView.numberOfSections; j ++) {
        NSInteger count = [self.collectionView numberOfItemsInSection:j];
        for (NSInteger i = 0; i < count; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:j];
            [tmpAttributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
        }
    }
    self.attributes = tmpAttributes;
    
    return self.attributes;
}

- (BOOL)ShouldinvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
