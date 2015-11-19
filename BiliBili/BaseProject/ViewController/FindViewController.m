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
#import "UIView+Tools.h"
@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (nonatomic, strong) FindViewModel* vm;
@property (weak, nonatomic) IBOutlet UIButton *allSectionRangeButton;
@property (weak, nonatomic) IBOutlet UIImageView *hotSearchLeftImgView;
@property (weak, nonatomic) IBOutlet UIImageView *hotSearchRightImgView;
@property (weak, nonatomic) IBOutlet UIView *hotSearchBottomBlackView;
@property (weak, nonatomic) IBOutlet UILabel *hotSearchLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotSearchRightLabel;


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
    //顶部视图高
    [self.headView changeHeight: kWindowW * 0.7];
    
    //全区排行按钮
    [self.allSectionRangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.allSectionRangeButton.mas_width).multipliedBy(0.47);
    }];
    //左边图片按钮
    [self.hotSearchLeftImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.hotSearchLeftImgView.mas_width).multipliedBy(0.63);
    }];
    [self.hotSearchBottomBlackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.hotSearchLeftImgView.mas_height).multipliedBy(1.0/4);
    }];
    
    self.tableView.header = [MyRefreshHeader myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.header endRefreshing];
            [self.hotSearchLeftImgView setImageWithURL: [self.vm rankCoverForNum:0]];
            [self.hotSearchRightImgView setImageWithURL: [self.vm rankCoverForNum:1]];
            self.hotSearchLeftLabel.text = [self.vm coverKeyWordForNum:0];
            self.hotSearchRightLabel.text = [self.vm coverKeyWordForNum:1];
            [self.tableView reloadData];
            if (error) {
                [self showErrorMsg: kerrorMessage];
            }
        }];
    }];

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
        [str setAttributes:@{NSForegroundColorAttributeName:kGloableColor} range:NSMakeRange(0, str.length)];
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
