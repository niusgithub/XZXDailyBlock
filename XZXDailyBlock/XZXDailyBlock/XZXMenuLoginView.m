//
//  XZXMenuLoginView.m
//  XZXDailyBlock
//
//  Created by 陈知行 on 16/8/8.
//  Copyright © 2016年 陈知行. All rights reserved.
//

#import "XZXMenuLoginView.h"

#import <AVOSCloud.h>

@interface XZXMenuLoginView()
@property (nonatomic, strong) UIImageView *avatarIV;
@property (nonatomic, strong) UILabel *nameL;
@end

@implementation XZXMenuLoginView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        
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

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self login];
}

- (void)login {
//    [AVOSCloud requestSmsCodeWithPhoneNumber:@"13545370819" callback:^(BOOL succeeded, NSError *error) {
//        if(!succeeded) {
//            NSLog(@"注册失败 ERR:%@",error);
//        }
//    }];
    
//    [AVUser signUpOrLoginWithMobilePhoneNumberInBackground:@"13545370819" smsCode:@"583091" block:^(AVUser *user, NSError *error) {
//        // 如果 error 为空就可以表示登录成功了，并且 user 是一个全新的用户
//        if (!error) {
//            NSLog(@"新用户注册并登录成功!");
//        } else {
//            NSLog(@"注册失败 ERR:%@",error);
//        }
//    }];
}

@end
