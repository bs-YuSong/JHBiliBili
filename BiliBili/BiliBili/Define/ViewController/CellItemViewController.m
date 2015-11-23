//
//  CellItemViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "CellItemViewController.h"
#import "AVInfoViewController.h"

@implementation CellItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setUpProperty{
    self.titleLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    self.imgv.layer.cornerRadius = 8;
    self.imgv.layer.masksToBounds = YES;
    self.playIcon.tintColor = [[ColorManager shareColorManager] colorWithString:@"themeColor"];
    self.playIcon.image = [self.playIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.replyIcon.tintColor = [[ColorManager shareColorManager] colorWithString:@"themeColor"];
    self.replyIcon.image = [self.replyIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    AVInfoViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AVInfoViewController"];
    [vc setWithModel:self.dataModel section:self.section];
    [self.navController pushViewController:vc animated:YES];
}


@end
