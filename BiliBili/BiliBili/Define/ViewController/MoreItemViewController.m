//
//  MoreViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MoreItemViewController.h"
#import "AVInfoViewController.h"

@implementation MoreItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpProperty];
}

- (void)setUpProperty{
    self.view.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"MoreItemViewController.view.backgroundColor"];
    self.animaTitle.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    self.playNum.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"themeColor" alpha: 0.5];
    self.pic.hidden = NO;
}

- (UIImageView *)pic {
    if(_pic == nil) {
        _pic = [[UIImageView alloc] init];
        _pic.layer.cornerRadius = 10;
        _pic.layer.masksToBounds = YES;
        [self.view insertSubview:_pic atIndex:0];
        [_pic mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.equalTo(self.view);
            make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.64);
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
        [_animaTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(self.view).mas_offset(-10);
            make.centerX.equalTo(self.view);
            make.top.mas_equalTo(self.pic.mas_bottom).mas_offset(5);
            make.bottom.equalTo(self.view).mas_offset(-5);
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
        [self.view insertSubview:_playNum atIndex:1];
        [_playNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_greaterThanOrEqualTo(41);
            make.height.mas_equalTo(21);
            make.bottom.equalTo(self.pic).mas_offset(-10);
            make.right.equalTo(self.pic).mas_offset(-10);
        }];
    }
    return _playNum;
}

- (MoreViewShinBanDataModel *)model{
    if(_model == nil) {
        _model = [[MoreViewShinBanDataModel alloc] init];
    }
    return _model;
}


- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    AVInfoViewController* vc = [[AVInfoViewController alloc] init];
    AVDataModel* model = [[AVDataModel alloc] init];
    model.aid = self.model.aid;
    model.pic = self.model.pic;
    model.title = self.model.title;
    model.author = self.model.author;
    model.play = self.model.play;
    model.video_review = self.model.video_review;
    model.create = self.model.create;
    [vc setWithModel:model section: @"13-3day.json"];
    [self.navigationController pushViewController: vc animated:YES];
}

@end
