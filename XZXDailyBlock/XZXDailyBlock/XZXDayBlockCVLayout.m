//
//  XZXDayBlockCVLayout.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/28.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayBlockCVLayout.h"

static CGFloat itemSpacing = 10;
static CGFloat lineSpacing = 10;
static NSInteger pageNumber = 1;

typedef NSInteger(^pageCalculateBlock)(NSInteger itemNumber);

@interface XZXDayBlockCVLayout ()
@property (nonatomic, assign) NSInteger pageCount;
@property (nonatomic, strong) NSMutableArray *leftArray;
@property (nonatomic, strong) NSMutableDictionary *heightDict;
@property (nonatomic, strong) NSMutableArray *attributes;
@property (nonatomic, strong) NSMutableArray *indexPathsToAnimate;
@property (nonatomic, copy) pageCalculateBlock calculatePage;
@end

@implementation XZXDayBlockCVLayout {
    int _row;
    int _column;
}

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
    
    CGFloat itemWidth = self.itemSize.width;
    CGFloat itemHeight = self.itemSize.height;
    
    CGFloat width = self.collectionView.frame.size.width;
    CGFloat height = self.collectionView.frame.size.height;
    
    CGFloat contentWidth = width - self.sectionInset.left - self.sectionInset.right;
    
    if (contentWidth >= (2*itemWidth + self.minimumInteritemSpacing)) { //如果列数大于2行
        int m = (contentWidth-itemWidth)/(itemWidth+self.minimumInteritemSpacing);
        _column = m+1;
        int n = (int)(contentWidth - itemWidth)%(int)(itemWidth + self.minimumInteritemSpacing);
        if (n > 0) {
            double offset = ((contentWidth - itemWidth) - m*(itemWidth + self.minimumInteritemSpacing)) / m;
            itemSpacing = self.minimumInteritemSpacing + offset;
        } else if (n == 0){
            itemSpacing = self.minimumInteritemSpacing;
        }
    } else { //如果列数为一行
        _column = 1;
    }
    
    CGFloat contentHeight = (height - self.sectionInset.top - self.sectionInset.bottom);
    if (contentHeight >= (2*itemHeight + self.minimunLineSpacing)) { //如果行数大于2行
        int m = (contentHeight - itemHeight) / (itemHeight + self.minimunLineSpacing);
        _row = m+1;
        int n = (int)(contentHeight - itemHeight) % (int)(itemHeight + self.minimunLineSpacing);
        if (n > 0) {
            double offset = ((contentHeight - itemHeight) - m*(itemHeight + self.minimunLineSpacing)) / m;
            lineSpacing = self.minimunLineSpacing + offset;
        } else if (n == 0){
            lineSpacing = self.minimumInteritemSpacing;
        }
    } else { //如果行数数为一行
        _row = 1;
    }
    
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
    long number = _row * _column;
    //    printf("%ld\n",number);
    long m = 0;  //初始化 m p
    long p = 0;
    if (indexPath.item >= number) {
        //        NSLog(@"indexpath.item:%ld",indexPath.item);
        p = indexPath.item/number;  //计算页数不同时的左间距
        //        if ((p+1) > pageNumber) { //计算显示的页数
        //            pageNumber = p+1;
        //
        //        }
        //        NSLog(@"%ld",p);
        m = (indexPath.item%number)/_column;
    }else{
        m = indexPath.item/_column;
    }
    
    long n = indexPath.item%_column;
    frame.origin = CGPointMake(n*self.itemSize.width+(n)*itemSpacing+self.sectionInset.left+(indexPath.section+p)*self.collectionView.frame.size.width,m*self.itemSize.height + (m)*lineSpacing+self.sectionInset.top);
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

//自动对齐到网格
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity {
    //proposedContentOffset是没有对齐到网格时本来应该停下的位置
    CGFloat offsetY = MAXFLOAT;
    CGFloat offsetX = MAXFLOAT;
    CGFloat horizontalCenter = proposedContentOffset.x + self.itemSize.width/2;
    CGFloat verticalCenter = proposedContentOffset.y + self.itemSize.height/2;
    CGRect targetRect = CGRectMake(0, 0.0, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height);
    NSArray* array = [super layoutAttributesForElementsInRect:targetRect];
    
    //对当前屏幕中的UICollectionViewLayoutAttributes逐个与屏幕中心进行比较，找出最接近中心的一个
    CGPoint offPoint = proposedContentOffset;
    for (UICollectionViewLayoutAttributes* layoutAttributes in array) {
        CGFloat itemHorizontalCenter = layoutAttributes.center.x;
        CGFloat itemVerticalCenter = layoutAttributes.center.y;
        if (ABS(itemHorizontalCenter - horizontalCenter) && (ABS(offsetX)>ABS(itemHorizontalCenter - horizontalCenter))) {
            offsetX = itemHorizontalCenter - horizontalCenter;
            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
        }
        if (ABS(itemVerticalCenter - verticalCenter) && (ABS(offsetY)>ABS(itemVerticalCenter - verticalCenter))) {
            offsetY = itemHorizontalCenter - horizontalCenter;
            offPoint = CGPointMake(itemHorizontalCenter, itemVerticalCenter);
        }
    }
    return offPoint;
}

- (BOOL)ShouldinvalidateLayoutForBoundsChange:(CGRect)newBounds{
    return YES;
}

@end
