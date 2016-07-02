//
//  XZXDayEventVC.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/14.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEventVC.h"
#import "XZXCalendarVMServicesImpl.h"
#import "XZXDayEventVCViewModel.h"
#import "XZXDayBlockCVCell.h"

NSString *const kWeekDateBlockCellIdentifier = @"wdateblockCVCell";

@interface XZXDayEventVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) XZXHorizontalWeekCV *weekCV;
@property (nonatomic, strong) UITableView *dayEventTV;
@property (nonatomic, strong) XZXDayEventVCViewModel *viewModel;
@property (nonatomic, strong) XZXCalendarVMServicesImpl *viewModelServices;

@property (nonatomic, assign) CGFloat sideLength;
@end

@implementation XZXDayEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"self.height:%f", self.height);
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    // For the extended navigation bar effect to work, a few changes
    // must be made to the actual navigation bar.  Some of these changes could
    // be applied in the storyboard but are made in code for clarity.
    
    // Translucency of the navigation bar is disabled so that it matches with
    // the non-translucent background of the extension view.
    [self.navigationController.navigationBar setTranslucent:NO];
    
    // The navigation bar's shadowImage is set to a transparent image.  In
    // conjunction with providing a custom background image, this removes
    // the grey hairline at the bottom of the navigation bar.  The
    // ExtendedNavBarView will draw its own hairline.
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    // "Pixel" is a solid white 1x1 image.
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];
    
    
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    self.sideLength = (width - 80) / 7;
    
    // XZXHorizontalWeekCV
    XZXHorizontalWeekCV *weekCV = [[XZXHorizontalWeekCV alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.height) collectionViewLayout: [[UICollectionViewLayout alloc] init]];
    weekCV.backgroundColor = [UIColor clearColor];
    weekCV.delegate = self;
    weekCV.dataSource = self;
    [self.view addSubview:weekCV];
    self.weekCV = weekCV;
    
    UITableView *dayEventTV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.height) style:UITableViewStylePlain];
    dayEventTV.backgroundColor = [UIColor orangeColor];
    dayEventTV.delegate = self;
    dayEventTV.dataSource = self;
    [self.view addSubview:dayEventTV];
    self.dayEventTV = dayEventTV;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableView
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    cell.backgroundColor = [UIColor blueColor];
    return cell;
}




-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 210;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZXDayBlockCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWeekDateBlockCellIdentifier forIndexPath:indexPath];
    
    XZXDayBlockCVCellViewModel *cellViewModel = self.viewModel.cellViewModels[indexPath.item];
    
    [cell configureCellWithViewModel:cellViewModel];
    
    return cell;
}

#pragma mark - UICollectionView Delegate FlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return CGSizeMake(_sideLength, _sideLength);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}


@end
