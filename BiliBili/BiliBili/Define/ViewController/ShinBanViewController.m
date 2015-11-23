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
#import "RecommendViewCell.h"
//#import "RecommendCollectionViewController.h"

@interface ShinBanViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) ShinBanViewModel* vm;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIButton *everyDayPlay;
@property (weak, nonatomic) IBOutlet UIButton *ShinBanIndex;
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
    //头部高度
    [self.everyDayPlay mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.everyDayPlay.mas_width).multipliedBy(0.22);
    }];
    
    __block typeof(self) weakObj = self;
    self.tableView.header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [weakObj.tableView.header endRefreshing];
            [weakObj.tableView reloadData];
            if (error) {
                [self showErrorMsg:kerrorMessage];
            }
            
        }];
    }];
    
    [self.tableView.header beginRefreshing];
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
        NSDictionary* dic = @{@"pic":[NSMutableArray array],@"animaTitle.text":[NSMutableArray array],@"playNum.text":[NSMutableArray array]};
        for (int i = 0; i < 4; ++i) {
            [dic[@"pic"] addObject:[self.vm moreViewPicForRow: i]];
            [dic[@"animaTitle.text"] addObject:[self.vm moreViewTitleForRow: i]];
            [dic[@"playNum.text"] addObject:[self.vm moreViewPlayForRow: i]];
        }
        [cell setWithDic:dic];
        return cell;
    }else{
        RecommendViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"scell2"];
        [cell setWithVM:self.vm];

        return cell;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWindowW / 640 * 735;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (void)colorSetting{
    [self.tableView reloadData];
}

@end
