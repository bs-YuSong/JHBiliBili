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

#define MENEVIEWHEIGHT 40

#define MAXOFFSET self.headView.frame.size.height - [self.topLayoutGuide length]

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
@property (nonatomic, strong) UIPanGestureRecognizer* panGesture;
@property (nonatomic, strong) WMMenuView* menuView;
//@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation AVInfoViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    //初始化属性
    [self setProperty];
    self.tableView.header = [MyRefreshHeader myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.header endRefreshing];
            [self.tableView reloadData];
            for (UITableViewController* c in self.controllers) {
                [c.tableView reloadData];
            }
            if (error) {
                [self showErrorMsg:error.localizedDescription];
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
        [self.pageViewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(0);
        }];
    }
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WMMenuView* menuView = [[WMMenuView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 30) buttonItems:@[@"视频详情",@"相关视频",[NSString stringWithFormat:@"评论(%ld)",[self.vm allReply]]] backgroundColor:[UIColor whiteColor] norSize:15 selSize:15 norColor:[UIColor blackColor] selColor:kGloableColor];
    menuView.delegate = self;
    menuView.style = WMMenuViewStyleLine;
    self.menuView = menuView;
    return menuView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return MENEVIEWHEIGHT;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kWindowH - self.headView.frame.size.height + [self.topLayoutGuide length];
}


#pragma mark - 初始化属性
- (void)setWithModel:(AVDataModel*)model{
    self.vm.AVData = model;
    self.navigationItem.title = [NSString stringWithFormat:@"av%@", model.aid];
}

- (void)setProperty{
    [self.tableView addGestureRecognizer:self.panGesture];
    
    self.playButton.layer.cornerRadius = 5;
    
    self.headView.frame = CGRectMake(0, 0, kWindowW, kWindowW * 0.4 + 20);
    
    self.tableView.tableFooterView = [UIView new];
    
    [self addChildViewController:self.pageViewController];
    
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.headView.mas_width).multipliedBy(0.33);
        make.height.mas_equalTo(self.imgView.mas_width).multipliedBy(0.62);
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

- (void)startMove{
    CGPoint offset = [self.panGesture translationInView:nil];
   // NSLog(@"%lf,%lf", self.headView.frame.size.height - [self.topLayoutGuide length], self.tableView.contentOffset.y);
    //视图偏移值在0到顶视图高之间 或者isScrollEnabled为真时(用于偏移值正好是顶视图高时的临界值判断)可以滚动
    if ((self.tableView.contentOffset.y >=0 && self.tableView.contentOffset.y <= MAXOFFSET) || self.tableView.isScrollEnabled) {
        [self.tableView addContentOffsetY: -offset.y];
        self.tableView.scrollEnabled = NO;
        //视图偏移值大于顶视图高时 子视图可以滚动
    }else if(self.tableView.contentOffset.y > MAXOFFSET){
        CGPoint p = CGPointMake(0, MAXOFFSET);
        [self.tableView setContentOffset:p animated:YES];
        [self setChildrenScrollEnabled];
        [self.controllers[self.pageViewController.currentPage].tableView addContentOffsetY:-offset.y];
        //满足刷新条件
    }else if (self.tableView.contentOffset.y <= -54 && self.panGesture.state == UIGestureRecognizerStateEnded){
        [self.tableView.header endRefreshing];
        [self.tableView.header beginRefreshing];
        //不满足刷新条件
    }else if(self.tableView.contentOffset.y > -54 && self.panGesture.state == UIGestureRecognizerStateEnded){
        [self.tableView setContentOffset:CGPointZero animated:YES];
    }else{
        [self.tableView addContentOffsetY: -offset.y];
    }
    
    [self.panGesture setTranslation:CGPointZero inView: nil];
}

#pragma mark - 懒加载
- (AVInfoViewModel *)vm{
    if (_vm == nil) {
        _vm = [AVInfoViewModel new];
    }
    return _vm;
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
        AVItemTableViewController* avInfoVC = [[AVItemTableViewController alloc] initWithVM:self.vm cellIdentity:@"textCell" storyBoardIndentity:@"AVItemTableViewController" parentTableView:self.tableView];
        
        AVItemTableViewController* sameVideoVC = [[AVItemTableViewController alloc] initWithVM:self.vm cellIdentity:@"SameVideoTableViewCell" storyBoardIndentity:@"AVItemTableViewController"  parentTableView:self.tableView];
        
        AVItemTableViewController* replyVC = [[AVItemTableViewController alloc] initWithVM:self.vm cellIdentity:@"ReViewTableViewCell" storyBoardIndentity:@"AVItemTableViewController"  parentTableView:self.tableView];
        
        [_controllers addObject:avInfoVC];
        [_controllers addObject:sameVideoVC];
        [_controllers addObject:replyVC];
    }
    return _controllers;
}
//手势
- (UIPanGestureRecognizer *)panGesture{
    if (_panGesture == nil) {
        _panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(startMove)];
    }
    return _panGesture;
}


#pragma mark - JHViewController

- (void)JHViewGetOffset:(CGPoint)offset{
    [self.menuView slideMenuAtProgress: offset.x / self.menuView.frame.size.width];
}

#pragma mark - WMMenuView
- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index{
    return 100;
}
@end
