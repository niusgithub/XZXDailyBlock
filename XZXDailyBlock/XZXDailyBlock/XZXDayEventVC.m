//
//  XZXDayEventVC.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/6/14.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXDayEventVC.h"

@interface XZXDayEventVC () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation XZXDayEventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
