//
//  CellView.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CellView : UITableViewCell

@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIImageView *titleImg;
@property (strong, nonatomic) UIButton *moreButton;
@property (nonatomic, strong) UIButton* enterButton;
@property (nonatomic, strong) UILabel* enterLabel;
@property (nonatomic, strong) UIViewController* vc;
- (void)setTitle:(NSString*)title titleImg:(NSString*)titleimg buttonTitle:(NSString*)buttonTitle dic:(NSDictionary<NSString*,NSArray*>*)dic;

@end
