//
//  CellView.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "CellView.h"
#import "CellItemViewController.h"
@interface CellView ()
@property (nonatomic, strong) UIViewController* vc;
@end

@implementation CellView

- (void)setTitle:(NSString*)title titleImg:(NSString*)titleimg buttonTitle:(NSString*)buttonTitle dic:(NSDictionary<NSString*,id>*)dic{
    self.title.text = title;
    self.title.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    //图片文件名 home_region_icon_分区名
    [self.titleImg setImage:[UIImage imageNamed: titleimg]];
    
    [self.moreButton setTitle:[@"更多" stringByAppendingString: title] forState:UIControlStateNormal];
    [self.moreButton setTitleColor:[[ColorManager shareColorManager] colorWithString:@"textColor"] forState:UIControlStateNormal];
    [self.moreButton setBackgroundColor:[[ColorManager shareColorManager] colorWithString:@"CellView.moreButton.BackgroundColor"]];
    
    self.enterView.layer.masksToBounds = YES;
    self.enterLabel.alpha = 1;
    
    NSArray<CellItemViewController*>* arr = [self.vc childViewControllers];
    [arr enumerateObjectsUsingBlock:^(CellItemViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString: @"imgv"]) {
                [vc.imgv setImageWithURL: obj[idx]];
            }else if ([key isEqualToString: @"section"] || [key isEqualToString: @"navController"]){
                [vc setValue:obj forKeyPath:key];
            }else{
                [vc setValue:obj[idx] forKeyPath:key];
            }
        }];
        [vc setUpProperty];
    }];
}

- (UIViewController *)vc{
    if (_vc == nil) {
        _vc = [[UIViewController alloc] init];
        for(int i = 0;i < 4; ++i){
            CellItemViewController* v = [[CellItemViewController alloc] init];
            [_vc addChildViewController: v];
            [_vc.view addSubview: v.view];
        }
        [self addSubview: _vc.view];
        __weak typeof(self)weakObj = self;
        [_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakObj);
        }];
        [self makeConstraintsWithViews:_vc.childViewControllers];
    }
    return _vc;
}

#define EDGE 10 //单元格间距
- (void)makeConstraintsWithViews:(NSArray <UIViewController*>*)views{
    UIView* v1 = views[0].view;
    UIView* v2 = views[1].view;
    UIView* v3 = views[2].view;
    UIView* v4 = views[3].view;
    __weak typeof(self)weakObj = self;
    [v1 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakObj.titleImg.mas_bottom).mas_offset(10);
        make.left.mas_offset(EDGE);
       // make.height.mas_equalTo(v1.mas_width).multipliedBy(1.03);
        make.size.equalTo(@[v2,v3,v4]);
    }];
    [v2 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top);
        make.left.equalTo(v1.mas_right).mas_offset(EDGE);
        make.bottom.equalTo(v1.mas_bottom);
        make.right.mas_offset(-EDGE);
    }];
    [v3 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_left);
        make.top.mas_equalTo(v1.mas_bottom).mas_offset(EDGE);
    }];
    [v4 mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v3.mas_right).mas_offset(EDGE);
        make.top.mas_equalTo(v2.mas_bottom).mas_offset(EDGE);
        make.right.mas_offset(-EDGE);
        make.bottom.equalTo(weakObj.moreButton.mas_top).mas_offset(-EDGE);
    }];
}


#pragma mark - 懒加载
- (UILabel *)title{
    if (_title == nil) {
        _title = [[UILabel alloc] init];
        _title.font = [UIFont systemFontOfSize: 13];
        [self addSubview: _title];
        __weak typeof(self)weakObj = self;
        [_title mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakObj.titleImg);
            make.left.equalTo(weakObj.titleImg.mas_right).mas_offset(5);
        }];
    }
    return _title;
}

- (UIImageView *)titleImg{
    if (_titleImg == nil) {
        _titleImg = [[UIImageView alloc] init];
        [self addSubview: _titleImg];
        [_titleImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_offset(10);
            make.left.mas_offset(20);
            make.width.height.mas_equalTo(15);
        }];
    }
    return _titleImg;
}

- (UIButton *)moreButton{
    if (_moreButton == nil) {
        _moreButton = [[UIButton alloc] init];
        _moreButton.titleLabel.font = [UIFont systemFontOfSize: 13];
        [self addSubview: _moreButton];
        [_moreButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(125);
            make.height.mas_equalTo(31);
            make.left.mas_offset(10);
            make.bottom.mas_offset(-10);
        }];
    }
    return _moreButton;
}

- (UIView *)enterView{
    if (_enterView == nil) {
        __weak typeof(self)weakObj = self;
        _enterView = [[UIView alloc] init];
        _enterView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"CellView.enterView.backgroundColor"];
        [self addSubview: _enterView];
        [_enterView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakObj.titleImg);
            make.right.mas_offset(-10);
            make.width.height.mas_equalTo(15);
        }];
        
        UIImageView* imv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ipad_player_setup_arrow"]];
        imv.contentMode = UIViewContentModeScaleAspectFit;
        [_enterView addSubview: imv];
        [imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(weakObj.enterView);
            make.width.height.equalTo(weakObj.enterView).mas_offset(-5);
        }];
    }
    return _enterView;
}

- (UILabel *)enterLabel{
    if (_enterLabel == nil) {
        _enterLabel = [[UILabel alloc] init];
        _enterLabel.text = @"进去看看";
        _enterLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _enterLabel.font = [UIFont systemFontOfSize: 13];
        [self addSubview: _enterLabel];
        __weak typeof(self)weakObj = self;
        [_enterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(weakObj.enterView.mas_left).mas_offset(-5);
            make.centerY.equalTo(weakObj.enterView);
        }];
    }
    return _enterLabel;
}
@end
