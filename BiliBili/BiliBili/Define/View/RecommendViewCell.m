//
//  RecommendViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/20.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendViewCell.h"
#import "RecommendCollectionViewCell.h"
#import "RecommendCollectionViewController.h"
#import "ShinBanViewModel.h"
@interface RecommendViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *recommedLabel;
@property (nonatomic, strong) RecommendCollectionViewController* vc;
@property (nonatomic, strong) NSArray* arr;
@end

@implementation RecommendViewCell
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
            make.bottom.left.right.equalTo(weakObj);
            make.top.equalTo(weakObj).offset(35);
        }];
    }
    return _vc;
}
@end
