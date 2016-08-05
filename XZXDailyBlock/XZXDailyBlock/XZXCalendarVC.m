//
//  XZXCalendarVC.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/11.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXCalendarVC.h"
#import "XZXMetamacro.h"

#import "XZXDayBlockCV.h"
#import "XZXDayBlockCVCell.h"
#import "XZXDayBlockCVLayout.h"
#import "XZXDayBlockCVCellViewModel.h"

#import "XZXDayEventVC.h"
#import "XZXClock.h"

#import "XZXTransitionAnimator.h"

#import "XZXCalendarVMServicesImpl.h"
#import "XZXDateUtil.h"

#import <AVOSCloud/AVOSCloud.h>
#import <ReactiveCocoa/ReactiveCocoa.h>
#import <DKNightVersion/DKNightVersion.h>


NSString *const kCalendarDateBlockCellIdentifier = @"cdateblockCVCell";

@interface XZXCalendarVC ()<UICollectionViewDelegate, UICollectionViewDataSource, UINavigationControllerDelegate>

@property (nonatomic, strong) XZXCalendarVMServicesImpl *viewModelServices;
@property (nonatomic, strong) XZXCalendarViewModel *calendarViewModel;

@property (nonatomic, strong) XZXDayBlockCV *dayBlockCV;
@property (nonatomic, strong) XZXDayBlockCVLayout *dayBlockCVLayout;
@property (nonatomic, strong) UIButton *startEventBtn;

@property (nonatomic, assign) CGFloat sideLength;
@property (nonatomic, assign) CGFloat collectionViewSplitY;
@property (nonatomic, assign) NSInteger pageNumber;

#warning temp
@property (nonatomic, assign) NSInteger clickTimes;
@end

@implementation XZXCalendarVC

#pragma mark - life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Test
//    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
//    [testObject setObject:@"bar" forKey:@"foo"];
//    [testObject save];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self crash];
//    });

    [self initViews];
    
    [self initViewModel];
    
    [self bindViewModel];
    
    [self bindRAC];
    
    // DKNightVersion
    self.view.dk_backgroundColorPicker = DKColorPickerWithKey(BG);
    self.dk_manager.themeVersion = @"SEA";
    
    // 5个月份中间的月份calendar为当前月 起始item为84 item87在第一行正中间
    [self.dayBlockCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:87 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
}

//FIXME: bad code 需要用RAC实现
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.startEventBtn.hidden = NO;
    
    [self initViewModel];
    [self.dayBlockCV reloadData];
}


#pragma mark - initialize

- (void)initViews {
    // NavigationBar
    [self.navigationController.navigationBar setTranslucent:NO];
    [self.navigationController.navigationBar setShadowImage:[UIImage imageNamed:@"TransparentPixel"]];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Pixel"] forBarMetrics:UIBarMetricsDefault];;
    
    // 替换NavigationBar返回按钮
    self.navigationController.delegate = self;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"月历" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backItem;
    
    // CollectionView
    self.sideLength = (MainScreenWidth - 80) / 7;
    self.pageNumber = 2;
    
    CGFloat collectionViewHeight = 8 + (_sideLength + 10) * 6;
    
    XZXDayBlockCVLayout *layout = [[XZXDayBlockCVLayout alloc] init];
    layout.itemSize = CGSizeMake(_sideLength, _sideLength);
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    layout.minimunLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    self.dayBlockCVLayout = layout;
    
    XZXDayBlockCV *dayBlockCV = [[XZXDayBlockCV alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, collectionViewHeight) collectionViewLayout:self.dayBlockCVLayout];
    dayBlockCV.backgroundColor = [UIColor clearColor];
    dayBlockCV.showsVerticalScrollIndicator = NO;
    dayBlockCV.showsHorizontalScrollIndicator = NO;
    dayBlockCV.pagingEnabled = YES;
    dayBlockCV.delegate = self;
    dayBlockCV.dataSource = self;
    
    [self.view addSubview:dayBlockCV];
    self.dayBlockCV = dayBlockCV;
    
    [self.dayBlockCV registerClass:[XZXDayBlockCVCell class] forCellWithReuseIdentifier:kCalendarDateBlockCellIdentifier];
    
    // UIButton
    //y:screenHeigth-64-44
    //UIButton *startEventBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, MainScreenHeight-108, MainScreenWidth, 44)];
    UIButton *startEventBtn = [[UIButton alloc] initWithFrame:CGRectMake(MainScreenWidth-65, MainScreenHeight-75, 50, 50)];
    [startEventBtn setImage:[UIImage imageNamed:@"addNew"] forState:UIControlStateNormal];
    // [startEventBtn setTitle:@"开始" forState:UIControlStateNormal];
    // startEventBtn.layer.borderWidth = 1.f;
    // startEventBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [startEventBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    startEventBtn.backgroundColor = [UIColor redColor];
    startEventBtn.layer.shadowOpacity = 0.4f;
    startEventBtn.layer.shadowOffset = CGSizeMake(0, 8);
    startEventBtn.layer.shadowRadius = 5.0f;
    startEventBtn.layer.cornerRadius = 25.f;
//    [self.view addSubview:startEventBtn];
    [[UIApplication sharedApplication].keyWindow addSubview:startEventBtn];
    self.startEventBtn = startEventBtn;
}

- (void)initViewModel {
    self.viewModelServices = [XZXCalendarVMServicesImpl new];
    self.calendarViewModel = [[XZXCalendarViewModel alloc] initWithServices:_viewModelServices];
    // RAC(self, viewModel)
}


- (void)bindViewModel {
    RAC(self, title) = [[RACObserve(self, pageNumber) distinctUntilChanged]
                        map:^id(id value) {
                            return [XZXDateUtil dateStringOfHomeTitleWithMouthOffset:self.pageNumber-2];
                        }];
}

- (void)bindRAC {
    @weakify(self)
    
    // collectionView:didSelectItemAtIndexPath:
    [[self rac_signalForSelector:@selector(collectionView:didSelectItemAtIndexPath:) fromProtocol:@protocol(UICollectionViewDelegate)]
     subscribeNext:^(RACTuple *value) {
         @strongify(self)
         
         self.collectionViewSplitY = ([(NSIndexPath *)value.second item] % 42 / 7 + 1) * (self.sideLength + 10) + 5;
         //XZXLog(@"Y : %f", self.collectionViewSplitY);
         
         XZXDayEventVC *dayEventVC = [[XZXDayEventVC alloc] init];
         dayEventVC.selectedItemIndex = [(NSIndexPath *)value.second item];
         dayEventVC.height =  15 + self.sideLength; // 上10 下5
         
         dayEventVC.modalPresentationStyle = UIModalPresentationFullScreen;
         [self.navigationController pushViewController:dayEventVC animated:YES];
     }];
    self.dayBlockCV.delegate = nil;
    self.dayBlockCV.delegate = self;
    
    //
    self.startEventBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self)
            
            self.startEventBtn.hidden = YES;
            
            XZXClock *clock = [[XZXClock alloc] init];
            [self presentViewController:clock animated:YES completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
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
    
    XZXDayBlockCVCellViewModel *cellViewModel = self.calendarViewModel.cellViewModels[indexPath.item];
    
    [cell configureCellWithViewModel:cellViewModel];
    
    return cell;
}

//#pragma mark - UICollectionView Delegate FlowLayout

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
//    return CGSizeMake(_sideLength, _sideLength);
//}
//
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(10, 10, 10, 10);
//}


#pragma mark - UIScrollView Delegate

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewDidScroll");
//}
//
//- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
//    NSLog(@"scrollViewWillBeginDragging");
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.pageNumber = scrollView.contentOffset.x/MainScreenWidth;
}


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
    self.pageNumber = 2;
    [self.dayBlockCV scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:87 inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

//- (void)startTickTock {
//    XZXClock *clock = [[XZXClock alloc] init];
//    [self presentViewController:clock animated:YES completion:nil];
//}

//- (void)crash {
//    [NSException raise:NSGenericException format:@"测试，模拟崩溃"];
//}

@end
