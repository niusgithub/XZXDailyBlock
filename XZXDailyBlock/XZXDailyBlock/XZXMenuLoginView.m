//
//  XZXMenuLoginView.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/8.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXMenuLoginView.h"

@interface XZXMenuLoginView()
@property (nonatomic, strong) UIImageView *avatarIV;
@property (nonatomic, strong) UILabel *nameL;
@end

@implementation XZXMenuLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        CGFloat avavtarSideLength = frame.size.width*0.6;
        
        UIImageView *avatarIV = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width*0.2, 0, avavtarSideLength, avavtarSideLength)];
        avatarIV.image = [UIImage imageNamed:@"defaultAvatar"];
        avatarIV.layer.cornerRadius = frame.size.width * 0.3;
        [self addSubview:avatarIV];
        self.avatarIV = avatarIV;
        
        UILabel *nameL = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width*0.6, frame.size.width, frame.size.width*0.4)];
//        nameL.backgroundColor = [UIColor orangeColor];
        nameL.text = @"Name";
        nameL.textAlignment = NSTextAlignmentCenter;
        [self addSubview:nameL];
        self.nameL = nameL;
    }
    
    return self;
}

@end
