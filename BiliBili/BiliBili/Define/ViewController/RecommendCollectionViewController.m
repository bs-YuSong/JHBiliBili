//
//  RecommendCollectionViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/3.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendCollectionViewController.h"
#import "RecommendCollectionViewCell.h"
#import "ShinBanModel.h"
#import "ShinBanViewModel.h"
#define EDGE 10
@interface RecommendCollectionViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic, strong) NSArray<RecommentShinBanDataModel*>* items;
@property (nonatomic, assign) NSInteger colNum;
@property (nonatomic, strong) ShinBanViewModel* vm;
@end

@implementation RecommendCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakObj = self;
    self.collectionView.footer = [MyRefreshComplete myRefreshFoot:^{
        [self.vm getMoreDataCompleteHandle:^(NSError *error) {
            [weakObj.collectionView.footer endRefreshing];
            [weakObj.collectionView reloadData];
        }];
    }];
}

- (NSArray<RecommentShinBanDataModel *> *)items{
    if (_items == nil) {
        _items = [NSArray array];
    }
    return _items;
}

- (void)setVM:(ShinBanViewModel*)vm colNum:(NSInteger)num{
    self.items = [vm getRecommentList];
    self.colNum = num;
    self.vm = vm;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    //cell的宽度等于(屏宽-2*边距-(列数-1)*item间的间距)/列数
    CGFloat inset = [self collectionView:collectionView layout:collectionViewLayout minimumInteritemSpacingForSectionAtIndex:0];
    CGFloat width = (kWindowW - 2 * EDGE - (self.colNum - 1) * inset) / self.colNum;
    
    return CGSizeMake(width, width / 0.7 + 30);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(EDGE, EDGE, EDGE, EDGE);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 10;
}


#pragma mark  <UICollectionViewDataSource>


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    RecommendCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"RecommendCollectionViewCell" forIndexPath:indexPath];
    [cell.imgView setImageWithURL:[NSURL URLWithString:self.items[indexPath.row].cover]];
    cell.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"RecommendCollectionViewCell.backgroundColor"];
    cell.Label.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"RecommendCollectionViewCell.Label.backgroundColor"];
    cell.Label.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    cell.Label.text = self.items[indexPath.row].title;
    
    return cell;
}
#pragma mark  <UICollectionViewDelegate>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    DDLogVerbose(@"%ld",(long)indexPath.row);
}

- (void)colorSetting{
    [self.collectionView reloadData];
}
@end
