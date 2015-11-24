//
//  CellItemViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "CellItemViewController.h"
#import "AVInfoViewController.h"

@implementation CellItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUpProperty{
    self.titleLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];

    self.danMuIcon.tintColor = [[ColorManager shareColorManager] colorWithString:@"themeColor"];
    self.danMuIcon.image = [self.danMuIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.playIcon.tintColor = [[ColorManager shareColorManager] colorWithString:@"themeColor"];
    self.playIcon.image = [self.playIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    AVInfoViewController* vc = [[AVInfoViewController alloc] init];
    [vc setWithModel:self.dataModel section:self.section];
    [self.navController pushViewController:vc animated:YES];
}

- (UIImageView *)imgv {
	if(_imgv == nil) {
		_imgv = [[UIImageView alloc] init];
        _imgv.layer.cornerRadius = 8;
        _imgv.layer.masksToBounds = YES;
        [self.view addSubview: _imgv];
        __weak typeof(self) weakObj = self;
        [_imgv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.width.mas_equalTo(weakObj.view);
            make.height.mas_equalTo(weakObj.view.mas_width).multipliedBy(0.61);
        }];
	}
	return _imgv;
}

- (UILabel *)titleLabel {
	if(_titleLabel == nil) {
		_titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByClipping;
        _titleLabel.font = [UIFont systemFontOfSize: 13];
        _titleLabel.font = [UIFont systemFontOfSize: 14];
        [self.view addSubview: _titleLabel];
        __weak typeof(self) weakObj = self;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakObj.imgv.mas_bottom).mas_offset(5);
            make.width.mas_equalTo(weakObj.view.mas_width).mas_offset(-10);
            make.centerX.equalTo(weakObj.view);
            make.bottom.mas_equalTo(weakObj.playIcon.mas_top).mas_offset(-10);
        }];
	}
	return _titleLabel;
}

- (UIImageView *)playIcon {
	if(_playIcon == nil) {
		_playIcon = [[UIImageView alloc] init];
        [_playIcon setImage: [UIImage imageNamed:@"list_playnumb_icon"]];
        [self.view addSubview: _playIcon];
        __weak typeof(self) weakObj = self;
        [_playIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(13);
            make.height.mas_equalTo(10);
            make.left.equalTo(weakObj.imgv);
            make.bottom.mas_offset(-5);
        }];

	}
	return _playIcon;
}

- (UILabel *)playLabel {
	if(_playLabel == nil) {
		_playLabel = [[UILabel alloc] init];
        _playLabel.font = [UIFont systemFontOfSize: 10];
        __weak typeof(self) weakObj = self;
        [self.view addSubview: _playLabel];
        [_playLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakObj.playIcon);
            make.left.mas_equalTo(weakObj.playIcon.mas_right).mas_offset(2);
        }];
	}
	return _playLabel;
}

- (UIImageView *)danMuIcon {
	if(_danMuIcon == nil) {
		_danMuIcon = [[UIImageView alloc] init];
        [_danMuIcon setImage:[UIImage imageNamed:@"list_danmaku_icon"]];
        __weak typeof(self) weakObj = self;
        [self.view addSubview: _danMuIcon];
        [_danMuIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.equalTo(weakObj.playIcon);
            make.centerY.equalTo(weakObj.playIcon);
            make.right.mas_equalTo(weakObj.danMuLabel.mas_left).mas_offset(-2);
        }];
	}
	return _danMuIcon;
}

- (UILabel *)danMuLabel {
	if(_danMuLabel == nil) {
		_danMuLabel = [[UILabel alloc] init];
        _danMuLabel.font = [UIFont systemFontOfSize: 10];
        __weak typeof(self) weakObj = self;
        [self.view addSubview: _danMuLabel];
        [_danMuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakObj.playIcon);
            make.right.equalTo(weakObj.titleLabel);
        }];
	}
	return _danMuLabel;
}

@end
