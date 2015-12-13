//
//  SearchViewController.m
//  BiliBili
//
//  Created by apple-jd24 on 15/12/13.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchViewModel.h"
#import "SearchShiBanTableViewCell.h"
#import "SearchSpecialTableViewCell.h"

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong)SearchViewModel* vm;
@property (nonatomic, strong)UITableView* tableView;
@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.mj_header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self.tableView reloadData];
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (instancetype)initWithkeyWord:(NSString *)keyWord{
    if (self = [super init]) {
        self.vm = [[SearchViewModel alloc] initWithKeyWord: keyWord];
    }
    return self;
}

#pragma mark - UITableView
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //第一个分区为番剧 第二个分区为专题 第三个为相关视频
    if (section == 0) {
        return [self.vm shiBanCount];
    }else if (section == 1){
        return [self.vm specialCount];
    }else{
        return [self.vm videosCount];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //番剧分区
    if (indexPath.section == 0) {
        SearchShiBanTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SearchShiBanTableViewCell"];
        if (cell == nil) {
            cell = [[SearchShiBanTableViewCell alloc] initWithStyle:0 reuseIdentifier: @"SearchShiBanTableViewCell"];
        }
        [cell setWithDic: @{
                            @"coverImgView":[self.vm shiBanCoverWithIndex: indexPath.row],
                            @"titleLabel.text":[self.vm shiBanTitleWithIndex: indexPath.row],
                            @"clicklabel.text":[self.vm shiBanClickNumWithIndex: indexPath.row],
                            @"favoriteLabel.text":[self.vm shiBanFavoriteNumWithIndex: indexPath.row],
                            @"episodeLabel.text":[self.vm shiBanNewEpisodeWithIndex:indexPath.row]
                            }];
        return cell;
        
        
    }else if (indexPath.section == 1){
        SearchSpecialTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: @"SearchSpecialTableViewCell"];
        if (cell == nil) {
            cell = [[SearchSpecialTableViewCell alloc] initWithStyle:0 reuseIdentifier: @"SearchSpecialTableViewCell"];
        }
        [cell setWithDic:
         @{@"coverImgView":[self.vm specialCoverWithIndex: indexPath.row],
           @"titleLabel.text":[self.vm specialTitleWithIndex: indexPath.row]
           }];
        return cell;
    }else{
        UITableViewCell* cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier: @"cell3"];
        cell.textLabel.text = [self.vm videoTitleWithIndex: indexPath.row];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated: YES];
}

#pragma mark - 懒加载

- (UITableView *)tableView{
    if(_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.estimatedRowHeight = 200;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [self.view addSubview: _tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return _tableView;
}

@end
