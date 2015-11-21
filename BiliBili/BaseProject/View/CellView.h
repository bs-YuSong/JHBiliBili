//
//  CellView.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface CellView : UITableViewCell
//@property (weak, nonatomic) IBOutlet UILabel *title;
//@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
//@property (weak, nonatomic) IBOutlet UIButton *moreButton;
//@property (weak, nonatomic) IBOutlet UIView *enterView;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UIImageView *titleImg;
@property (strong, nonatomic) UIButton *moreButton;
@property (strong, nonatomic) UIView *enterView;
@property (nonatomic, strong) UILabel* enterLabel;
- (void)setTitle:(NSString*)title titleImg:(NSString*)titleimg buttonTitle:(NSString*)buttonTitle dic:(NSDictionary<NSString*,NSArray*>*)dic;
@end
