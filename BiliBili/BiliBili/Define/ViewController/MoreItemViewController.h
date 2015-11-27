//
//  MoreViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShinBanModel.h"
@class MoreViewShinBanDataModel;
@interface MoreItemViewController : UIViewController
@property (strong, nonatomic) UIImageView *pic;
@property (strong, nonatomic) UILabel *animaTitle;
@property (strong, nonatomic) UILabel *playNum;
@property (nonatomic, strong) MoreViewShinBanDataModel* model;
- (void)setUpProperty;

@end
