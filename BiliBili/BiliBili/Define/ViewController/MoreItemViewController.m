//
//  MoreViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MoreItemViewController.h"


@implementation MoreItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.pic.hidden = NO;
    self.playNum.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"themeColor" alpha: 0.5];
}

- (UIImageView *)pic {
    if(_pic == nil) {
        _pic = [[UIImageView alloc] init];
        _pic.layer.cornerRadius = 10;
        _pic.layer.masksToBounds = YES;
        [self.view addSubview: _pic];
        __weak typeof(self)weakObj = self;
        [_pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.equalTo(weakObj.view);
            make.height.mas_equalTo(weakObj.view.mas_width).multipliedBy(0.64);
        }];
    }
    return _pic;
}

- (UILabel *)animaTitle {
    if(_animaTitle == nil) {
        _animaTitle = [[UILabel alloc] init];
        _animaTitle.numberOfLines = 2;
        _animaTitle.font = [UIFont systemFontOfSize: 13];
        _animaTitle.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        [self.view addSubview: _animaTitle];
        __weak typeof(self)weakObj = self;
        [_animaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(weakObj.view).mas_offset(-10);
            make.centerX.equalTo(weakObj.view);
            make.top.mas_equalTo(weakObj.pic.mas_bottom).mas_offset(5);
            make.bottom.equalTo(weakObj.view).mas_offset(-5);
        }];
    }
    return _animaTitle;
}

- (UILabel *)playNum {
    if(_playNum == nil) {
        _playNum = [[UILabel alloc] init];
        _playNum.textAlignment = NSTextAlignmentCenter;
        _playNum.layer.cornerRadius = 3;
        _playNum.layer.masksToBounds = YES;
        _playNum.textColor = [UIColor whiteColor];
        _playNum.font = [UIFont systemFontOfSize: 12];
        [self.view addSubview: _playNum];
        __weak typeof(self)weakObj = self;
        [_playNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(41);
            make.height.mas_equalTo(21);
            make.bottom.equalTo(weakObj.pic).mas_offset(-10);
            make.right.equalTo(weakObj.pic).mas_offset(-10);
        }];
    }
    return _playNum;
}

@end
