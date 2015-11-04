//
//  RecommendViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendViewController.h"
#import "CellItemViewController.h"
#import "CellView.h"
#import "RecommendViewModel.h"
#import "ScrollDisplayViewController.h"
#import "WebViewController.h"
@interface RecommendViewController ()<UITableViewDataSource, UITableViewDelegate,ScrollDisplayViewControllerDelegate>
@property (nonatomic, strong) RecommendViewModel* vm;
//@property (nonatomic, strong) NSArray* dicMap;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonnull, strong) ScrollDisplayViewController* sdcViewController;
@end

@implementation RecommendViewController
//1-3 动画 、129-3 舞蹈、13-3番剧 3-3音乐 4-3游戏 36-3科技 5-3娱乐 119-3鬼畜 11-3电视剧 23-3电影
//_list = [@{@"1-3day.json":@"",@"129-3day.json":@"",@"13-3day.json":@"",@"3-3day.json":@"",@"23-3day.json":@"",@"11-3day.json":@"",@"119-3":@"",@"5-3day.json":@"",@"36-3day.json":@"",@"4-3day.json":@""} mutableCopy];
//- (NSArray *)dicMap{
//    if (_dicMap == nil) {
//        _dicMap = @[@{@"动画":@"1-3day.json"},@{@"番剧":@"13-3day.json"},@{@"音乐":@"3-3day.json"},@{@"舞蹈":@"129-3day.json"},@{@"游戏":@"4-3day.json"},@{@"科技":@"36-3day.json"},@{@"娱乐":@"5-3day.json"},@{@"鬼畜":@"119-3day.json"},@{@"电影":@"23-3day.json"},@{@"电视剧":@"11-3day.json"}];
//    }
//    return _dicMap;
//}

kRemoveCellSeparator

- (RecommendViewModel *)vm{
    if (_vm == nil) {
        _vm = [[RecommendViewModel alloc] init];
    }
    return _vm;
}


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //滚动视图大小
    CGRect rect = self.headView.frame;
    rect.size.height = kWindowW/2;
    self.headView.frame = rect;
    
    MJRefreshNormalHeader* head = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.header endRefreshing];
            
            //从父对象移除
            [self.sdcViewController.view removeFromSuperview];
            [self.sdcViewController removeFromParentViewController];
            
            self.sdcViewController = [[ScrollDisplayViewController alloc] initWithImgPaths:[self.vm headImgArr]];
            self.sdcViewController.delegate = self;
            [self addChildViewController:self.sdcViewController];
            [self.headView addSubview:self.sdcViewController.view];
            
            [self.sdcViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.headView);
            }];
            
            [self.tableView reloadData];
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
    
    [self.tableView.header beginRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.vm sectionCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellView* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary* dic = self.vm.dicMap[indexPath.section];
    NSString* key = [dic allKeys].firstObject;
    cell.title.text = key;
    //图片文件名 home_region_icon_分区名
    NSString* imgName = [dic[key] componentsSeparatedByString:@"/"].lastObject;
    cell.titleImg.image = [UIImage imageNamed:[NSString stringWithFormat:@"home_region_icon_%@",[imgName componentsSeparatedByString:@"-"].firstObject]];
    
    [cell.moreButton setTitle:[@"更多" stringByAppendingString:key] forState:UIControlStateNormal];
    cell.enterView.layer.cornerRadius = cell.enterView.frame.size.width / 2;
    cell.enterView.layer.masksToBounds = YES;
    
    if (self.vm.list[dic[key]]) {
        if (![cell.contentView viewWithTag:101]) {
            NSMutableArray* itemArr = [NSMutableArray new];
            for (int i = 0; i < 4; ++i) {
                CellItemViewController* cvc = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"CellItemViewController"];
                RecommendDataModel* m = self.vm.list[dic[key]][i];
                cvc.view.tag = 100 + i;
                [cvc setViewContentWithModel:m];
                [itemArr addObject: cvc];
                [self addChildViewController: cvc];
                [cell.contentView addSubview: cvc.view];
            }
            [self makeConstraintsWithViews:itemArr cell:cell];
    
        }else{
            NSArray* conArr = self.childViewControllers;
            for (int i = 0; i < 4; ++i) {
                UIView* iv = [cell viewWithTag:100 + i];
                for (CellItemViewController* con in conArr) {
                    if (iv == con.view) {
                        RecommendDataModel* m = self.vm.list[dic[key]][i];
                        [con setViewContentWithModel:m];
                    }
                }
            }
        }
    }
    return cell;
}

- (void)makeConstraintsWithViews:(NSMutableArray *)views cell:(CellView*)cell{
    UIView* v1 = [views[0] view];
    UIView* v2 = [views[1] view];
    UIView* v3 = [views[2] view];
    UIView* v4 = [views[3] view];
    [v1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.titleImg.mas_bottom).mas_equalTo(10);
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
        make.bottom.mas_equalTo(-50);
    }];
    [v4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v3.mas_right).mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.bottom.equalTo(v3.mas_bottom);
    }];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    640*735
    return self.view.frame.size.width / 640 * 735;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
- (void)scrollDisplayViewController:(ScrollDisplayViewController *)scrollDisplayViewController didSelectedIndex:(NSInteger)index{
    WebViewController* wbc = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"WebViewController"];
    wbc.URL = [self.vm headImgURL:index];
    [self.navigationController pushViewController:wbc animated:YES];
}

@end
