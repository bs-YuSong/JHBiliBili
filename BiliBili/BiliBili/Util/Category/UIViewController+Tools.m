//
//  UIViewController+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/11.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "UIViewController+Tools.h"

@implementation UIViewController (Tools)
- (UINavigationController*)setupNavigationController{
    UINavigationController* nav = [[UINavigationController alloc] initWithRootViewController:self];
    return nav;
}
@end
