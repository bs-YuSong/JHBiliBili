//
//  AppDelegate.m
//  BaseProject
//
//  Created by jiyingxin on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+Category.h"
//#import "WMPageController.h"
//#import "ShinBanViewController.h"
//#import "RecommendViewController.h"
//#import "FindViewController.h"
#import "JHViewController.h"
#import "UIViewController+Tools.h"
@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initializeWithApplication:application];
    [[UINavigationBar appearance] setTranslucent:NO];
    /** 配置导航栏题目的样式 */
    [[UINavigationBar appearance] setBarTintColor: kGloableColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    

    JHViewController* vc = [[JHViewController alloc] initWithControllers:@[kStoryboardWithInd(@"ShinBanViewController"), kStoryboardWithInd(@"RecommendViewController"), kStoryboardWithInd(@"FindViewController")]];
    
    UINavigationController* nav = [vc setupNavigationController];
    
    self.window = [[UIWindow alloc] initWithFrame: [[UIScreen mainScreen] bounds]];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
