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
#import "XZXDayEventVC.h"
#import "XZXDateHelper.h"
#import "XZXTransitionAnimator.h"

#import "XZXDayBlockCVCellViewModel.h"
#import "XZXDateHelper.h"

#import "XZXCalendarVMServicesImpl.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

#import <DKNightVersion/DKNightVersion.h>

#define MaxSections 100

NSString *const kDateBlockCellIdentifier = @"dateblockCVCell";
//NSString *const kDateBlockCellNibName = @"XZXDateBlockCVCell";


@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) XZXCalendarVMServicesImpl *viewModelServices;

@property (nonatomic, strong) XZXCalendarViewModel *viewModel;

@property (weak, nonatomic) IBOutlet XZXDayBlockCV *dateBlockCV;

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, assign) CGFloat collectionViewSplitY;

@property (nonatomic, strong) XZXDateHelper *dateHelper;

#warning temp
@property (nonatomic, assign) NSInteger clickTimes;
@end

@implementation XZXCalendarVC

#pragma mark - initialize

- (void)initViewModel {
#warning temp
    // self.dateHelper = [XZXDateHelper sharedDateHelper];
    // self.viewModel = [[XZXCalendarViewModel alloc] initWithDateHelper:_dateHelper];
    
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
    
    //
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.sideLength = (width - 80) / 7;
    
    
    
    
    
    [self initViewModel];
    
    [self bindViewModel];
    
    
    
    
    self.dateHelper = [[XZXDateHelper alloc] init];
    
    
    
    [DKColorTable sharedColorTable].file = @"XZXColor.txt";
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
    self.dk_manager.themeVersion = @"SEA";
    
    
    
    //2016.6.15
////    NSCalendar *calendar = [[XZXDateHelper sharedDateHelper] calendar];
//    
//    #if DEBUG
//    NSAssert(calendar != nil, @"calendar must not be nil");
//    #endif
    
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    dateFormatter.timeZone = calendar.timeZone;
//    dateFormatter.locale = calendar.locale;
    
//    NSMutableArray *days = nil;
//    days = [[dateFormatter standaloneMonthSymbols] mutableCopy];
    
//    [days enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"days:%ld--%@", idx, obj);
//    }];
}

- (void)bindViewModel {
    self.title = self.viewModel.title;
    
    [self.dateBlockCV registerClass:[XZXDayBlockCVCell class] forCellWithReuseIdentifier:kDateBlockCellIdentifier];
    
    // React collectionView:didSelectItemAtIndexPath:
    @weakify(self)
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)]
     subscribeNext:^(RACTuple *value) {
         @strongify(self)
         
         self.collectionViewSplitY = ([(NSIndexPath *)value.second row] / 7 + 1) * (self.sideLength + 10) + 5;
         //NSLog(@"x : %f", self.collectionViewSplitY);
         
         UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         XZXDayEventVC *vc = [sb instantiateViewControllerWithIdentifier:@"XZXDEViewController"];
         vc.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.navigationController pushViewController:vc animated:YES];
     }];
    self.dateBlockCV.delegate = nil;
    self.dateBlockCV.delegate = self;
    
    [self.dateBlockCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#pragma mark - 6.27
//
//- (void)nextPage {
//    NSIndexPath *currentIndexPath = [[self.dateBlockCV indexPathsForVisibleItems] lastObject];
//    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections / 2];
//    [self.dateBlockCV scrollToItemAtIndexPath:currentIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    
//    NSInteger nextItem = currentIndexPathSet.item + 1;
//    NSInteger nextSection = currentIndexPathSet.section;
//    if (nextItem == 3) {
//        // 当item等于轮播图的总个数的时候
//        // item等于0, 分区加1
//        // 未达到的时候永远在50分区中
//        nextItem = 0;
//        nextSection ++;
//    }
//    // NSLog(@"----%ld---%ld", nextItem, nextSection);
//    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
//    [self.dateBlockCV scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
//    
//}


#pragma mark - cv

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return MaxSections;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XZXDayBlockCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDateBlockCellIdentifier forIndexPath:indexPath];
    
    
    // temp
//    cell.backgroundColor = [UIColor blueColor];
//    
//    NSDate *dateOfCell = [_dateHelper dateForIndexPath:indexPath];
//    
//    XZXDayBlockCVCellViewModel *cellViewModel = [[XZXDayBlockCVCellViewModel alloc] initWithDate:dateOfCell];
    
    XZXDayBlockCVCellViewModel *cellViewModel = self.viewModel.cellViewModels[indexPath.item];
    
    [cell configureCellWithViewModel:cellViewModel];
    
    return cell;
}


#pragma mark - 

- (void)reloadDateForCell:(XZXDayBlockCVCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
}


#pragma mark - UICollectionView Delegate FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(_sideLength, _sideLength);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [XZXTransitionAnimator new];
}


#pragma mark - 

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
    
}


@end
