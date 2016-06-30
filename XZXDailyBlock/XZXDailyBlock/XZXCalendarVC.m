//
//  XZXCalendarVC.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarVC.h"
#import "XZXDayBlockCV.h"
#import "XZXDayBlockCVCell.h"
#import "XZXDayBlockCVLayout.h"
#import "XZXDayEventVC.h"
#import "XZXTransitionAnimator.h"

#import "XZXDayBlockCVCellViewModel.h"
#import "XZXCalendarUtil.h"

#import "XZXCalendarVMServicesImpl.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <DKNightVersion/DKNightVersion.h>

NSString *const kDateBlockCellIdentifier = @"dateblockCVCell";

@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) XZXCalendarVMServicesImpl *viewModelServices;

@property (nonatomic, strong) XZXCalendarViewModel *viewModel;

@property (nonatomic, strong) XZXDayBlockCV *dateBlockCV;

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, assign) CGFloat collectionViewSplitY;

@property (nonatomic, strong) XZXCalendarUtil *calendarUtil;

#warning temp
@property (nonatomic, assign) NSInteger clickTimes;
@end

@implementation XZXCalendarVC

#pragma mark - initialize

- (void)initViewModel {
    self.viewModelServices = [XZXCalendarVMServicesImpl new];
    self.viewModel = [[XZXCalendarViewModel alloc] initWithServices:_viewModelServices];
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 透明navigationBar
    //    self.navigationController.navigationBar.translucent = YES;
    //    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    
    //
    self.navigationController.delegate = self;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"日历" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    //
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.sideLength = (width - 80) / 7;
    
    CGFloat collectionViewHeight = 8 + (_sideLength + 10) * 6;
    
    // collectionView
    XZXDayBlockCVLayout *layout = [[XZXDayBlockCVLayout alloc] init];
    layout.itemSize = CGSizeMake(_sideLength, _sideLength);
    layout.sectionInset = UIEdgeInsetsMake(10, 8, 8, 10);
    layout.minimunLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    
    XZXDayBlockCV *dayBlockCV = [[XZXDayBlockCV alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, collectionViewHeight) collectionViewLayout:layout];
    dayBlockCV.backgroundColor = [UIColor clearColor];
    dayBlockCV.showsVerticalScrollIndicator = NO;
    dayBlockCV.showsHorizontalScrollIndicator = NO;
    dayBlockCV.pagingEnabled = YES;
    dayBlockCV.delegate = self;
    dayBlockCV.dataSource = self;
    [self.view addSubview:dayBlockCV];
    self.dateBlockCV = dayBlockCV;
    
    
    [self initViewModel];
    
    [self bindViewModel];
    
    
    self.calendarUtil = [[XZXCalendarUtil alloc] init];
    
    
    // DKNightVersion
    [DKColorTable sharedColorTable].file = @"XZXColor.txt";
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.dk_manager.themeVersion = @"SEA";
    
    NSLog(@"constant:%f",15 + self.sideLength);
}

- (void)bindViewModel {
    self.title = self.viewModel.title;
    
    [self.dateBlockCV registerClass:[XZXDayBlockCVCell class] forCellWithReuseIdentifier:kDateBlockCellIdentifier];
    
    // React collectionView:didSelectItemAtIndexPath:
    @weakify(self)
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)]
     subscribeNext:^(RACTuple *value) {
         @strongify(self)
         
         self.collectionViewSplitY = ([(NSIndexPath *)value.second item] % 42 / 7 + 1) * (self.sideLength + 10) + 5;
//         NSLog(@"x : %f", self.collectionViewSplitY);
         
         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         XZXDayEventVC *vc = [sb instantiateViewControllerWithIdentifier:@"XZXDEViewController"];
         vc.weekCV.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 15 + self.sideLength);
         
         vc.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.navigationController pushViewController:vc animated:YES];
     }];
    self.dateBlockCV.delegate = nil;
    self.dateBlockCV.delegate = self;
    
    // 5个月份中间的月份calendar为当前月 起始item为84 item87在正中间
    [self.dateBlockCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:87 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDateSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // return 42 * [_dateHelper totalMonths];
    // 暂定显示前后2个月加上本月共5个月 42*5
    return 210;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XZXDayBlockCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDateBlockCellIdentifier forIndexPath:indexPath];
    
    XZXDayBlockCVCellViewModel *cellViewModel = self.viewModel.cellViewModels[indexPath.item];
    
    [cell configureCellWithViewModel:cellViewModel];
    
    return cell;
}


//#pragma mark - 
//
//- (void)reloadDateForCell:(XZXDayBlockCVCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    
//}


//#pragma mark - UICollectionView Delegate FlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return CGSizeMake(_sideLength, _sideLength);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}


//#pragma mark - UIScrollView Delegate
//
//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll");
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewWillBeginDragging");
//}
//
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidEndDecelerating");
//}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [XZXTransitionAnimator new];
}


#pragma mark - UIViewControllerAnimatedTransitioning

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController animationControllerForOperation:(UINavigationControllerOperation)operation fromViewController:(UIViewController *)fromVC toViewController:(UIViewController *)toVC {
    if (UINavigationControllerOperationPush == operation) {
        return [[XZXTransitionAnimator alloc] initWithDuration:0.5 splitLineY:_collectionViewSplitY];
    }
    
    if (UINavigationControllerOperationPop == operation) {
        return nil;
    }
    return nil;
}

#warning temp
- (IBAction)leftBarButtonItemClick:(UIBarButtonItem *)sender {
    self.clickTimes++;
    switch (_clickTimes % 4) {
        case 1:
            self.dk_manager.themeVersion = @"SUCCULENT";
            break;
        case 2:
            self.dk_manager.themeVersion = @"VIOLET";
            break;
        case 3:
            self.dk_manager.themeVersion = @"GITHUB";
            break;
        case 0:
            self.dk_manager.themeVersion = @"SEA";
            break;
    }
}

- (IBAction)jumpToToday:(UIBarButtonItem *)sender {
    // 暂定方法实现
    [self.dateBlockCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:87 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}


@end
