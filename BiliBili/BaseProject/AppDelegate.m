//
//  AppDelegate.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
#import "WMPageController.h"
#import "ShinBanViewController.h"
#import "RecommendViewController.h"
#import "FindViewController.h"
#import "JHViewController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeWithApplication:application];
//    [[UINavigationBar appearance] setTranslucent:NO];
//    /** 配置导航栏题目的样式 */
//    [[UINavigationBar appearance] setBarTintColor: kGloableColor];
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
//    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
//
    //FindViewController
    
    ShinBanViewController* v1 = kStoryboardWithInd(@"ShinBanViewController");
    RecommendViewController* v2 = kStoryboardWithInd(@"RecommendViewController");
    FindViewController* v3 = kStoryboardWithInd(@"FindViewController");
    
    JHViewController* vc = [[JHViewController alloc] initWithControllers:@[v1, v2, v3]];
   // WMPageController* page = [[WMPageController alloc] initWithViewControllerClasses:@[[v1 class], [v2 class], [v3 class]] andTheirTitles:@[@"番剧",@"推荐",@"发现"]];
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
