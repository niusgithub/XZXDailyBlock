//
//  XZXCalendarVC.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarVC.h"
#import "XZXDateBlockCV.h"
#import "XZXDayEventVC.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "XZXTransitionAnimator.h"

NSString *const kDateBlockCellIdentifier = @"dateblockCVCell";
NSString *const kDateBlockCellNibName = @"XZXDateBlockCVCell";


@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>
@property (nonatomic) BOOL isMonthMode;

@property (weak, nonatomic) IBOutlet XZXDateBlockCV *dateBlockCV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBlockBottomLC;
@property (nonatomic, weak) UINavigationBar *navigationBar;

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, assign) CGFloat collectionViewSplitY;
@end

@implementation XZXCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Date";
    
    [self.dateBlockCV registerNib:[UINib nibWithNibName:kDateBlockCellNibName bundle:nil] forCellWithReuseIdentifier:kDateBlockCellIdentifier];
    
    
    self.isMonthMode = YES;
    
    // 透明navigationBar
//    self.navigationController.navigationBar.translucent = YES;
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    //
    self.navigationController.delegate = self;
    self.navigationBar = self.navigationController.navigationBar;
    
    //
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.sideLength = (width - 80) / 7;
    
    
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
         //vc.transitioningDelegate = self;
        
//         UIButton *backBtn = [[UIButton alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//         [backBtn setTitle:@"BACK" forState:UIControlStateNormal];
//         [[backBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//             //[vc dismissViewControllerAnimated:YES completion:NULL];
//             [vc.navigationController popViewControllerAnimated:YES];
//         }];
//         [vc.view addSubview:backBtn];
         
         //[self presentViewController:vc animated:YES completion:NULL];
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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kDateBlockCellIdentifier forIndexPath:indexPath];
    
    if (indexPath.row == 0) {
        cell.backgroundColor = [UIColor blackColor];
    } else if (indexPath.row == 7){
        cell.backgroundColor = [UIColor redColor];
    } else {
        cell.backgroundColor = [UIColor blueColor];
    }
    
    return cell;
}


#pragma mark - 

//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath


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
