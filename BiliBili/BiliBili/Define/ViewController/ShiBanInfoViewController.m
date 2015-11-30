//
//  ShiBanInfoViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "ShiBanInfoViewController.h"
#import "ShiBanInfoViewModel.h"
#import "ShinBanModel.h"
#import "TakeHeadTableView.h"
#import "AVItemTableViewController.h"
#import "JHViewController.h"
#import "WMMenuView.h"
#import "VideoViewController.h"

#define MENEVIEWHEIGHT 40

#define MAXOFFSET self.tableView.tableHeaderView.frame.size.height

#define MINOFFSET 0

#define EDGE 10

@interface ShiBanInfoViewController ()<UITableViewDelegate, UITableViewDataSource,JHViewControllerDelegate,WMMenuViewDelegate>
#pragma mark - 新番属性
@property (nonatomic, strong) UIImageView *shiBanCoverImgView;
@property (nonatomic, strong) UILabel *shiBanLabel;
@property (nonatomic, strong) UIImageView *shiBanPlayIcon;
@property (nonatomic, strong) UIImageView *shiBandanMuIcon;
@property (nonatomic, strong) UILabel *shiBanPlayLabel;
@property (nonatomic, strong) UILabel *shiBanDanMuLabel;
@property (nonatomic, strong) UILabel *shiBanUpDateLabel;
@property (nonatomic, strong) UIButton *shiBanPlayButton;
@property (nonatomic, strong) ShiBanInfoViewModel* svm;
@property (nonatomic, strong) TakeHeadTableView* tableView;
@property (nonatomic, strong) WMMenuView* menuView;
@property (nonatomic, strong) NSMutableArray<AVItemTableViewController*>* controllers;
@property (nonatomic, strong) JHViewController* pageViewController;
//顶部状态栏空间
@property (nonatomic, strong) NSValue* topFrame;
@end

@implementation ShiBanInfoViewController

- (instancetype)init{
    if (self = [super init]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateButtonTitleAndPlay:) name:@"Update" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpProperty];
    
    self.tableView.mj_header = [MyRefreshComplete myRefreshHead:^{
        [self.svm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self setUpProperty];
            [self.tableView reloadData];
            for (UITableViewController* c in self.controllers) {
                [c.tableView reloadData];
            }
            if (error) {
                [self showErrorMsg:kerrorMessage];
            }
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
}

- (void)setWithModel:(RecommentShinBanDataModel*)model{
    [self.svm setAVData:model];
}

- (void)setUpProperty{
    [self addChildViewController:self.pageViewController];
    [self.shiBanCoverImgView setImageWithURL: [self.svm shiBanCover]];
    self.shiBanLabel.text = [self.svm shiBanTitle];
    self.shiBanPlayLabel.text = [self.svm shinBanInfoPlayNum];
    self.shiBanDanMuLabel.text = [self.svm shinBanInfodanMuNum];
    self.shiBanUpDateLabel.text = [self.svm shinBanInfoUpdateTime];
    [self.shiBanPlayButton setTitle:[self.svm indexToTitle] == nil?@"N/A":[NSString stringWithFormat:@"播放第%@话",[self.svm indexToTitle]] forState:UIControlStateNormal];
}

- (void)updateButtonTitleAndPlay:(NSNotification *)notification{
    [self.shiBanPlayButton setTitle:[NSString stringWithFormat:@"播放第%@话",[self.svm indexToTitle]] forState:UIControlStateNormal];
    VideoViewController* vc =[[VideoViewController alloc] initWithAid: [self.svm videoAid]];
    [self presentViewController:vc animated:YES completion:nil];
    //[self.navigationController pushViewController: vc animated:YES];
}

- (void)setChildrenScrollEnabled{
    for (AVItemTableViewController* vc in self.controllers) {
        vc.tableView.scrollEnabled = YES;
    }
}



#pragma mark - UITableView

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"avInfoCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:0 reuseIdentifier:@"avInfoCell"];
    }
    cell.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"backgroundColor"];
    UIView* v =  [cell viewWithTag: 100];
    if (v == nil) {
        self.pageViewController.view.tag = 100;
        [cell.contentView addSubview: self.pageViewController.view];
        [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSArray* arr = @[@"承包商排行",@"番剧详情",[NSString stringWithFormat:@"评论(%ld)",(long)[self.svm allReply]]];
    
    WMMenuView* menuView = [[WMMenuView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 30) buttonItems:arr backgroundColor:[[ColorManager shareColorManager] colorWithString:@"AVInfoViewController.menuView.backgroundColor"] norSize:15 selSize:15 norColor:[[ColorManager shareColorManager] colorWithString:@"textColor"] selColor:[[ColorManager shareColorManager] colorWithString:@"AVInfoViewController.menuView.selColor"]];
    menuView.lineColor = [[ColorManager shareColorManager] colorWithString:@"AVInfoViewController.menuView.lineColor"];
    menuView.delegate = self;
    menuView.style = WMMenuViewStyleLine;
    self.menuView = menuView;
    return menuView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MENEVIEWHEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWindowH - [self.topFrame CGRectValue].size.height - MENEVIEWHEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

#pragma mark - 懒加载

- (UIImageView *)shiBanCoverImgView {
    if(_shiBanCoverImgView == nil) {
        _shiBanCoverImgView = [[UIImageView alloc] init];
        [self.tableView.tableHeaderView addSubview: _shiBanCoverImgView];
        [_shiBanCoverImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.left.mas_offset(10);
            make.width.mas_equalTo(_shiBanCoverImgView.mas_height).multipliedBy(0.7);
            make.bottom.mas_offset(-10);
        }];
    }
    return _shiBanCoverImgView;
}

- (UILabel *)shiBanLabel {
    if(_shiBanLabel == nil) {
        _shiBanLabel = [[UILabel alloc] init];
        _shiBanLabel.font = [UIFont systemFontOfSize: 15];
        _shiBanLabel.numberOfLines = 2;
        _shiBanLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        [self.tableView.tableHeaderView addSubview: _shiBanLabel];
        __weak typeof(self)weakObj = self;
        [_shiBanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakObj.shiBanCoverImgView);
            make.left.mas_equalTo(weakObj.shiBanCoverImgView.mas_right).mas_offset(10);
            make.right.mas_offset(-10);
            make.bottom.mas_equalTo(weakObj.shiBanPlayIcon.mas_top).mas_offset(-10);
        }];
    }
    return _shiBanLabel;
}

- (UIImageView *)shiBanPlayIcon {
    if(_shiBanPlayIcon == nil) {
        UIImage *img = [[UIImage imageNamed:@"list_playnumb_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _shiBanPlayIcon = [[UIImageView alloc] initWithImage: img];
        _shiBanPlayIcon.tintColor = [UIColor grayColor];
        [self.tableView.tableHeaderView addSubview: _shiBanPlayIcon];
        __weak typeof(self)weakObj = self;
        [_shiBanPlayIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(13);
            make.height.mas_equalTo(10);
            make.left.equalTo(weakObj.shiBanLabel);
            make.right.mas_equalTo(weakObj.shiBanPlayLabel.mas_left).mas_offset(-2);
        }];
    }
    return _shiBanPlayIcon;
}

- (UIImageView *)shiBandanMuIcon {
    if(_shiBandanMuIcon == nil) {
        _shiBandanMuIcon = [[UIImageView alloc] init];
        
        UIImage *img = [[UIImage imageNamed:@"list_danmaku_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _shiBandanMuIcon = [[UIImageView alloc] initWithImage: img];
        _shiBandanMuIcon.tintColor = [UIColor grayColor];
        [self.tableView.tableHeaderView addSubview: _shiBandanMuIcon];
        __weak typeof(self)weakObj = self;
        [_shiBandanMuIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(13);
            make.height.mas_equalTo(10);
            make.centerY.equalTo(weakObj.shiBanPlayIcon);
            make.right.mas_equalTo(weakObj.shiBanDanMuLabel.mas_left).mas_offset(-2);
        }];
    }
    return _shiBandanMuIcon;
}

- (UILabel *)shiBanPlayLabel {
    if(_shiBanPlayLabel == nil) {
        _shiBanPlayLabel = [[UILabel alloc] init];
        _shiBanPlayLabel.font = [UIFont systemFontOfSize: 10];
        _shiBanPlayLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        [self.tableView.tableHeaderView addSubview: _shiBanPlayLabel];
        __weak typeof(self)weakObj = self;
        [_shiBanPlayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakObj.shiBanPlayIcon);
            make.right.mas_equalTo(weakObj.shiBandanMuIcon.mas_left).mas_offset(-10);
        }];
    }
    return _shiBanPlayLabel;
}


- (UILabel *)shiBanDanMuLabel {
    if(_shiBanDanMuLabel == nil) {
        _shiBanDanMuLabel = [[UILabel alloc] init];
        _shiBanDanMuLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _shiBanDanMuLabel.font = [UIFont systemFontOfSize: 10];
        [self.tableView.tableHeaderView addSubview: _shiBanDanMuLabel];
        __weak typeof(self)weakObj = self;
        [_shiBanDanMuLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(weakObj.shiBanPlayIcon);
            make.right.mas_equalTo(weakObj.shiBanPlayButton.mas_left).mas_equalTo(-10);
            make.bottom.mas_equalTo(weakObj.shiBanUpDateLabel.mas_top).mas_offset(-10);
        }];
    }
    return _shiBanDanMuLabel;
}

- (UILabel *)shiBanUpDateLabel {
    if(_shiBanUpDateLabel == nil) {
        _shiBanUpDateLabel = [[UILabel alloc] init];
        _shiBanUpDateLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _shiBanUpDateLabel.font = [UIFont systemFontOfSize: 11];
        [self.tableView.tableHeaderView addSubview: _shiBanUpDateLabel];
        __weak typeof(self)weakObj = self;
        [_shiBanUpDateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakObj.shiBanPlayIcon);
            make.right.mas_equalTo(weakObj.shiBanPlayButton.mas_left).mas_offset(-10);
        }];
    }
    return _shiBanUpDateLabel;
}

- (UIButton *)shiBanPlayButton {
    if(_shiBanPlayButton == nil) {
        _shiBanPlayButton = [[UIButton alloc] init];
        [_shiBanPlayButton setBackgroundColor: [[ColorManager shareColorManager] colorWithString:@"themeColor"]];
        _shiBanPlayButton.layer.cornerRadius = 5;
        _shiBanPlayButton.titleLabel.font = [UIFont systemFontOfSize: 13];
        _shiBanPlayButton.titleLabel.numberOfLines = 0;
        _shiBanPlayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        _shiBanPlayButton.layer.masksToBounds = YES;
        [_shiBanPlayButton bk_addEventHandler:^(id sender) {
            [self updateButtonTitleAndPlay:nil];
        } forControlEvents:UIControlEventTouchUpInside];
        [self.tableView.tableHeaderView addSubview: _shiBanPlayButton];
        __weak typeof(self)weakObj = self;
        [_shiBanPlayButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(73.5);
            make.height.mas_equalTo(37);
            make.right.mas_offset(-10);
            make.centerY.equalTo(weakObj.shiBanCoverImgView);
        }];
        
    }
    return _shiBanPlayButton;
}

- (TakeHeadTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[TakeHeadTableView alloc] initWithHeadHeight:kWindowW * 0.4 + 30];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview: _tableView];
        __weak typeof(self) weakObj = self;
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakObj.view);
        }];
    }
    return _tableView;
}

- (ShiBanInfoViewModel *) svm {
    if(_svm == nil) {
        _svm = [[ShiBanInfoViewModel alloc] init];
    }
    return _svm;
}

- (NSMutableArray *)controllers{
    if (_controllers == nil) {
        _controllers = [NSMutableArray array];
        
        AVItemTableViewController* inverstorVC = [[AVItemTableViewController alloc] initWithVM:self.svm cellIdentity:@"InvestorTableViewCell" storyBoardIndentity:@"AVItemTableViewController" parentTableView:self.tableView];
        [_controllers addObject:inverstorVC];
        
        AVItemTableViewController* avInfoVC = [[AVItemTableViewController alloc] initWithVM:self.svm cellIdentity:@"shiBanInfoCell" storyBoardIndentity:@"AVItemTableViewController" parentTableView:self.tableView];
        [_controllers addObject:avInfoVC];
        
        AVItemTableViewController* replyVC = [[AVItemTableViewController alloc] initWithVM:self.svm cellIdentity:@"ReViewTableViewCell" storyBoardIndentity:@"AVItemTableViewController"  parentTableView:self.tableView];
        //添加脚部刷新
        replyVC.tableView.mj_footer = [MyRefreshComplete myRefreshFoot:^{
            [self.svm getMoveReplyCompleteHandle:^(NSError *error) {
                [replyVC.tableView.mj_footer endRefreshing];
                [replyVC.tableView reloadData];
                if (error) {
                    [self showErrorMsg: kerrorMessage];
                }
            }];
        }];
        
        [_controllers addObject:replyVC];
        
        
    }
    return _controllers;
}

- (JHViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[JHViewController alloc] initWithControllers:[self.controllers copy]];
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (NSValue *)topFrame{
    if (_topFrame == nil) {
        CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
        CGRect rectNav = self.navigationController.navigationBar.frame;
        rectStatus.size.height += rectNav.size.height;
        _topFrame = [NSValue valueWithCGRect: rectStatus];
    }
    return _topFrame;
}

#pragma mark - JHViewController

- (void)JHViewGetOffset:(CGPoint)offset{
    [self.menuView slideMenuAtProgress: offset.x / self.menuView.frame.size.width];
}

#pragma mark - WMMenuView
- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return self.view.frame.size.width / 3;
}
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex{
    [self.pageViewController setScrollViewPage:index];
}

#pragma mark - UIScrollerView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.y > MAXOFFSET){
        [scrollView setContentOffset:CGPointMake(0, MAXOFFSET)];
        scrollView.scrollEnabled = NO;
        [self setChildrenScrollEnabled];
    }
}

@end
