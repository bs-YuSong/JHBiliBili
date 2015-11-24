//
//  CellItemViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVModel.h"

@interface CellItemViewController : UIViewController
@property (strong, nonatomic) UIImageView *imgv;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UIImageView *playIcon;
@property (strong, nonatomic) UILabel *playLabel;
@property (strong, nonatomic) UIImageView *danMuIcon;
@property (strong, nonatomic) UILabel *danMuLabel;

@property (nonatomic, strong) NSString* section;
@property (nonatomic, strong) AVDataModel* dataModel;
@property (nonatomic, strong) UINavigationController* navController;
/**
 *  初始化一些属性
 */
- (void)setUpProperty;
@end
