//
//  AVInfoViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/1.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

//滑动视图高

#import "AVInfoViewController.h"
#import "NSString+Tools.h"
#import "AVModel.h"
#import "WMMenuView.h"
#import "AVInfoViewModel.h"
#import "AVItemTableViewController.h"
#import "UIScrollView+Tools.h"
#import "JHViewController.h"
#import "VideoViewController.h"
#import "TakeHeadTableView.h"

#define MENEVIEWHEIGHT 40

#define MAXOFFSET self.tableView.tableHeaderView.frame.size.height

#define MINOFFSET 0

#define EDGE 10

@interface AVInfoViewController ()<UITableViewDelegate,UITableViewDataSource,WMMenuViewDelegate,JHViewControllerDelegate>

@property (strong, nonatomic)  TakeHeadTableView *tableView;

@property (nonatomic, strong) AVInfoViewModel* vm;

@property (nonatomic, strong) JHViewController* pageViewController;

@property (nonatomic, strong) WMMenuView* menuView;

#pragma mark - 一般视频属性
//up名
@property (strong, nonatomic) UILabel *UPLabel;
//视频缩略图
@property (strong, nonatomic) UIImageView *imgView;
//播放数
@property (strong, nonatomic) UILabel *playNumLabel;
//弹幕数
@property (strong, nonatomic) UILabel *danMuNumLabel;
//发布时间
@property (strong, nonatomic) UILabel *publicTimeLabel;
//视频标题
@property (strong, nonatomic) UILabel *titleLabel;
//播放按钮
@property (strong, nonatomic) UIButton *playButton;



@property (nonatomic, strong) NSMutableArray<AVItemTableViewController*>* controllers;
//顶部状态栏空间
@property (nonatomic, strong) NSValue* topFrame;

@end

@implementation AVInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self colorSetting];
    //初始化属性
    [self setProperty];
    
    __block typeof(self) weakObj = self;
    self.tableView.mj_header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [weakObj.tableView.mj_header endRefreshing];
            [weakObj.tableView reloadData];
            for (UITableViewController* c in weakObj.controllers) {
                [c.tableView reloadData];
            }
            if (error) {
                [self showErrorMsg: kerrorMessage];
            }
        }];
    }];
    [self.tableView.mj_header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}


#pragma mark - tableViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


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
    
    NSMutableArray* arr = [@[@"视频详情",@"相关视频",[NSString stringWithFormat:@"评论(%ld)",(long)[self.vm allReply]]] mutableCopy];
    if ([self.vm isShiBan]) {
        [arr insertObject:@"承包商排行" atIndex:0];
    }
    
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


#pragma mark - 初始化属性
- (void)setWithModel:(AVDataModel*)model section:(NSString*)section{
        [self.vm setAVData:model section:section];
        self.navigationItem.title = [NSString stringWithFormat:@"av%@", model.aid];
}

/**
 *  初始化一般视频信息
 */
- (void)setProperty{
    
    [self addChildViewController:self.pageViewController];
    
    //设置up名
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"UP主："];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString: [self.vm infoUpName] attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:[[ColorManager shareColorManager] colorWithString:@"themeColor"]}]];
    [self.UPLabel setAttributedText:str];
    //播放数
    self.playNumLabel.text = [NSString stringWithFormat:@"播放：%@", [self.vm infoPlayNum]];
    //弹幕数
    self.danMuNumLabel.text = [NSString stringWithFormat:@"弹幕数：%@", [self.vm infoDanMuCount]];
    //创建时间
    self.publicTimeLabel.text = [NSString stringWithFormat:@"发布于：%@", [self.vm infoTime]];
    //图片URL
    [self.imgView setImageWithURL: [self.vm infoImgURL]];
    //标题
    self.titleLabel.text = [self.vm infoTitle];
    
    [self.playButton setTitle:@"点击播放" forState:UIControlStateNormal];
}

- (void)setChildrenScrollEnabled{
    for (AVItemTableViewController* vc in self.controllers) {
        vc.tableView.scrollEnabled = YES;
    }
}


#pragma mark - 懒加载

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

- (AVInfoViewModel *)vm{
    if (_vm == nil) {
        _vm = [AVInfoViewModel new];
    }
    return _vm;
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

- (JHViewController *)pageViewController{
    if (_pageViewController == nil) {
        _pageViewController = [[JHViewController alloc] initWithControllers:[self.controllers copy]];
        _pageViewController.delegate = self;
    }
    return _pageViewController;
}

- (NSMutableArray *)controllers{
    if (_controllers == nil) {
        _controllers = [NSMutableArray array];
        
        if ([self.vm isShiBan]) {
            AVItemTableViewController* inverstorVC = [[AVItemTableViewController alloc] initWithVM:self.vm cellIdentity:@"InvestorTableViewCell" storyBoardIndentity:@"AVItemTableViewController" parentTableView:self.tableView];
            [_controllers addObject:inverstorVC];
        }
        
        AVItemTableViewController* avInfoVC = [[AVItemTableViewController alloc] initWithVM:self.vm cellIdentity:@"textCell" storyBoardIndentity:@"AVItemTableViewController" parentTableView:self.tableView];
        [_controllers addObject:avInfoVC];
        
        AVItemTableViewController* sameVideoVC = [[AVItemTableViewController alloc] initWithVM:self.vm cellIdentity:@"SameVideoTableViewCell" storyBoardIndentity:@"AVItemTableViewController"  parentTableView:self.tableView];
        [_controllers addObject:sameVideoVC];
        
        AVItemTableViewController* replyVC = [[AVItemTableViewController alloc] initWithVM:self.vm cellIdentity:@"ReViewTableViewCell" storyBoardIndentity:@"AVItemTableViewController"  parentTableView:self.tableView];
        //添加脚部刷新
        replyVC.tableView.mj_footer = [MyRefreshComplete myRefreshFoot:^{
            [self.vm getMoveReplyCompleteHandle:^(NSError *error) {
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

- (UIImageView *)imgView{
    if (_imgView == nil) {
        _imgView = [[UIImageView alloc] init];
        [self.tableView.tableHeaderView addSubview: _imgView];
        [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(72);
            make.width.mas_equalTo(117);
            make.top.left.mas_offset(EDGE);
        }];
    }
    return _imgView;
}

- (UILabel *)UPLabel{
    if (_UPLabel == nil) {
        _UPLabel = [[UILabel alloc] init];
        _UPLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _UPLabel.font = [UIFont systemFontOfSize:13];
        [self.tableView.tableHeaderView addSubview: _UPLabel];
        __weak typeof(self) weakObj = self;
        [_UPLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakObj.imgView);
            make.top.mas_equalTo(weakObj.imgView.mas_bottom);
            make.height.equalTo(@[weakObj.playNumLabel,weakObj.danMuNumLabel,weakObj.publicTimeLabel]);
        }];
    }
    return _UPLabel;
}


- (UILabel *)playNumLabel{
    if (_playNumLabel == nil) {
        _playNumLabel = [[UILabel alloc] init];
        _playNumLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _playNumLabel.font = [UIFont systemFontOfSize:13];
        __weak typeof(self) weakObj = self;
        [self.tableView.tableHeaderView addSubview: _playNumLabel];
        [_playNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakObj.imgView);
            make.top.mas_equalTo(weakObj.UPLabel.mas_bottom);
        }];
    }
    return _playNumLabel;
}

- (UILabel *)danMuNumLabel{
    if (_danMuNumLabel == nil) {
        _danMuNumLabel = [[UILabel alloc] init];
        _danMuNumLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _danMuNumLabel.font = [UIFont systemFontOfSize:13];
        __weak typeof(self) weakObj = self;
        [self.tableView.tableHeaderView addSubview: _danMuNumLabel];
        [_danMuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakObj.playNumLabel.mas_right).mas_offset(EDGE);
            make.top.equalTo(weakObj.playNumLabel);
        }];
    }
    return _danMuNumLabel;
}

- (UILabel *)publicTimeLabel{
    if (_publicTimeLabel == nil) {
        _publicTimeLabel = [[UILabel alloc] init];
        _publicTimeLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _publicTimeLabel.font = [UIFont systemFontOfSize:13];
        __weak typeof(self) weakObj = self;
        [self.tableView.tableHeaderView addSubview: _publicTimeLabel];
        [_publicTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakObj.playNumLabel.mas_left);
            make.top.mas_equalTo(weakObj.playNumLabel.mas_bottom);
            make.bottom.mas_offset(-EDGE);
        }];
    }
    return _publicTimeLabel;
}

- (UILabel *)titleLabel{
    if (_titleLabel == nil) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.numberOfLines = 2;
        _titleLabel.lineBreakMode = NSLineBreakByClipping;
        _titleLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self.tableView.tableHeaderView addSubview: _titleLabel];
        __weak typeof(self) weakObj = self;
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(weakObj.imgView.mas_right).mas_offset(EDGE);
            make.right.mas_offset(-EDGE);
            make.top.equalTo(weakObj.imgView);
        }];
    }
    return _titleLabel;
}

- (UIButton *)playButton{
    if (_playButton == nil) {
        _playButton = [[UIButton alloc] init];
        _playButton.layer.cornerRadius = 5;
        _playButton.titleLabel.font = [UIFont systemFontOfSize: 13];
        [_playButton bk_addEventHandler:^(id sender) {
            VideoViewController* vc = [[VideoViewController alloc] initWithAid:[self.vm videoAid]];
            
           // [self.navigationController pushViewController:vc animated:YES];
            [self presentViewController:vc animated:YES completion:nil];
            
        } forControlEvents:UIControlEventTouchUpInside];
        [_playButton setBackgroundColor:[[ColorManager shareColorManager] colorWithString:@"themeColor"]];
        [self.tableView.tableHeaderView addSubview: _playButton];
        __weak typeof(self) weakObj = self;
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(71);
            make.height.mas_equalTo(37);
            make.bottom.right.mas_equalTo(weakObj.tableView.tableHeaderView).mas_offset(-EDGE);
        }];
    }
    return _playButton;
}





#pragma mark - JHViewController

- (void)JHViewGetOffset:(CGPoint)offset{
    [self.menuView slideMenuAtProgress: offset.x / self.menuView.frame.size.width];
}

#pragma mark - WMMenuView
- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return self.view.frame.size.width / ([self.vm isShiBan]?4:3);
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

- (void)colorSetting{
    self.tableView.tableHeaderView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"AVInfoViewController.headView.backgroundColor"];
    self.titleLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    self.tableView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"backgroundColor"];
}


@end
