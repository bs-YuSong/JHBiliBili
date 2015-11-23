//
//  CellItemViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVModel.h"

@interface CellItemViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyIcon;
@property (weak, nonatomic) IBOutlet UILabel *danMuLabel;
@property (nonatomic, strong) NSString* section;
@property (nonatomic, strong) AVDataModel* dataModel;
@property (nonatomic, strong) UINavigationController* navController;
/**
 *  初始化一些属性
 */
- (void)setUpProperty;
@end
