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
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeWithApplication:application];
    [[UINavigationBar appearance] setTranslucent:NO];
    /** 配置导航栏题目的样式 */
    [[UINavigationBar appearance] setBarTintColor: [[ColorManager shareColorManager] colorWithString:@"themeColor"]];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
   HomePageViewController* vc = [[HomePageViewController alloc] initWithControllers:@[kStoryboardWithInd(@"ShinBanViewController"), [[RecommendViewController alloc] init], kStoryboardWithInd(@"FindViewController")]];
    
    UINavigationController* nav = [vc setupNavigationController];
    UIButton* homeButton = [[UIButton alloc] initWithFrame:CGRectMake(0, vc.navigationController.navigationBar.frame.size.height, 10, 20)];
    [homeButton setImage:[UIImage imageNamed:@"ic_drawer_home"] forState:UIControlStateNormal];
    [homeButton bk_addEventHandler:^(id sender) {
        [vc profileViewMoveToDestination];
    } forControlEvents:UIControlEventTouchUpInside];
    [nav.view addSubview:homeButton];
    
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
