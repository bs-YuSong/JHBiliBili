//
//  AVInfoViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/1.
//  Copyright © 2015年 Tarena. All rights reserved.
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

#define MENEVIEWHEIGHT 40

#define MAXOFFSET self.headView.frame.size.height

#define MINOFFSET 0

#define TOPVALUE

@interface AVInfoViewController ()<UITableViewDelegate,UITableViewDataSource,WMMenuViewDelegate,JHViewControllerDelegate>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//up名
@property (weak, nonatomic) IBOutlet UILabel *UPLabel;
//视频缩略图
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//播放数
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
//弹幕数
@property (weak, nonatomic) IBOutlet UILabel *danMuLabel;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *publicTimeLabel;
//视频标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//播放按钮
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, strong) AVInfoViewModel* vm;

@property (nonatomic, strong) JHViewController* pageViewController;

@property (nonatomic, strong) NSMutableArray<AVItemTableViewController*>* controllers;
@property (nonatomic, strong) WMMenuView* menuView;
@property (nonatomic, strong) NSValue* topFrame;

@end

@implementation AVInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化属性
    [self setProperty];
    __block typeof(self) weakObj = self;
    self.tableView.header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [weakObj.tableView.header endRefreshing];
            [weakObj.tableView reloadData];
            for (UITableViewController* c in weakObj.controllers) {
                [c.tableView reloadData];
            }
            if (error) {
                [self showErrorMsg: kerrorMessage];
            }
        }];
    }];
    [self.tableView.header beginRefreshing];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
}


#pragma mark - tableViewController
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"avInfoCell"];
    cell.backgroundColor = [UIColor grayColor];
    UIView* v =  [cell viewWithTag: 100];
    if (v == nil) {
        self.pageViewController.view.tag = 100;
        [cell.contentView addSubview: self.pageViewController.view];
    }
    [self.pageViewController.view mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    NSMutableArray* arr = [@[@"视频详情",@"相关视频",[NSString stringWithFormat:@"评论(%ld)",(long)[self.vm allReply]]] mutableCopy];
    if ([self.vm isShiBan]) {
        [arr insertObject:@"承包商排行" atIndex:0];
    }
    
    WMMenuView* menuView = [[WMMenuView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 30) buttonItems:arr backgroundColor:[UIColor whiteColor] norSize:15 selSize:15 norColor:[UIColor blackColor] selColor:kGloableColor];
    menuView.delegate = self;
    menuView.style = WMMenuViewStyleLine;
    self.menuView = menuView;
    return menuView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MENEVIEWHEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWindowH - MAXOFFSET + self.topFrame.CGRectValue.size.height;
}


#pragma mark - 初始化属性
- (void)setWithModel:(AVDataModel*)model section:(NSString*)section{
    [self.vm setAVData:model section:section];
    self.navigationItem.title = [NSString stringWithFormat:@"av%@", model.aid];
}

- (void)setProperty{
    self.tableView.showsVerticalScrollIndicator = NO;
    
    self.playButton.layer.cornerRadius = 5;
    
    self.headView.frame = CGRectMake(0, 0, kWindowW, kWindowW * 0.4 + 20);
    
    self.tableView.tableFooterView = [UIView new];
    
    [self addChildViewController:self.pageViewController];
    
    __block typeof(self) weakObj = self;
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(weakObj.headView.mas_width).multipliedBy(0.33);
        make.height.mas_equalTo(weakObj.imgView.mas_width).multipliedBy(0.62);
    }];
    
    //设置up名
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"UP主："];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString: [self.vm infoUpName] attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:kGloableColor}]];
    [self.UPLabel setAttributedText:str];
    //播放数
    self.playNumLabel.text = [NSString stringWithFormat:@"播放：%@", [self.vm infoPlayNum]];
    //弹幕数
    self.danMuLabel.text = [NSString stringWithFormat:@"弹幕数：%@", [self.vm infoDanMuCount]];
    //创建时间
    self.publicTimeLabel.text = [NSString stringWithFormat:@"发布于：%@", [self.vm infoTime]];
    //图片URL
    [self.imgView setImageWithURL: [self.vm infoImgURL]];
    //标题
    self.titleLabel.text = [self.vm infoTitle];
}

- (void)setChildrenScrollEnabled{
    for (AVItemTableViewController* vc in self.controllers) {
        vc.tableView.scrollEnabled = YES;
    }
}


- (IBAction)pushVideoViewController:(UIButton *)sender {
    VideoViewController* vc = [[VideoViewController alloc] initWithAid:[self.vm videoAid]];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 懒加载
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
        replyVC.tableView.footer = [MyRefreshComplete myRefreshFoot:^{
           [self.vm getMoveReplyCompleteHandle:^(NSError *error) {
               [replyVC.tableView.footer endRefreshing];
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
        if(scrollView.contentOffset.y >= MAXOFFSET){
        scrollView.scrollEnabled = NO;
        [self setChildrenScrollEnabled];
    }
}
@end
