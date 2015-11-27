//
//  ShiBanInfoViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RecommentShinBanDataModel;
@interface ShiBanInfoViewController : UIViewController
- (void)setWithModel:(RecommentShinBanDataModel*)model;
- (void)updateButtonTitleAndPlay:(NSNotification *)notification;
@end
