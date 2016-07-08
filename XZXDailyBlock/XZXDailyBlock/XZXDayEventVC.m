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
#import "XZXDayEventTVCell.h"
#import "XZXWeekCVLayout.h"
#import "XZXDayBlockCVCellViewModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>
#import <DKNightVersion/DKNightVersion.h>


NSString *const kWeekDateBlockCellIdentifier = @"wdateBlockCVCell";
NSString *const kWeekDateEventCellIdentifier = @"wdateEventCVCell";

@interface XZXDayEventVC () <UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource>
@property (strong, nonatomic) XZXHorizontalWeekCV *weekCV;
@property (nonatomic, strong) UITableView *dayEventTV;
@property (nonatomic, strong) XZXDayEventVCViewModel *viewModel;
@property (nonatomic, strong) XZXCalendarVMServicesImpl *viewModelServices;
@property (nonatomic, strong) XZXWeekCVLayout *weekLayout;

@property (nonatomic, assign) CGFloat sideLength;
@end

@implementation XZXDayEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    
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
    
    XZXWeekCVLayout *layout = [[XZXWeekCVLayout alloc] init];
    layout.itemSize = CGSizeMake(_sideLength, _sideLength);
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8); // top left bottom right 其实只用了top和left
    layout.minimunLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.weekLayout = layout;
    
    // XZXHorizontalWeekCV
    XZXHorizontalWeekCV *weekCV = [[XZXHorizontalWeekCV alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, self.height) collectionViewLayout:self.weekLayout];
    weekCV.backgroundColor = [UIColor clearColor];
    weekCV.showsVerticalScrollIndicator = NO;
    weekCV.showsHorizontalScrollIndicator = NO;
    weekCV.pagingEnabled = YES;
    weekCV.delegate = self;
    weekCV.dataSource = self;
    [self.view addSubview:weekCV];
    self.weekCV = weekCV;
    
    [self.weekCV registerClass:[XZXDayBlockCVCell class] forCellWithReuseIdentifier:kWeekDateBlockCellIdentifier];
    
    NSInteger itemIndexPath = self.selectedItemIndex - self.selectedItemIndex%7 + 3;
    
    [self.weekCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndexPath inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
    
    
    
    UITableView *dayEventTV = [[UITableView alloc] initWithFrame:CGRectMake(0, self.height, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height - self.height) style:UITableViewStylePlain];
    dayEventTV.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    dayEventTV.delegate = self;
    dayEventTV.dataSource = self;
    [self.view addSubview:dayEventTV];
    self.dayEventTV = dayEventTV;
    
    [self.dayEventTV registerNib:[UINib nibWithNibName:@"XZXDayEventTVCell" bundle:nil] forCellReuseIdentifier:kWeekDateEventCellIdentifier];
    
    [self initViewModel];
    
    [self bindViewModel];
}

- (void)initViewModel {
    self.viewModelServices = [XZXCalendarVMServicesImpl new];
    self.viewModel = [[XZXDayEventVCViewModel alloc] initWithServices:_viewModelServices];
}

- (void)bindViewModel {
//    self.title = self.viewModel.dayBlockVMs[self.selectedItemIndex].titleOfDate;
    @weakify(self);
    
    RAC(self, title) = [[RACObserve(self, selectedItemIndex) distinctUntilChanged]
                        map:^id(id value) {
                            @strongify(self)
                            return self.viewModel.dayBlockVMs[[value intValue]].titleOfDate;
                        }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZXDayBlockCVCellViewModel *dayBlockVM = self.viewModel.dayBlockVMs[self.selectedItemIndex];
    XZXDayEventTVCellViewModel *dayEventVM = dayBlockVM.dayEventVMs[indexPath.row];
    
    XZXDayEventTVCell *cell = [tableView dequeueReusableCellWithIdentifier:kWeekDateEventCellIdentifier];
    [cell configureCellWithViewModel:dayEventVM];
    
    return cell;
}


#pragma mark - UICollectionViewDataSource

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 210;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    XZXDayBlockCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kWeekDateBlockCellIdentifier forIndexPath:indexPath];
    
    XZXDayBlockCVCellViewModel *cellViewModel = self.viewModel.dayBlockVMs[indexPath.item];
    [cell configureCellWithViewModel:cellViewModel];
    
    return cell;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedItemIndex = indexPath.item;
//    self.title = self.viewModel.dayBlockVMs[self.selectedItemIndex].titleOfDate;
    [self.dayEventTV reloadData];
}

@end
