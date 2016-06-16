//
//  XZXCalendarVC.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarVC.h"
#import "XZXDateBlockCV.h"
#import "XZXDateBlockCVCell.h"
#import "XZXDayEventVC.h"
#import "XZXDateHelper.h"
#import "XZXTransitionAnimator.h"

#import "XZXDateBlockCVCellViewModel.h"
#import "XZXDateHelper.h"

#import <ReactiveCocoa.h>

NSString *const kDateBlockCellIdentifier = @"dateblockCVCell";
NSString *const kDateBlockCellNibName = @"XZXDateBlockCVCell";


@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) XZXCalendarViewModel *viewModel;

@property (weak, nonatomic) IBOutlet XZXDateBlockCV *dateBlockCV;
@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, assign) CGFloat collectionViewSplitY;
@end

@implementation XZXCalendarVC

#pragma mark - initialize

- (void)initViewModel {
#warning temp
    // self.dateHelper = [XZXDateHelper sharedDateHelper];
    // self.viewModel = [[XZXCalendarViewModel alloc] initWithDateHelper:_dateHelper];
    
    XZXCalendarViewModel *viewModel = [[XZXCalendarViewModel alloc] init];
    //viewModel.title = @"2016/6/15";
    self.viewModel = viewModel;
}


#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initViewModel];
    // 透明navigationBar
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //
    self.navigationController.delegate = self;
    
    //
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.sideLength = (width - 80) / 7;
    
    [self bindViewModel];
    
    //2016.6.15
    NSCalendar *calendar = [[XZXDateHelper sharedDateHelper] calendar];
    
    #if DEBUG
    NSAssert(calendar != nil, @"calendar must not be nil");
    #endif
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = calendar.timeZone;
    dateFormatter.locale = calendar.locale;
    
    NSMutableArray *days = nil;
    days = [[dateFormatter standaloneMonthSymbols] mutableCopy];
    
//    [days enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        NSLog(@"days:%ld--%@", idx, obj);
//    }];
}

- (void)bindViewModel {
    self.title = self.viewModel.title;
    
    [self.dateBlockCV registerClass:[XZXDateBlockCVCell class] forCellWithReuseIdentifier:kDateBlockCellIdentifier];
    
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
    
    XZXDateBlockCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDateBlockCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.item == 0) {
        cell.backgroundColor = [UIColor blackColor];
    } else if (indexPath.item == 7){
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor blueColor];
    }
    
    XZXDateHelper *dateHelper = [[XZXDateHelper alloc] init];
    NSDate *dateOfCell = [dateHelper dayForIndexPath:indexPath];
    
    NSLog(@"date of cell:%@--%ld", dateOfCell, indexPath.item);
    
    XZXDateBlockCVCellViewModel *cellViewModel = [[XZXDateBlockCVCellViewModel alloc] initWithDate:dateOfCell];
    
    [cell configureCellWithViewModel:nil atIndexPath:indexPath];
    
    return cell;
}


#pragma mark - 

- (void)reloadDateForCell:(XZXDateBlockCVCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    
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
