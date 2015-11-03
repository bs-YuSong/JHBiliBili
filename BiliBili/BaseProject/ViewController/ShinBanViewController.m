//
//  ShinBanViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ShinBanViewController.h"
#import "ShinBanViewModel.h"
#import "MoreViewCell.h"
#import "MoreViewController.h"
#import "PSCollectionView.h"
#import "RecommendAnimaViewController.h"
#import "RecommendCollectionViewController.h"

@interface ShinBanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ShinBanViewModel* vm;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *everyDayPlay;
@property (weak, nonatomic) IBOutlet UIButton *ShinBanIndex;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightC;

@property (nonatomic, strong) RecommendCollectionViewController* collectionViewController;

@property (nonatomic, strong) PSCollectionView* psCollectionView;

@end

@implementation ShinBanViewController

- (ShinBanViewModel *)vm{
    if (_vm == nil) {
        _vm = [ShinBanViewModel new];
    }
    return _vm;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //填补表尾空白
    self.tableView.tableFooterView = [UIView new];
    //头部高度
    self.heightC.constant = (kWindowW - 30) / 4.56 / 2;
    
    MJRefreshNormalHeader* head = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            [self.collectionViewController.collectionView reloadData];
            if (error) {
                [self showErrorMsg:error.localizedDescription];
            }
            
        }];
        
    }];
    
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:@"再拉，再拉就刷新给你看" forState:MJRefreshStateIdle];
    [head setTitle:@"够了啦，松开人家嘛" forState:MJRefreshStatePulling];
    [head setTitle:@"刷呀刷，好累啊，喵(＾▽＾)" forState:MJRefreshStateRefreshing];
    self.tableView.header = head;
    
//    self.tableView.footer=[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
//        
//        [self.vm refreshDataCompleteHandle:^(NSError *error) {
//            [self.tableView.footer endRefreshing];
//            [self.tableView reloadData];
//        }];
//        
//    }];
    [self.tableView.header beginRefreshing];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    MoreViewCell* cell = [MoreViewCell new];
    
    if (self.vm.moreViewList.count != 0) {
        if (indexPath.section == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"scell"];
            if (![cell.contentView viewWithTag:101]) {
                NSMutableArray* itemArr = [NSMutableArray new];
                for (int i = 0; i < 4; ++i) {
                    MoreViewController* cvc = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"MoreViewController"];
                    cvc.view.tag = 100 + i;
                    [cvc.pic setImageWithURL: [self.vm moreViewPicForRow: i]];
                    cvc.animaTitle.text = [self.vm moreViewTitleForRow: i];
                    cvc.playNum.text = [self.vm moreViewPlayForRow:i];
                    [itemArr addObject: cvc];
                    [self addChildViewController: cvc];
                    [cell.contentView addSubview: cvc.view];
                }
                [self makeConstraintsWithViews:itemArr cell:cell];
                
            }else{
                NSArray* conArr = self.childViewControllers;
                for (int i = 0; i < 4; ++i) {
                    UIView* iv = [cell viewWithTag:100 + i];
                    for (MoreViewController* con in conArr) {
                        if (iv == con.view) {
                            [con.pic setImageWithURL: [self.vm moreViewPicForRow: i]];
                            con.animaTitle.text = [self.vm moreViewTitleForRow: i];
                            con.playNum.text = [self.vm moreViewPlayForRow:i];
                        }
                    }
                }
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"scell2"];
            [self addChildViewController: self.collectionViewController];
            [cell.contentView addSubview: self.collectionViewController.collectionView];
            [self.collectionViewController.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.left.right.equalTo(cell);
                make.top.equalTo(cell).offset(35);
            }];
        }
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //第一行显示大家都在看 第二行显示推荐番剧
    return 2;
}

- (void)makeConstraintsWithViews:(NSMutableArray *)views cell:(MoreViewCell*)cell{
    UIView* v1 = [views[0] view];
    UIView* v2 = [views[1] view];
    UIView* v3 = [views[2] view];
    UIView* v4 = [views[3] view];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.icon.mas_bottom).mas_equalTo(10);
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //大家都在看单元格
   // if (indexPath.section == 0) {
        return kWindowW / 640 * 735;
//    }
//    //推荐单元格
//    if (indexPath.section == 1) {
//        return [self collectionView:self.psCollectionView heightForRowAtIndex:1] * self.vm.recommentList.count / self.psCollectionView.numColsPortrait;
//    }
//    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

#pragma mark - CollectionView

- (RecommendCollectionViewController *)collectionViewController{
    if (_collectionViewController == nil) {
        _collectionViewController = kStoryboardWithInd(@"RecommendCollectionViewController");
        [_collectionViewController setItems:self.vm.recommentList colNum: 3];
    }
    return _collectionViewController;
}


//#pragma mark - PSCollectionViewDataSource
//
//- (PSCollectionView *)psCollectionView{
//    if (_psCollectionView == nil) {
//        _psCollectionView = [[PSCollectionView alloc] init];
//        _psCollectionView.delegate = self;
//        _psCollectionView.collectionViewDelegate = self;
//        _psCollectionView.collectionViewDataSource = self;
//        _psCollectionView.numColsPortrait = 3;
//         //[_psCollectionView setScrollEnabled: NO];
//    }
//    return _psCollectionView;
//}
//
//- (CGFloat)collectionView:(PSCollectionView *)collectionView heightForRowAtIndex:(NSInteger)index{
//    return kWindowW / self.psCollectionView.numColsPortrait / 0.7;
//}
//
//- (NSInteger)numberOfRowsInCollectionView:(PSCollectionView *)collectionView{
//    return self.vm.recommentList.count;
//}
//
//
//- (PSCollectionViewCell *)collectionView:(PSCollectionView *)collectionView cellForRowAtIndex:(NSInteger)index{
//    PSCollectionViewCell* cell = [collectionView dequeueReusableViewForClass:[PSCollectionViewCell class]];
//    //PSCollectionViewCell* cell = [[PSCollectionViewCell alloc] init];
//    if (!cell) {
//        cell = [[PSCollectionViewCell alloc] init];
//        
//        UIImageView *imageView=[UIImageView new];
//        [cell addSubview:imageView];
//        imageView.tag = 110;
//    }
//    UIImageView* imgView = (UIImageView*)[cell viewWithTag:110];
//    
//    [imgView setImageWithURL:[self.vm commendCoverForRow:index]];
//    
//    [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(cell);
//    }];
//    return cell;
//}
//
//- (void)collectionView:(PSCollectionView *)collectionView didSelectCell:(PSCollectionViewCell *)cell atIndex:(NSInteger)index{
//    DDLogVerbose(@"%@ %@",NSStringFromCGSize(collectionView.contentSize),NSStringFromCGRect(collectionView.frame));
//   // NSLog(@"%ld",(long)index);
//}
@end
