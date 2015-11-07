//
//  CellView.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/22.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "CellView.h"

@implementation CellView

- (void)setTitle:(NSString*)title titleImg:(NSString*)titleimg buttonTitle:(NSString*)buttonTitle{
    self.title.text = title;
    //图片文件名 home_region_icon_分区名
    [self.titleImg setImage:[UIImage imageNamed: titleimg]];
    [self.moreButton setTitle:[@"更多" stringByAppendingString: title] forState:UIControlStateNormal];
    self.enterView.layer.cornerRadius = self.enterView.frame.size.width / 2;
    self.enterView.layer.masksToBounds = YES;
}

@end
