//
//  RecommendViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendViewController.h"
#import "CellItemViewController.h"
#import "CellView.h"
#import "RecommendViewModel.h"
#import "ScrollDisplayViewController.h"
#import "WebViewController.h"
#import "UIView+Tools.h"
#import "AVInfoViewController.h"
@interface RecommendViewController ()<UITableViewDataSource, UITableViewDelegate,iCarouselDelegate, iCarouselDataSource>
@property (nonatomic, strong) RecommendViewModel* vm;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
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


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.tableView.header endRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //滚动视图大小
    [self.headView changeHeight:kWindowW / 2];
    [self.headView addSubview: self.headScrollView];
    [self.headScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    
    self.tableView.header = [MyRefreshHeader myRefreshHead:^{
        [self.vm refreshDataCompleteHandle:^(NSError *error) {
            [self.tableView.header endRefreshing];
            
            [self.headScrollView reloadData];
            
            [self.tableView reloadData];
            if (error) {
                [self showErrorMsg:error.localizedDescription];
            }
            
        }];
    }];
    
    [self.tableView.header beginRefreshing];
}

#define EDGE 10 //单元格间距
- (void)makeConstraintsWithViews:(NSMutableArray <UIViewController*>*)views cell:(CellView*)cell{
    UIView* v1 = views[0].view;
    UIView* v2 = views[1].view;
    UIView* v3 = views[2].view;
    UIView* v4 = views[3].view;
    [v1 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.titleImg.mas_bottom).mas_offset(EDGE);
        make.left.mas_offset(EDGE);
        make.size.equalTo(@[v2,v3,v4]);
        make.bottom.equalTo(v3.mas_top).mas_offset(-EDGE);
    }];
    [v2 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v1.mas_top);
        make.left.equalTo(v1.mas_right).mas_offset(EDGE);
        make.bottom.equalTo(v1.mas_bottom);
        make.right.mas_offset(-EDGE);
    }];
    [v3 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v1.mas_left);
        make.bottom.mas_offset(-50);
    }];
    [v4 mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(v3.mas_right).mas_offset(EDGE);
        make.right.mas_offset(-EDGE);
        make.bottom.equalTo(v3.mas_bottom);
    }];
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
    NSDictionary* dic = self.vm.dicMap[indexPath.section];
    NSString* key = [dic allKeys].firstObject;
    //设置分区内容
    [cell setTitle: key titleImg:[NSString stringWithFormat:@"home_region_icon_%@",[dic[key] componentsSeparatedByString:@"-"].firstObject] buttonTitle:[@"更多" stringByAppendingString:key]];
    
    if (self.vm.list[dic[key]]) {
        if (![cell.contentView viewWithTag:101]) {
            NSMutableArray* itemArr = [NSMutableArray new];
            for (int i = 0; i < 4; ++i) {
                CellItemViewController* cvc = [kStoryboard(@"Main") instantiateViewControllerWithIdentifier:@"CellItemViewController"];
                
                cvc.view.tag = 100 + i;
                
                [cvc setViewContentWithImgURL:[self.vm picForRow:i section:dic[key]] playNum:[self.vm playForRow:i section:dic[key]] replyNum:[self.vm danMuCountForRow:i section:dic[key]] title:[self.vm titleForRow:i section:dic[key]] section:dic[key] ind:i];
                //传值
                [cvc pushAVInfoViewController:^() {
                    AVInfoViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AVInfoViewController"];
                    [vc setWithModel: self.vm.list[dic[key]][i]];
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }];
                
                [itemArr addObject: cvc];
                
                [self addChildViewController: cvc];
                [cell.contentView addSubview: cvc.view];
            }
            [self makeConstraintsWithViews:itemArr cell:cell];
            //重用判断
        }else{
            NSArray* conArr = self.childViewControllers;
            for (int i = 0; i < 4; ++i) {
                UIView* iv = [cell viewWithTag:100 + i];
                for (CellItemViewController* cvc in conArr) {
                    if (iv == cvc.view) {
                        
                        [cvc setViewContentWithImgURL:[self.vm picForRow:i section:dic[key]] playNum:[self.vm playForRow:i section:dic[key]] replyNum:[self.vm danMuCountForRow:i section:dic[key]] title:[self.vm titleForRow:i section:dic[key]] section:dic[key] ind:i];
                        
                        [cvc pushAVInfoViewController:^() {
                            AVInfoViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AVInfoViewController"];
                            
                            [vc setWithModel: self.vm.list[dic[key]][i]];
                            
                            [self.navigationController pushViewController:vc animated:YES];
                        }];
                    }
                }
            }
        }
    }
    return cell;
}




- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    640*735
    return kWindowW / 640 * 735;
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

@end
