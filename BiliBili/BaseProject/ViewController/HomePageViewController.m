//
//  HomePageViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/31.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "HomePageViewController.h"
#import "WMMenuView.h"
#import "ProfileTableViewController.h"

#define MENUHEIGHT 35
#define MAXBLACKVIEWALPHA 0.5
#define BLACKVIEWSIZESCALE 0.75
@interface HomePageViewController ()<WMMenuViewDelegate, JHViewControllerDelegate>
@property (nonatomic, strong) WMMenuView* menuView;
@property (nonatomic, strong) UIPanGestureRecognizer* panG;
//侧边栏视图 用于判断触摸点是否在左侧
@property (nonatomic, strong) UIView* profileView;
//半透明黑色视图
@property (nonatomic, strong) UIView* blackView;
@end

@implementation HomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //UISwitch*s = [[UISwitch alloc] initWithFrame:self.view.frame];
   // [self.navigationController.view addSubview:s];
}

- (instancetype)initWithControllers:(NSArray *)controllers{
    if (self = [super initWithControllers:controllers]) {
        //顶部菜单视图
        [self.view addSubview: self.menuView];
        self.delegate = self;
        self.scrollView.bounces = NO;
        //重新指定滚动视图约束
        [self.scrollView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).mas_offset(MENUHEIGHT);
        }];
        //黑色半透明视图
        self.blackView = [[UIView alloc] initWithFrame:self.view.frame];
        self.blackView.backgroundColor = [UIColor blackColor];
        self.blackView.alpha = 0;
        __weak typeof(self) weakObj = self;
        [self.blackView addGestureRecognizer:[[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
            [weakObj profileViewMoveToOriginal];
        }]];
        [self.blackView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMove:)]];
        
        [self.view addSubview: self.blackView];
        
        //侧边栏手势
        UIView* panView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, self.view.frame.size.height)];
//        panView.backgroundColor = [UIColor redColor];
        [panView addGestureRecognizer:self.panG];
        [self.view addSubview: panView];
        
        //侧边栏
        CGRect rect = self.view.frame;
        rect.size.width =  rect.size.width *BLACKVIEWSIZESCALE;
        rect.origin.x = -rect.size.width;
        self.profileView = [[UIView alloc] initWithFrame:rect];

        ProfileTableViewController* tableVC = [[ProfileTableViewController alloc] initWithStyle:UITableViewStyleGrouped];
        [self.profileView addSubview: tableVC.tableView];
        [tableVC.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakObj.profileView);
        }];
        [self addChildViewController: tableVC];
        
        [self.profileView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMove:)]];
        [self.view addSubview: self.profileView];
        
        
        
    }
    return self;
}

- (WMMenuView *)menuView{
    if (_menuView == nil) {
        _menuView = [[WMMenuView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, MENUHEIGHT) buttonItems:@[@"番剧",@"推荐",@"发现"] backgroundColor:[[ColorManager shareColorManager] colorWithString:@"themeColor"] norSize:15 selSize:15 norColor:[UIColor whiteColor] selColor:[UIColor whiteColor]];
        _menuView.delegate = self;
        _menuView.style = WMMenuViewStyleLine;
    }
    return _menuView;
}
#pragma mark - JHViewController
- (void)JHViewGetOffset:(CGPoint)offset{
    [self.menuView slideMenuAtProgress:offset.x / self.menuView.frame.size.width];
}

#pragma mark - WMMenuView
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex{
    [self setScrollViewPage:index];
}

- (UIPanGestureRecognizer *)panG{
    if (_panG == nil) {
        _panG = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panMove:)];
    }
    return _panG;
}

- (void)panMove:(UIPanGestureRecognizer*)sender{
    
    //每次移动的值
    CGFloat moveValue = [sender translationInView:nil].x;
    //侧边栏新的位置
    CGRect newPosition = self.profileView.frame;
    if (newPosition.origin.x < 0 || (newPosition.origin.x == 0 && [sender velocityInView:nil].x < 0)) {
        newPosition.origin.x += moveValue * BLACKVIEWSIZESCALE;
        self.profileView.frame = newPosition;
        //黑色视图透明值
        CGFloat blackViewAlpha = MAXBLACKVIEWALPHA + (newPosition.origin.x / newPosition.size.width) * MAXBLACKVIEWALPHA;
        self.blackView.alpha = blackViewAlpha;
    //视图偏移值超过最大值的时候
    }else{
        [self profileViewMoveToDestination];
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        //如果视图停留在超过视图一半宽的位置或者速度超过800 自动移动到指定位置
        if([sender velocityInView:nil].x > 800 || newPosition.origin.x > -newPosition.size.width / 2)
        {
            [self profileViewMoveToDestination];
        }else{
            [self profileViewMoveToOriginal];
        }
    }
    [sender setTranslation:CGPointZero inView:nil];
   // NSLog(@"%lf", [sender velocityInView:nil].x);
}

/** 侧边栏视图移动到目的地位置*/
- (void)profileViewMoveToDestination{
    CGRect destination = CGRectMake(0, 0, self.profileView.frame.size.width, self.profileView.frame.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        [self.profileView setFrame: destination];
        self.blackView.alpha = MAXBLACKVIEWALPHA;
    }];
}
/** 侧边栏视图移动到初始位置*/
- (void)profileViewMoveToOriginal{
    CGRect destination = CGRectMake(-self.profileView.frame.size.width, 0, self.profileView.frame.size.width, self.profileView.frame.size.height);
    [UIView animateWithDuration:0.25 animations:^{
        [self.profileView setFrame: destination];
        self.blackView.alpha = 0;
    }];
}

- (void)colorSetting{
    self.view.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"HomePageViewController.view.backgroundColor"];
    self.menuView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"themeColor"];
    self.menuView.lineColor = [[ColorManager shareColorManager] colorWithString:@"HomePageViewController.menuView.lineColor"];
    self.navigationController.navigationBar.barTintColor = [[ColorManager shareColorManager] colorWithString:@"themeColor"];
}
@end
