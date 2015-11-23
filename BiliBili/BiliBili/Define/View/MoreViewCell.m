//
//  MoreViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "MoreViewCell.h"
#import "MoreItemViewController.h"
@interface MoreViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *allViewLabel;
@property (nonatomic, strong) UIViewController* vc;
@end

@implementation MoreViewCell
- (void)setWithDic:(NSDictionary<NSString*, NSMutableArray*>*)dic{
    NSArray<MoreItemViewController*>* cons = [self.vc childViewControllers];
    [cons enumerateObjectsUsingBlock:^(MoreItemViewController * _Nonnull vc, NSUInteger idx, BOOL * _Nonnull stop) {
        vc.view.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"MoreItemViewController.view.backgroundColor"];
        
        vc.animaTitle.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        self.allViewLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        
        [dic enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableArray * _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"pic"]) {
                [vc.pic setImageWithURL: obj[idx]];
            }else{
                [vc setValue:obj[idx] forKeyPath:key];
            }
        }];
    }];
}

- (UIViewController *)vc{
    if (_vc == nil) {
        _vc = [[UIViewController alloc] init];
        for (int i = 0; i < 4; ++i) {
            MoreItemViewController* cvc = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"MoreViewController"];
            [_vc.view addSubview: cvc.view];
            [_vc addChildViewController: cvc];
        }
        
        [self addSubview: _vc.view];
        __weak typeof(self) weakObj = self;
        [_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakObj);
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
        make.top.mas_offset(30);
        make.left.mas_equalTo(10);
        make.size.equalTo(@[v2,v3,v4]);
        make.bottom.equalTo(v3.mas_top).mas_equalTo(-10);
    }];
    [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top);
        make.left.equalTo(v1.mas_right).mas_equalTo(10);
        make.bottom.equalTo(v1.mas_bottom);
        make.right.mas_equalTo(-10);
    }];
    [v3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_left);
        make.bottom.mas_equalTo(-10);
    }];
    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v3.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(v3.mas_bottom);
    }];
}

@end
