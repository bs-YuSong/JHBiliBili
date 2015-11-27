//
//  ShinBanViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "ShinBanViewController.h"
#import "ShinBanViewModel.h"
#import "MoreViewCell.h"
#import "RecommendViewCell.h"
#import "TakeHeadTableView.h"
#import "ShiBanPlayTableViewController.h"

@interface ShinBanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ShinBanViewModel* vm;
@property (strong, nonatomic) TakeHeadTableView *tableView;
@property (strong, nonatomic) UIButton *everyDayPlay;
@property (strong, nonatomic) UIButton *shinBanIndex;
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
    [self.tableView.mj_header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.tableView];
    //调用懒加载
    self.shinBanIndex.hidden = NO;
    
    __block typeof(self) weakObj = self;
    self.tableView.mj_header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [weakObj.tableView.mj_header endRefreshing];
            [weakObj.tableView reloadData];
            if (error) {
                [self showErrorMsg:kerrorMessage];
            }
            
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.vm moreViewListCount]) {
        return 1;
    }
    return 0;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //第一行显示大家都在看 第二行显示推荐番剧
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        MoreViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"scell"];
        if (cell == nil) {
            cell = [[MoreViewCell alloc] initWithStyle:0 reuseIdentifier:@"scell"];
            [self addChildViewController: cell.vc];
        }
        NSDictionary* dic = @{@"pic":[NSMutableArray array],@"playNum.text":[NSMutableArray array],@"animaTitle.text":[NSMutableArray array],@"model":[NSMutableArray array]};
        for (int i = 0; i < 4; ++i) {
            [dic[@"pic"] addObject:[self.vm moreViewPicForRow: i]];
            [dic[@"animaTitle.text"] addObject:[self.vm moreViewTitleForRow: i]];
            [dic[@"playNum.text"] addObject:[self.vm moreViewPlayForRow: i]];
            [dic[@"model"] addObject:[self.vm moreViewModelForRow: i]];
        }
        [cell setWithDic:dic];
        return cell;
    }else{
        RecommendViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"scell2"];
        if (cell == nil) {
            cell = [[RecommendViewCell alloc] initWithStyle:0 reuseIdentifier:@"scell2"];
            [self addChildViewController: (UITableViewController*)cell.vc];
        }
        [cell setWithVM:self.vm];

        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)colorSetting{
    self.tableView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"backgroundColor"];
    [self.tableView reloadData];
}


#pragma mark - 懒加载
- (UIButton *)everyDayPlay {
	if(_everyDayPlay == nil) {
		_everyDayPlay = [[UIButton alloc] init];
        [_everyDayPlay setBackgroundImage:[UIImage imageNamed:@"home_bangumi_timeline"] forState:UIControlStateNormal];
        [self.tableView.tableHeaderView addSubview: _everyDayPlay];
        __weak typeof(self)weakObj = self;
        [_everyDayPlay mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_offset(10);
            make.centerY.equalTo(weakObj.tableView.tableHeaderView);
            make.height.mas_equalTo(_everyDayPlay.mas_width).multipliedBy(0.29);
        }];
        
        [_everyDayPlay bk_addEventHandler:^(id sender) {
            //推出每日放送表
            ShiBanPlayTableViewController* vc = [[ShiBanPlayTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
            [self.navigationController pushViewController: vc animated:YES];
        } forControlEvents:UIControlEventTouchUpInside];
	}
	return _everyDayPlay;
}

- (UIButton *)shinBanIndex {
	if(_shinBanIndex == nil) {
		_shinBanIndex = [[UIButton alloc] init];
        [_shinBanIndex setBackgroundImage:[UIImage imageNamed:@"home_bangumi_category"] forState:UIControlStateNormal];
        [self.tableView.tableHeaderView addSubview: _shinBanIndex];
        __weak typeof(self)weakObj = self;
        [_shinBanIndex mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakObj.everyDayPlay.mas_right).mas_offset(10);
            make.right.mas_offset(-10);
            make.centerY.equalTo(weakObj.everyDayPlay);
            make.size.equalTo(weakObj.everyDayPlay);
        }];
	}
	return _shinBanIndex;
}

- (TakeHeadTableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[TakeHeadTableView alloc] initWithHeadHeight: kWindowW *0.18];
        _tableView.delegate = self;
        _tableView.dataSource = self;
	}
	return _tableView;
}

@end
