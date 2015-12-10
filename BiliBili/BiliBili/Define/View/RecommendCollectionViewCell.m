//
//  RecommendCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/3.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "RecommendCollectionViewCell.h"

@implementation RecommendCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (UIImageView *)imgView {
    if(_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        [self.contentView addSubview: _imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.mas_equalTo(0);
            make.bottom.mas_equalTo(self.Label.mas_top);
        }];
    }
    return _imgView;
}

- (UILabel *)Label {
    if(_Label == nil) {
        _Label = [[UILabel alloc] init];
        _Label.textAlignment = NSTextAlignmentCenter;
        _Label.font = [UIFont systemFontOfSize: 11];
        _Label.numberOfLines = 2;
        [self.contentView addSubview: _Label];
        [_Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.left.right.mas_equalTo(0);
            make.height.mas_equalTo(29);
        }];
    }
    return _Label;
}
@end
