//
//  resolutionView.m
//  BiliBili
//
//  Created by apple-jd44 on 15/12/1.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "resolutionView.h"
@interface resolutionView ()
@property (nonatomic, strong) NSString* resolution;
@end

@implementation resolutionView
- (instancetype)init{
    if (self = [super init]) {
        
        
        self.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"backgroundColor"];
        self.layer.shadowOpacity = 0.5;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(0, 3);
        
        UIButton* b1 = [[UIButton alloc] init];
        [self addSubview: b1];
        [b1 setTitle:@"精美画质" forState:UIControlStateNormal];
        b1.titleLabel.font = [UIFont systemFontOfSize: 14];
        [b1 setTitleColor:[[ColorManager shareColorManager] colorWithString:@"textColor"] forState:UIControlStateNormal];
        [b1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.right.mas_equalTo(0);
        }];
        
        __weak typeof(self)weakSelf = self;
        [b1 bk_addEventHandler:^(id sender) {
            weakSelf.resolution = @"high";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeResolution" object:nil userInfo:@{@"title":@"high"}];
        } forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* b2 = [[UIButton alloc] init];
        [self addSubview: b2];
        b2.titleLabel.font = [UIFont systemFontOfSize: 14];
        [b2 setTitle:@"普通画质" forState:UIControlStateNormal];
        [b2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(b1.mas_bottom);
            make.size.centerX.equalTo(b1);
        }];
        [b2 setTitleColor:[[ColorManager shareColorManager] colorWithString:@"textColor"] forState:UIControlStateNormal];
        
        [b2 bk_addEventHandler:^(id sender) {
            weakSelf.resolution = @"normal";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeResolution" object:nil userInfo:@{@"title":@"normal"}];
        } forControlEvents:UIControlEventTouchUpInside];
        
        UIButton* b3 = [[UIButton alloc] init];
        [self addSubview: b3];
        b3.titleLabel.textAlignment = NSTextAlignmentLeft;
        b3.titleLabel.font = [UIFont systemFontOfSize: 14];
        [b3 setTitleColor:[[ColorManager shareColorManager] colorWithString:@"textColor"] forState:UIControlStateNormal];
        [b3 setTitle:@"渣画质" forState:UIControlStateNormal];

        [b3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(b2.mas_bottom);
            make.size.centerX.equalTo(b1);
            make.bottom.mas_equalTo(0);
        }];
        [b3 bk_addEventHandler:^(id sender) {
            weakSelf.resolution = @"low";
            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeResolution" object:nil userInfo:@{@"title":@"low"}];
        } forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (NSString*)currentResolution{
    return self.resolution;
}



- (NSString *)resolution {
	if(_resolution == nil) {
		_resolution = @"high";
	}
	return _resolution;
}

@end
