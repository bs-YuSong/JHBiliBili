//
//  RecommendViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/20.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "RecommendViewCell.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendCollectionViewController.h"
#import "ShinBanViewModel.h"
#import "UIViewController+Tools.h"
@interface RecommendViewCell ()
@property (strong, nonatomic) UILabel *recommedLabel;
@property (nonatomic, strong) UIImageView* recommedIcon;
@property (nonatomic, strong) NSArray* arr;
@end

@implementation RecommendViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setWithVM:(ShinBanViewModel*)vm{
    [self.vc setVM:vm colNum: 3];
    self.recommedLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
}
- (RecommendCollectionViewController *)vc{
    if (_vc == nil) {
        _vc = kStoryboardWithInd(@"RecommendCollectionViewController");
        [self addSubview: _vc.view];
        __weak typeof(self) weakObj = self;
        
        [_vc.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakObj.recommedIcon.mas_bottom).mas_offset(10);
            make.left.bottom.mas_equalTo(0);
            make.height.mas_equalTo(self.mas_width).multipliedBy(1.2);
            make.width.equalTo(weakObj);
        }];
    }
    return _vc;
}
- (UILabel *)recommedLabel {
	if(_recommedLabel == nil) {
		_recommedLabel = [[UILabel alloc] init];
        _recommedLabel.text = @"推荐番剧";
        [self addSubview: _recommedLabel];
        _recommedLabel.font = [UIFont systemFontOfSize: 13];
        __weak typeof(self)weakObj = self;
        [_recommedLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakObj.recommedIcon.mas_right).mas_offset(10);
            make.centerY.equalTo(weakObj.recommedIcon);
        }];
	}
	return _recommedLabel;
}

- (UIImageView *)recommedIcon {
	if(_recommedIcon == nil) {
		_recommedIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"ic_category_promo"]];
        [self addSubview: _recommedIcon];
        [_recommedIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.height.mas_equalTo(15);
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(20);
        }];
	}
	return _recommedIcon;
}

@end
