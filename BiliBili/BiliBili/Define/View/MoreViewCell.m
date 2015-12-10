//
//  MoreViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "MoreViewCell.h"
#import "MoreItemViewController.h"
#define EDGE 10

@interface MoreViewCell ()
@property (strong, nonatomic) UILabel *allViewLabel;
@property (nonatomic, strong) UIImageView* allViewIcon;
@property (nonatomic, strong) UILabel* enterLabel;
@end

@implementation MoreViewCell
- (void)setWithDic:(NSDictionary<NSString*, NSMutableArray*>*)dic{
    self.allViewLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    self.enterLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    NSArray<MoreItemViewController*>* cons = [self.vc childViewControllers];
    [cons enumerateObjectsUsingBlock:^(MoreItemViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        [vc setUpProperty];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"pic"]) {
                [vc.pic setImageWithURL: obj[idx]];
            }else{
                [vc setValue:obj[idx] forKeyPath:key];
            }
        }];
    }];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIViewController *)vc{
    if (_vc == nil) {
        _vc = [[UIViewController alloc] init];
        for (int i = 0; i < 4; ++i) {
            MoreItemViewController* cvc = [[MoreItemViewController alloc] init];
            [_vc.view addSubview: cvc.view];
            [_vc addChildViewController: cvc];
        }
        
        [self addSubview: _vc.view];
        [_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
        [self makeConstraintsWithViews: _vc.childViewControllers];
    }
    return _vc;
}

- (void)makeConstraintsWithViews:(NSArray<MoreItemViewController*> *)views{
    UIView* v1 = views[0].view;
    UIView* v2 = views[1].view;
    UIView* v3 = views[2].view;
    UIView* v4 = views[3].view;
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.allViewIcon.mas_bottom).mas_offset(EDGE);
        make.left.mas_offset(EDGE);
        make.size.equalTo(@[v2,v3,v4]);
    }];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top);
        make.left.equalTo(v1.mas_right).mas_offset(EDGE);
        make.bottom.equalTo(v1.mas_bottom);
        make.right.mas_offset(-EDGE);
    }];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_left);
        make.top.mas_equalTo(v1.mas_bottom).mas_offset(EDGE);
        make.bottom.mas_equalTo(-EDGE);
    }];
    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(v2.mas_bottom).mas_offset(EDGE);
        make.left.equalTo(v3.mas_right).mas_offset(EDGE);
        make.right.mas_offset(-EDGE);
        make.bottom.equalTo(v3.mas_bottom);
    }];
    
}

- (UILabel *)allViewLabel {
    if(_allViewLabel == nil) {
        _allViewLabel = [[UILabel alloc] init];
        _allViewLabel.text = @"大家都在看";
        _allViewLabel.lineBreakMode = NSLineBreakByClipping;
        _allViewLabel.font = [UIFont systemFontOfSize: 13];
        [self addSubview: _allViewLabel];
        [_allViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.allViewIcon);
            make.left.mas_equalTo(self.allViewIcon.mas_right).mas_offset(10);
        }];
    }
    return _allViewLabel;
}

- (UIImageView *)allViewIcon {
    if(_allViewIcon == nil) {
        _allViewIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"home_region_icon_4"]];
        [self addSubview: _allViewIcon];
        [_allViewIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(15);
            make.left.mas_equalTo(20);
            make.top.mas_equalTo(10);
        }];
    }
    return _allViewIcon;
}

- (UILabel *)enterLabel {
    if(_enterLabel == nil) {
        _enterLabel = [[UILabel alloc] init];
        _enterLabel.text = @"进去看看";
        _enterLabel.font = [UIFont systemFontOfSize: 13];
        [self addSubview: _enterLabel];
        [_enterLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_offset(-10);
            make.centerY.equalTo(self.allViewIcon);
        }];
    }
    return _enterLabel;
}

@end
