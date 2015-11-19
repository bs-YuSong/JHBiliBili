//
//  JHViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/11.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "JHViewController.h"
@interface JHViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) NSArray<UIViewController*>* conArr;
@end

@implementation JHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - 初始化
- (instancetype)initWithControllers:(NSArray*)controllers{
    if (self = [super init]) {
        self.conArr = controllers;
        [self.view addSubview:self.scrollView];
        [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    return self;
}


#pragma mark - 懒加载
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;

        __block UIView* preView = nil;
        [self.conArr enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self addChildViewController: obj];
            [_scrollView addSubview:obj.view];
            if (preView == nil) {
                [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.left.height.width.equalTo(_scrollView);
                }];
            }else{
                [obj.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(preView.mas_right);
                    make.top.width.height.equalTo(preView);
                }];
            }
            preView = obj.view;
        }];
        [preView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_scrollView.mas_right);
        }];
    }
    return _scrollView;
}

- (NSArray<UIViewController *> *)conArr{
    if (_conArr == nil) {
        _conArr = [NSArray array];
    }
    return _conArr;
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.currentPage = scrollView.contentOffset.x / self.scrollView.frame.size.width;
    [self.delegate JHViewGetOffset:scrollView.contentOffset];
}

@end
