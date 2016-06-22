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

#import <ReactiveCocoa.h>

NSString *const kDateBlockCellIdentifier = @"dateblockCVCell";
//NSString *const kDateBlockCellNibName = @"XZXDateBlockCVCell";


@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) XZXCalendarVMServicesImpl *viewModelServices;

@property (nonatomic, strong) XZXCalendarViewModel *viewModel;

@property (weak, nonatomic) IBOutlet XZXDayBlockCV *dateBlockCV;

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, assign) CGFloat collectionViewSplitY;

@property (nonatomic, strong) XZXDateHelper *dateHelper;
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - cv

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    XZXDayBlockCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDateBlockCellIdentifier forIndexPath:indexPath];
    
    
    // temp
    cell.backgroundColor = [UIColor blueColor];
    
    NSDate *dateOfCell = [_dateHelper dateForIndexPath:indexPath];
    
    XZXDayBlockCVCellViewModel *cellViewModel = [[XZXDayBlockCVCellViewModel alloc] initWithDate:dateOfCell];
    
    [cell configureCellWithViewModel:cellViewModel atIndexPath:indexPath];
    
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

@end
