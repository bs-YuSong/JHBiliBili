//
//  FindViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/31.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "FindViewController.h"
#import "FindViewModel.h"
#import "UIImage+Tools.h"
@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allSectionSortButtonCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgCon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, strong) FindViewModel* vm;

@property (nonatomic, strong) UIImage* upImg;
@property (nonatomic, strong) UIImage* downImg;
@property (nonatomic, strong) UIImage* keepImg;
@end

@implementation FindViewController

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //全区排行按钮
    self.allSectionSortButtonCon.constant = (kWindowW - 30) / 2 / 2.12;
    //左边图片按钮
    self.leftImgCon.constant = (kWindowW - 30) / 2 / 1.68;
    
    MJRefreshNormalHeader* header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self.vm refreshDataCompleteHandle:^(NSError *error) {
           [self.tableView.header endRefreshing];
           [self.tableView reloadData];
           if (error) {
               [self showErrorMsg: error.localizedDescription];
           }
       }];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setTitle:@"再拉，再拉就刷新给你看" forState:MJRefreshStateIdle];
    [header setTitle:@"够了啦，松开人家嘛" forState:MJRefreshStatePulling];
    [header setTitle:@"刷呀刷，好累啊，喵(＾▽＾)" forState:MJRefreshStateRefreshing];
    self.tableView.header = header;
    [self.tableView.header beginRefreshing];
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
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"fvcell"];
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@(indexPath.row + 1).stringValue];
    if (indexPath.row <= 2) {
        [str setAttributes:@{NSForegroundColorAttributeName:kRGBColor(248, 116, 153)} range:NSMakeRange(0, str.length)];
    }
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"\t%@",[self.vm keyWordForRow: indexPath.row]]]];
    [cell.textLabel setAttributedText: str];
    
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 7, 10)];
    //设置排行榜图片
    [imgView setImage: @{@"keep":self.keepImg, @"up":self.upImg, @"down":self.downImg}[[self.vm statusWordForRow:indexPath.row]]];
    cell.accessoryView = imgView;
    return cell;
}

# pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
