//
//  HomePageViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/31.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "HomePageViewController.h"

@interface HomePageViewController ()<UIPageViewControllerDelegate, UIPageViewControllerDataSource>
@property(nonatomic,strong) NSMutableArray *controllers;
@end

@implementation HomePageViewController

- (NSMutableArray *)controllers{
    if (_controllers == nil) {
        _controllers = [NSMutableArray array];
    }
    return _controllers;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate = self;
    self.dataSource = self;
    
    //[self.controllers addObject: kStoryboardWithInd(@"FindNav")];
    [self.controllers addObject: kStoryboardWithInd(@"ShinBanNav")];
    [self.controllers addObject: kStoryboardWithInd(@"RecommendNav")];
    
    [self setViewControllers:@[self.controllers.firstObject] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:^(BOOL finished) {
        
    }];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController{
    NSInteger index = [self.controllers indexOfObject: viewController];
    if (index == 0) {
        return nil;
    }
    return self.controllers[index - 1];
}
- (nullable UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController{
    NSInteger index = [self.controllers indexOfObject: viewController];
    if (index == self.controllers.count - 1) {
        return nil;
    }
    return self.controllers[index + 1];

}
@end
