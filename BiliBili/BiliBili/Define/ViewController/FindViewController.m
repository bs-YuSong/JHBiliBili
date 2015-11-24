//
//  FindViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/31.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "FindViewController.h"
#import "FindViewModel.h"
#import "UIImage+Tools.h"
#import "UIView+Tools.h"
#import "TakeHeadTableView.h"
#import "HotSearchButton.h"
#import "HotSearchTableViewCell.h"

#define EDGE 12

@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) FindViewModel* vm;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (weak, nonatomic) IBOutlet UIView *headView;
//@property (weak, nonatomic) IBOutlet UIButton *allSectionRangeButton;
//@property (weak, nonatomic) IBOutlet UIImageView *hotSearchLeftImgView;
//@property (weak, nonatomic) IBOutlet UIImageView *hotSearchRightImgView;
//@property (weak, nonatomic) IBOutlet UIView *hotSearchBottomBlackView;
//@property (weak, nonatomic) IBOutlet UILabel *hotSearchLeftLabel;
//@property (weak, nonatomic) IBOutlet UILabel *hotSearchRightLabel;
//@property (weak, nonatomic) IBOutlet UILabel *allViewLabel;

@property (strong, nonatomic) TakeHeadTableView *tableView;
@property (strong, nonatomic) UIButton *allSectionRangeButton;
@property (strong, nonatomic) UIButton *originateRangeButton;

@property (strong, nonatomic) HotSearchButton *hotSearchLeftButton;
@property (strong, nonatomic) HotSearchButton *hotSearchRightButton;
@property (strong, nonatomic) UILabel *allViewLabel;
//@property (strong, nonatomic) UIView *headView;
//@property (strong, nonatomic) UIImageView *hotSearchLeftImgView;
//@property (strong, nonatomic) UIImageView *hotSearchRightImgView;
//@property (strong, nonatomic) UIView *hotSearchBottomBlackView;
//@property (strong, nonatomic) UILabel *hotSearchLeftLabel;
//@property (strong, nonatomic) UILabel *hotSearchRightLabel;


@property (nonatomic, strong) UIImage* upImg;
@property (nonatomic, strong) UIImage* downImg;
@property (nonatomic, strong) UIImage* keepImg;
@end

@implementation FindViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview: self.tableView];
    
    __weak typeof(self)weakObj = self;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakObj.view);
    }];
    
    //为了调用懒加载而已
    self.allSectionRangeButton.hidden = NO;
    self.allViewLabel.text = @"大家都在搜";
    self.hotSearchRightButton.hidden = NO;
    
    self.tableView.mj_header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            
            [self.hotSearchLeftButton setBackgroundImageForState:UIControlStateNormal withURL:[self.vm rankCoverForNum:0]];
            [self.hotSearchRightButton setBackgroundImageForState:UIControlStateNormal withURL:[self.vm rankCoverForNum:1]];
            [self.hotSearchLeftButton setNeedsDisplay];
            [self.hotSearchRightButton setNeedsDisplay];
            self.hotSearchLeftButton.label.text = [self.vm coverKeyWordForNum:0];
            self.hotSearchRightButton.label.text = [self.vm coverKeyWordForNum:1];
            
            [self.tableView reloadData];
            if (error) {
                [self showErrorMsg: kerrorMessage];
            }
        }];
    }];

    [self.tableView.mj_header beginRefreshing];
}

- (FindViewModel *)vm{
    if (_vm == nil) {
        _vm = [[FindViewModel alloc] init];
    }
    return _vm;
}

- (UIImage *)upImg{
    if (_upImg == nil) {
        _upImg = [[UIImage imageNamed:@"search_icon"] clipImageWithRect:CGRectMake(0, 0, 7, 10)];
    }
    return _upImg;
}

- (UIImage *)downImg{
    if (_downImg == nil) {
        _downImg = [[UIImage imageNamed:@"search_icon"] clipImageWithRect:CGRectMake(10, 0, 7, 10)];
    }
    return _downImg;
}

- (UIImage *)keepImg{
    if (_keepImg == nil) {
        _keepImg = [[UIImage imageNamed:@"search_icon"] clipImageWithRect:CGRectMake(20, 0, 7, 10)];
    }
    return _keepImg;
}

# pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.vm rankArrConut];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HotSearchTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"fvcell"];
    if (cell == nil) {
        cell = [[HotSearchTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"fvcell"];
        cell.textLabel.font = [UIFont systemFontOfSize: 14];
        cell.backgroundColor = [UIColor clearColor];
    }
    [cell setWithRank:indexPath keyWord:[self.vm keyWordForRow: indexPath.row] state:[self.vm statusWordForRow:indexPath.row]];
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

# pragma mark - 颜色设置
- (void)colorSetting{
    self.allViewLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    [self.tableView reloadData];
}


#pragma mark - 懒加载
- (TakeHeadTableView *)tableView {
	if(_tableView == nil) {
		_tableView = [[TakeHeadTableView alloc] initWithHeadHeight:kWindowW * 0.7];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
        
	}
	return _tableView;
}

/**
 *  全区排行
 *
 */
- (UIButton *)allSectionRangeButton {
	if(_allSectionRangeButton == nil) {
		_allSectionRangeButton = [[UIButton alloc] init];
        [_allSectionRangeButton setBackgroundImage:[UIImage imageNamed:@"763b819c9a7dc5e09368a96e5c8d75da"] forState:UIControlStateNormal];
        [self.tableView.tableHeaderView addSubview: _allSectionRangeButton];
        __weak typeof(self)weakObj = self;
        [_allSectionRangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.mas_offset(EDGE);
            make.height.mas_equalTo(_allSectionRangeButton.mas_width).multipliedBy(0.46);
            make.size.equalTo(weakObj.originateRangeButton);
        }];
	}
	return _allSectionRangeButton;
}


- (UIButton *)originateRangeButton {
	if(_originateRangeButton == nil) {
		_originateRangeButton = [[UIButton alloc] init];
        [_originateRangeButton setBackgroundImage:[UIImage imageNamed:@"83899f035f7a3ec866a77478773b5f48"] forState:UIControlStateNormal];
        __weak typeof(self)weakObj = self;
        [self.tableView.tableHeaderView addSubview: _originateRangeButton];
        [_originateRangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakObj.allSectionRangeButton);
            make.left.mas_equalTo(weakObj.allSectionRangeButton.mas_right).mas_offset(EDGE);
            make.right.mas_offset(-EDGE);
        }];
	}
	return _originateRangeButton;
}

- (HotSearchButton *)hotSearchLeftButton {
	if(_hotSearchLeftButton == nil) {
		_hotSearchLeftButton = [[HotSearchButton alloc] initWithKeyWord:[self.vm coverKeyWordForNum:0]];
        [_hotSearchLeftButton setBackgroundImageForState:UIControlStateNormal withURL:[self.vm rankCoverForNum:0]];
        __weak typeof(self)weakObj = self;
        [self.tableView.tableHeaderView addSubview: _hotSearchLeftButton];
        [_hotSearchLeftButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakObj.allViewLabel.mas_bottom).mas_offset(EDGE);
            make.left.equalTo(weakObj.allViewLabel);
            make.height.mas_equalTo(_hotSearchLeftButton.mas_width).multipliedBy(0.63);
            make.size.equalTo(weakObj.hotSearchRightButton);
        }];
	}
	return _hotSearchLeftButton;
}

- (HotSearchButton *)hotSearchRightButton {
	if(_hotSearchRightButton == nil) {
		_hotSearchRightButton = [[HotSearchButton alloc] initWithKeyWord:[self.vm coverKeyWordForNum:1]];
         [_hotSearchRightButton setBackgroundImageForState:UIControlStateNormal withURL:[self.vm rankCoverForNum:1]];
        __weak typeof(self)weakObj = self;
        [self.tableView.tableHeaderView addSubview: _hotSearchRightButton];
        [_hotSearchRightButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakObj.hotSearchLeftButton.mas_right).mas_offset(EDGE);
            make.top.equalTo(weakObj.hotSearchLeftButton);
            make.right.mas_offset(-EDGE);
        }];
	}
	return _hotSearchRightButton;
}

- (UILabel *)allViewLabel {
	if(_allViewLabel == nil) {
		_allViewLabel = [[UILabel alloc] init];
        _allViewLabel.font = [UIFont systemFontOfSize: 13];
        __weak typeof(self)weakObj = self;
        [self.tableView.tableHeaderView addSubview: _allViewLabel];
        [_allViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(weakObj.allSectionRangeButton.mas_bottom).mas_offset(EDGE);
            make.left.equalTo(weakObj.allSectionRangeButton);
        }];
	}
	return _allViewLabel;
}

@end
