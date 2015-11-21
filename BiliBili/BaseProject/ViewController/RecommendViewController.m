//
//  RecommendViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendViewController.h"
//#import "CellItemViewController.h"
#import "CellView.h"
#import "RecommendTableView.h"
#import "RecommendViewModel.h"
#import "ScrollDisplayViewController.h"
#import "WebViewController.h"
#import "UIView+Tools.h"
#import "AVInfoViewController.h"
@interface RecommendViewController ()<UITableViewDataSource, UITableViewDelegate,iCarouselDelegate, iCarouselDataSource>
@property (nonatomic, strong) RecommendViewModel* vm;
//@property (weak, nonatomic) IBOutlet UIView *headView;
//@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) RecommendTableView *tableView;
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

- (RecommendTableView *)tableView{
    if (_tableView == nil) {
        _tableView = [[RecommendTableView alloc] init];
        _tableView.delegate =self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self) weakObj = self;

    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakObj.view);
    }];
    
    self.headScrollView.frame = self.tableView.tableHeaderView.frame;
    self.tableView.tableHeaderView = self.headScrollView;
//    [self.tableView.tableHeaderView addSubview: self.headScrollView];
//    [self.headScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.mas_equalTo(0);
//    }];
    
    self.tableView.header = [MyRefreshComplete myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [weakObj.tableView.header endRefreshing];
            
           // [weakObj.headScrollView reloadData];
            
            [weakObj.tableView reloadData];
            if (error) {
                [self showErrorMsg:kerrorMessage];
            }
            
        }];
    }];
    
    [self.tableView.header beginRefreshing];
}


# pragma mark - tableViewController



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.vm sectionCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    CellView* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[CellView alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
//        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.contentView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"CellView.contentView.backgroundColor"];
    
    NSDictionary* dic = self.vm.dicMap[indexPath.section];
    NSString* key = [dic allKeys].firstObject;
    //设置分区内容
    
    NSDictionary* tempDic = @{@"titleLabel.text":[NSMutableArray array],@"playLabel.text":[NSMutableArray array],@"danMuLabel.text":[NSMutableArray array],@"imgv":[NSMutableArray array]};
    for (int i = 0; i < 4; ++i) {
        [tempDic[@"imgv"] addObject:[self.vm picForRow:i section:dic[key]]];
        [tempDic[@"titleLabel.text"] addObject:[self.vm titleForRow:i section:dic[key]]];
        [tempDic[@"playLabel.text"] addObject:[self.vm playForRow:i section:dic[key]]];
        [tempDic[@"danMuLabel.text"] addObject:[self.vm danMuCountForRow:i section:dic[key]]];
    }
    
    [cell setTitle:key titleImg:[NSString stringWithFormat:@"home_region_icon_%@",[dic[key] componentsSeparatedByString:@"-"].firstObject] buttonTitle:[@"更多" stringByAppendingString:key] dic:tempDic];
    
   /* //视频缩略图
    [self.imgv setImageWithURL: URL];
    [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.imgv.mas_width).multipliedBy(0.63);
    }];
    self.imgv.layer.cornerRadius = 8;
    self.imgv.layer.masksToBounds = YES;
    //视频标题
    self.label.text = title;
    //小图标
    self.playIcon.tintColor = kRGBColor(182, 182, 182);
    self.playIcon.image = [self.playIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.replyIcon.tintColor = kRGBColor(182, 182, 182);
    self.replyIcon.image = [self.replyIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.playLabel.text = playNum;
    self.replyLabel.text = replyNum;
    
    self.section = section;
    self.ind = ind;
    */
//    self.title.text = title;
//    //图片文件名 home_region_icon_分区名
//    [self.titleImg setImage:[UIImage imageNamed: titleimg]];
//    [self.moreButton setTitle:[@"更多" stringByAppendingString: title] forState:UIControlStateNormal];
//    self.enterView.layer.cornerRadius = self.enterView.frame.size.width / 2;
//    self.enterView.layer.masksToBounds = YES;
//    if (self.vm.list[dic[key]]) {
//        __block typeof(self) weakObj = self;
//        if (![cell.contentView viewWithTag:101]) {
//            NSMutableArray* itemArr = [NSMutableArray new];
//            for (int i = 0; i < 4; ++i) {
//                CellItemViewController* cvc = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"CellItemViewController"];
//                
//                cvc.view.tag = 100 + i;
//                
//                [cvc setViewContentWithImgURL:[self.vm picForRow:i section:dic[key]] playNum:[self.vm playForRow:i section:dic[key]] replyNum:[self.vm danMuCountForRow:i section:dic[key]] title:[self.vm titleForRow:i section:dic[key]] section:dic[key] ind:i];
//                //传值
//                
//                [cvc pushAVInfoViewController:^() {
//                    __weak AVInfoViewController* vc = [weakObj.storyboard instantiateViewControllerWithIdentifier:@"AVInfoViewController"];
//                    [vc setWithModel: weakObj.vm.list[dic[key]][i] section:dic[key]];
//                    
//                    [weakObj.navigationController pushViewController:vc animated:YES];
//                }];
//                
//                [itemArr addObject: cvc];
//                
//                [self addChildViewController: cvc];
//                [cell.contentView addSubview: cvc.view];
//            }
//            [self makeConstraintsWithViews:itemArr cell:cell];
//            //重用判断
//        }else{
//            NSArray* conArr = self.childViewControllers;
//            for (int i = 0; i < 4; ++i) {
//                UIView* iv = [cell viewWithTag:100 + i];
//                for (CellItemViewController* cvc in conArr) {
//                    if (iv == cvc.view) {
//                        
//                        [cvc setViewContentWithImgURL:[self.vm picForRow:i section:dic[key]] playNum:[self.vm playForRow:i section:dic[key]] replyNum:[self.vm danMuCountForRow:i section:dic[key]] title:[self.vm titleForRow:i section:dic[key]] section:dic[key] ind:i];
//                        
//                        [cvc pushAVInfoViewController:^() {
//                             __weak AVInfoViewController* vc = [weakObj.storyboard instantiateViewControllerWithIdentifier:@"AVInfoViewController"];
//                            
//                            [vc setWithModel: weakObj.vm.list[dic[key]][i] section:dic[key]];
//                            
//                            [weakObj.navigationController pushViewController:vc animated:YES];
//                        }];
//                    }
//                }
//            }
//        }
//    }
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    850/1280
    return kWindowH * 850 / 1280;
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
    [view sd_setImageWithURL: [self.vm headImgURL:index]];
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
