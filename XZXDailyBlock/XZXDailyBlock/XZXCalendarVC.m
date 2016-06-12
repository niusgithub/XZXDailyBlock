//
//  XZXCalendarVC.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarVC.h"
#import "XZXDateBlockCV.h"
#import <ReactiveCocoa.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

#import "XZXTransitionAnimator.h"

NSString *const kDateBlockCellIdentifier = @"dateblockCVCell";
NSString *const kDateBlockCellNibName = @"XZXDateBlockCVCell";


@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UIViewControllerTransitioningDelegate>
@property (nonatomic) BOOL isMonthMode;

@property (weak, nonatomic) IBOutlet XZXDateBlockCV *dateBlockCV;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dateBlockBottomLC;

@property (nonatomic, strong) id dateBlockCVDelegate;
@end

@implementation XZXCalendarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Date";

    //[self.navigationController.navigationBar setTintColor:[UIColor blackColor]];
    
    [self.dateBlockCV registerNib:[UINib nibWithNibName:kDateBlockCellNibName bundle:nil] forCellWithReuseIdentifier:kDateBlockCellIdentifier];
    
    
    self.isMonthMode = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    // 透明navigationBar
    self.navigationController.navigationBar.translucent = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    @weakify(self);
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)] subscribeNext:^(RACTuple *value) {
        @strongify(self);
        //NSLog(@"vcDelegate %@--%@",value.first,value.second);
        UIViewController *vc = [[UIViewController alloc] init];
        vc.view.backgroundColor = [UIColor orangeColor];
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        vc.transitioningDelegate = self;
        
        [self presentViewController:vc animated:YES completion:NULL];
    }];
    
    //self.dateBlockCV.delegate = nil;
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
    
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}


#pragma mark - UICollectionView Delegate FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    CGFloat sideLength = (width - 80) / 7;
    
    return CGSizeMake(sideLength, sideLength);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return [XZXTransitionAnimator new];
}


@end
