//
//  RecommendViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "RecommendViewController.h"
//#import "CellItemViewController.h"
#import "CellView.h"
#import "TakeHeadTableView.h"
#import "RecommendViewModel.h"
#import "WebViewController.h"
#import "UIView+Tools.h"
#import "AVInfoViewController.h"
@interface RecommendViewController ()<UITableViewDataSource, UITableViewDelegate,iCarouselDelegate, iCarouselDataSource>
@property (nonatomic, strong) RecommendViewModel* vm;
@property (strong, nonatomic) TakeHeadTableView *tableView;
@property (nonatomic, strong) iCarousel* headScrollView;

@end

@implementation RecommendViewController

kRemoveCellSeparator

- (RecommendViewModel *)vm{
    if (_vm == nil) {
        _vm = [[RecommendViewModel alloc] init];
    }
    return _vm;
}

- (TakeHeadTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[TakeHeadTableView alloc] init];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.allowsSelection = NO;
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    __weak typeof(self) weakObj = self;
    

    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakObj.view);
    }];
    
    [self.tableView.tableHeaderView addSubview: self.headScrollView];
    [self.headScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.mj_header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [weakObj.tableView.mj_header endRefreshing];
            
            [weakObj.headScrollView reloadData];
            
            [weakObj.tableView reloadData];
            if (error) {
                [self showErrorMsg:kerrorMessage];
            }
            
        }];
    }];
    
    [self.tableView.mj_header beginRefreshing];
}


# pragma mark - tableViewController



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //return 0;
  //  NSLog(@"%ld", [self.vm sectionCount]);
    return [self.vm sectionCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CellView* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.contentView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"CellView.contentView.backgroundColor"];
    
    NSDictionary* dic = self.vm.dicMap[indexPath.section];
    NSString* key = [dic allKeys].firstObject;
    //设置分区内容
    
    NSDictionary* tempDic = @{@"titleLabel.text":[NSMutableArray array],@"playLabel.text":[NSMutableArray array],@"danMuLabel.text":[NSMutableArray array],@"imgv":[NSMutableArray array],@"dataModel":[NSMutableArray array],@"navController":self.parentViewController.navigationController,@"section":dic[key]};
    if (self.vm.list[dic[key]]) {
        for (int i = 0; i < 4; ++i) {
            
            [tempDic[@"imgv"] addObject:[self.vm picForRow:i section:dic[key]]];
            [tempDic[@"titleLabel.text"] addObject:[self.vm titleForRow:i section:dic[key]]];
            [tempDic[@"playLabel.text"] addObject:[self.vm playForRow:i section:dic[key]]];
            [tempDic[@"danMuLabel.text"] addObject:[self.vm danMuCountForRow:i section:dic[key]]];
            [tempDic[@"dataModel"] addObject:[self.vm AVDataModelForRow:i section:dic[key]]];
        }
        
        [cell setTitle:key titleImg:[NSString stringWithFormat:@"home_region_icon_%@",[dic[key] componentsSeparatedByString:@"-"].firstObject] buttonTitle:[@"更多" stringByAppendingString:key] dic:tempDic];
    }
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

#pragma mark - icarouse

- (iCarousel *)headScrollView{
    if (_headScrollView == nil) {
        _headScrollView = [[iCarousel alloc] init];
        _headScrollView.delegate = self;
        _headScrollView.dataSource = self;
        _headScrollView.type = iCarouselTypeInvertedCylinder;
        _headScrollView.pagingEnabled = YES;
        //手动滚动速度
        _headScrollView.scrollSpeed = 2;
        [NSTimer bk_scheduledTimerWithTimeInterval:2.5 block:^(NSTimer *timer) {
            [_headScrollView scrollToItemAtIndex:_headScrollView.currentItemIndex + 1 animated:YES];
        } repeats:YES];
    }
    return _headScrollView;
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel{
    return [self.vm numberOfHeadImg];
}
- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(nullable UIImageView *)view{
    if (view == nil) {
        view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowW / 2)];
    }
    [view setImageWithURL:[self.vm headImgURL:index]];
    return view;
}
//滚动视图跳转
- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index{
    WebViewController* wbc = [[WebViewController alloc] init];
    wbc.URL = [self.vm headImgLink:index];
    [self.navigationController pushViewController:wbc animated:YES];
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value{
    return value;
}

- (void)colorSetting{
    [self.tableView reloadData];
}

@end
