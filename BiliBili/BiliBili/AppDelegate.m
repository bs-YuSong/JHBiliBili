//
//  AppDelegate.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "HomePageViewController.h"
#import "RecommendViewController.h"
#import "UIViewController+Tools.h"
#import "UIBezierPath+Tools.h"
@interface AppDelegate ()
@property (nonatomic, strong) HomePageViewController* vc;
@property (nonatomic, strong) UINavigationController* nav;
@property (strong, nonatomic) UIView* view;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeWithApplication:application];
    [self defaultsSetting];
    [self.window makeKeyAndVisible];
    
    return YES;
}
//默认设置
- (void)defaultsSetting{
    [[UINavigationBar appearance] setTranslucent:NO];
    /** 配置导航栏题目的样式 */
    [[UINavigationBar appearance] setBarTintColor: [[ColorManager shareColorManager] colorWithString:@"themeColor"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    //判断清空缓存是否标记
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"clearCache"] == YES) {
        NSArray<NSString*>* arr = [[NSFileManager defaultManager] subpathsAtPath: kCachePath];
        [arr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [[NSFileManager defaultManager] removeItemAtPath:[kCachePath stringByAppendingPathComponent:obj] error:nil];
        }];
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"clearCache"];
    }
    //判断视频清晰度是否默认为空
    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"HightResolution"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"HightResolution"];
    }
}

- (HomePageViewController *)vc{
    if (_vc == nil) {
        _vc = [[HomePageViewController alloc] initWithControllers:@[kStoryboardWithInd(@"ShinBanViewController"), [[RecommendViewController alloc] init], kStoryboardWithInd(@"FindViewController")]];
    }
    return _vc;
}

- (UINavigationController *)nav{
    if (_nav == nil) {
        _nav = [self.vc setupNavigationController];
        
        UIButton* homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.vc.navigationController.navigationBar.frame.size.height, 10, 20)];
        homeButton.tag = 1000;
        [homeButton setImage:[UIImage imageNamed:@"ic_drawer_home"] forState:UIControlStateNormal];
        [homeButton bk_addEventHandler:^(id sender) {
            [self.vc profileViewMoveToDestination];
        } forControlEvents:UIControlEventTouchUpInside];
        [_nav.view addSubview:homeButton];
    }
    return _nav;
}

- (UIView *)view{
    if (_view == nil) {
        _view = [[UIView alloc] initWithFrame:self.window.frame];
        _view.backgroundColor = kRGBColor(246, 246, 246);
        [self.window addSubview: _view];

    }
    return _view;
}

- (UIWindow *)window{
    if (_window == nil) {
        _window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
        _window.rootViewController = self.nav;
        _window.backgroundColor = [UIColor whiteColor];
    }
    return _window;
}

@end
