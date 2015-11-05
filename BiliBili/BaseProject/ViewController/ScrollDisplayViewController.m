//
//  ScrollDisplayViewController.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ScrollDisplayViewController.h"

@interface ScrollDisplayViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>

@end

@implementation ScrollDisplayViewController

//传入图片地址数组
- (instancetype)initWithImgPaths:(NSArray *)paths{
//路径中可能的类型：NSURL,Http://,https:// ,本地路径：file://
    NSMutableArray *arr=[NSMutableArray new];
    for (int i=0; i < paths.count; i++) {
        id path = paths[i];
//        UIImageView *imageView=[UIImageView new];
//为了监控用户点击操作
        UIButton *btn=[UIButton buttonWithType:0];
        if ([self isURL:path]) {
            [btn sd_setBackgroundImageWithURL:path forState:0];
//            [imageView sd_setImageWithURL:path];
        }else if([self isNetPath:path]){
            NSURL *url=[NSURL URLWithString:path];
//            [imageView sd_setImageWithURL:url];
            [btn sd_setBackgroundImageWithURL:url forState:0];
        }else if([path isKindOfClass:[NSString class]]){
//          本地地址
            NSURL *url=[NSURL fileURLWithPath:path];
//            [imageView sd_setImageWithURL:url];
            [btn sd_setBackgroundImageWithURL:url forState:0];
        }else{
//         这里可以给imageView 设置一个裂开的本地图片
            [btn setImage:[UIImage imageNamed:@"error@3x"] forState:0];
//            imageView.image =[UIImage imageNamed:@"error@3x"];
        }
        UIViewController *vc=[UIViewController new];
        vc.view = btn;
        btn.tag = 1000 +i;
        [btn bk_addEventHandler:^(UIButton *sender) {
            [self.delegate scrollDisplayViewController:self didSelectedIndex:sender.tag-1000];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [arr addObject:vc];
    }
    self = [self initWithControllers:arr];
    return self;
}

- (BOOL)isURL:(id)path{
    return [path isKindOfClass:[NSURL class]];
}
- (BOOL)isNetPath:(id)path{ //判断是否是网络路径
// http://   https://
    BOOL isStr=[path isKindOfClass:[NSString class]];
//为了防止非String类型调用下方崩溃
    if (!isStr) {
        return NO;
    }
    BOOL containHttp=[path rangeOfString:@"http"].location != NSNotFound;
    BOOL containTile=[path rangeOfString:@"://"].location != NSNotFound;
    return isStr && containHttp && containTile;
}

//传入图片名字数组
- (instancetype)initWithImgNames:(NSArray *)names{
    //图片名字->Image->imageView->ViewController
    NSMutableArray *arr =[NSMutableArray new];
    for (int i=0; i < names.count; i++) {
        UIImage *img =[UIImage imageNamed:names[i]];
//        UIImageView *iv=[[UIImageView alloc] initWithImage:img];
        UIButton *btn=[UIButton buttonWithType:0];
        [btn setBackgroundImage:img forState:0];
        UIViewController *vc=[UIViewController new];
        vc.view = btn;
        btn.tag = 1000 + i;
        [btn bk_addEventHandler:^(UIButton *sender) {
            [self.delegate scrollDisplayViewController:self didSelectedIndex:sender.tag -1000];
        } forControlEvents:UIControlEventTouchUpInside];
        
        [arr addObject:vc];
    }
    if (self=[self initWithControllers:arr]) {
    }
    return self;
}
//传入视图控制器
- (instancetype)initWithControllers:(NSArray *)controllers{
    if (self = [super init]) {
        //为了防止实参是可变数组，需要复制一份出来。 这样可以保证属性不会因为可变数组在外部被修改，而导致随之也修改了
        _controllers = [controllers copy];
        
        _autoCycle = YES;
        _canCycle = YES;
        _showPageControl = YES;
        _duration = 3;
        _pageControlOffset = 0;
    }
    return self;
}
- (void)setShowPageControl:(BOOL)showPageControl{
    _showPageControl = showPageControl;
    _pageControl.hidden = !showPageControl;
}
- (void)setDuration:(NSTimeInterval)duration{
    _duration = duration;
    self.autoCycle = _autoCycle;
}
- (void)setPageControlOffset:(CGFloat)pageControlOffset{
    _pageControlOffset = pageControlOffset;
//更新页面数量控件 bottom 约束
    [_pageControl mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_pageControlOffset);
    }];
}
-(void)setCurrentPage:(NSInteger)currentPage{
    _currentPage = currentPage;
    UIViewController *vc=_controllers[currentPage];
    [_pageVC setViewControllers:@[vc] direction:0 animated:YES completion:nil];
}


- (void)setAutoCycle:(BOOL)autoCycle{
    _autoCycle = autoCycle;
    [_timer invalidate];
    if (!autoCycle) { //如果为NO
        return;
    }
    _timer = [NSTimer bk_scheduledTimerWithTimeInterval:_duration block:^(NSTimer *timer) {
        UIViewController *vc=_pageVC.viewControllers.firstObject;
        NSInteger index=[_controllers indexOfObject:vc];
        UIViewController *nextVC = nil;
        if (index == _controllers.count -1) {
            if (!_canCycle) {
                return;
            }
            nextVC = _controllers.firstObject;
        }else{
            nextVC = _controllers[index +1];
        }
        __block ScrollDisplayViewController *vc1= self;
        [_pageVC setViewControllers:@[nextVC] direction:0 animated:YES completion:^(BOOL finished) {
            //DDLogVerbose(@"%@", [NSThread currentThread]);
            [vc1 configPageControl];
        }];
    } repeats:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//如果 控制器数组 为空 或者 什么都没有
    if (!_controllers || _controllers.count == 0) {
        return;
    }
    _pageVC=[[UIPageViewController alloc] initWithTransitionStyle:1 navigationOrientation:0 options:nil];
    _pageVC.delegate = self;
    _pageVC.dataSource = self;
    [self addChildViewController:_pageVC];
    [self.view addSubview:_pageVC.view];
//需要使用pod 引入 Masonry 第三方类库
    [_pageVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    [_pageVC setViewControllers:@[_controllers.firstObject] direction:0 animated:YES completion:nil];
    
    _pageControl=[UIPageControl new];
    _pageControl.numberOfPages = _controllers.count;
    [self.view addSubview:_pageControl];
    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.bottom.mas_equalTo(0);
    }];
    _pageControl.userInteractionEnabled = NO;
    
    self.autoCycle = _autoCycle;
    self.showPageControl = _showPageControl;
    self.pageControlOffset = _pageControlOffset;
    
    
}
- (void)configPageControl{ //操作圆点位置
    NSInteger index=[_controllers indexOfObject:_pageVC.viewControllers.firstObject];
    _pageControl.currentPage = index;
}


#pragma mark - UIPageViewController
- (void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed{
    if (completed && finished) {
        [self configPageControl];
        NSInteger index=[_controllers indexOfObject: pageViewController.viewControllers.firstObject];
//respondsToSelector可以判断 某个对象是否含有某个方法
        if ([self.delegate respondsToSelector:@selector(scrollDisplayViewController:currentIndex:)] ) {
        [self.delegate scrollDisplayViewController:self currentIndex:index];
        }

    }
}

- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index=[_controllers indexOfObject:viewController];
    if (index == 0) {
        return _canCycle?_controllers.lastObject:nil;
    }
    return _controllers[index -1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index=[_controllers indexOfObject:viewController];
    if (index == _controllers.count -1) {
        return _canCycle?_controllers.firstObject:nil;
    }
    return _controllers[index +1];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
