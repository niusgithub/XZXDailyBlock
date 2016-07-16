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
#import "XZXDayBlockCVCellViewModel.h"

#import "XZXDayEventVC.h"
#import "XZXClock.h"

#import "XZXTransitionAnimator.h"
#import "XZXCalendarVMServicesImpl.h"
#import "XZXCalendarUtil.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <DKNightVersion/DKNightVersion.h>

NSString *const kCalendarDateBlockCellIdentifier = @"cdateblockCVCell";

@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) XZXCalendarVMServicesImpl *viewModelServices;

@property (nonatomic, strong) XZXCalendarViewModel *viewModel;

@property (nonatomic, strong) XZXDayBlockCV *dayBlockCV;
@property (nonatomic, strong) UIButton *startEventBtn;

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, assign) CGFloat collectionViewSplitY;

@property (nonatomic, strong) XZXCalendarUtil *calendarUtil;

@property (nonatomic, strong) XZXDayBlockCVLayout *monthLayout;

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
//        self.navigationController.navigationBar.translucent = YES;
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"TransparentPixel"] forBarMetrics:UIBarMetricsDefault];
//        [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];

    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];;
    
    
    //
    self.navigationController.delegate = self;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"日历" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    //
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    CGFloat screenHeigth = [[UIScreen mainScreen] bounds].size.height;
    self.sideLength = (screenWidth - 80) / 7;
    
    CGFloat collectionViewHeight = 8 + (_sideLength + 10) * 6;
    
    // collectionView
    XZXDayBlockCVLayout *layout = [[XZXDayBlockCVLayout alloc] init];
    layout.itemSize = CGSizeMake(_sideLength, _sideLength);
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    layout.minimunLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.monthLayout = layout;
    
    XZXDayBlockCV *dayBlockCV = [[XZXDayBlockCV alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, collectionViewHeight) collectionViewLayout:self.monthLayout];
    dayBlockCV.backgroundColor = [UIColor clearColor];
    dayBlockCV.showsVerticalScrollIndicator = NO;
    dayBlockCV.showsHorizontalScrollIndicator = NO;
    dayBlockCV.pagingEnabled = YES;
    dayBlockCV.delegate = self;
    dayBlockCV.dataSource = self;
    [self.view addSubview:dayBlockCV];
    self.dayBlockCV = dayBlockCV;
    
    //y:screenHeigth-64-44-20
    UIButton *startEventBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, screenHeigth-128, screenWidth - 20, 44)];
    [startEventBtn setImage:[UIImage imageNamed:@"clock"] forState:UIControlStateNormal];
    [startEventBtn setTitle:@"开始" forState:UIControlStateNormal];
    [startEventBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    startEventBtn.backgroundColor = [UIColor whiteColor];
    startEventBtn.layer.borderWidth = 1.f;
    startEventBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [startEventBtn addTarget:self action:@selector(startTickTock) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:startEventBtn];
    self.startEventBtn = startEventBtn;
    
    
    [self initViewModel];
    
    [self bindViewModel];
    
    
    self.calendarUtil = [[XZXCalendarUtil alloc] init];
    
    
    // DKNightVersion
    [DKColorTable sharedColorTable].file = @"XZXColor.txt";
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.dk_manager.themeVersion = @"SEA";
}

- (void)bindViewModel {
    self.title = self.viewModel.title;
    
    [self.dayBlockCV registerClass:[XZXDayBlockCVCell class] forCellWithReuseIdentifier:kCalendarDateBlockCellIdentifier];
    
    // React collectionView:didSelectItemAtIndexPath:
    @weakify(self)
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)]
     subscribeNext:^(RACTuple *value) {
         @strongify(self)
         
         self.collectionViewSplitY = ([(NSIndexPath *)value.second item] % 42 / 7 + 1) * (self.sideLength + 10) + 5;
         //NSLog(@"Y : %f", self.collectionViewSplitY);
         
         //UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         //XZXDayEventVC *vc = [sb instantiateViewControllerWithIdentifier:@"XZXDEViewController"];
         XZXDayEventVC *dayEventVC = [[XZXDayEventVC alloc] init];
         dayEventVC.selectedItemIndex = [(NSIndexPath *)value.second item];
         dayEventVC.height =  15 + self.sideLength;
         
         dayEventVC.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.navigationController pushViewController:dayEventVC animated:YES];
     }];
    self.dayBlockCV.delegate = nil;
    self.dayBlockCV.delegate = self;
    
    // 5个月份中间的月份calendar为当前月 起始item为84 item87在正中间
    [self.dayBlockCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:87 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    // return 42 * [_dateHelper totalMonths];
    // 暂定显示前后2个月加上本月共5个月 42*5
    return 210;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XZXDayBlockCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCalendarDateBlockCellIdentifier forIndexPath:indexPath];
    
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
        return [[XZXTransitionAnimator alloc] initWithDuration:0.3 splitLineY:_collectionViewSplitY barHeight:15 + self.sideLength];
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
    [self.dayBlockCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:87 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

- (IBAction)startTickTock {
    XZXClock *clock = [[XZXClock alloc] init];
    [self presentViewController:clock animated:YES completion:nil];
}

@end
