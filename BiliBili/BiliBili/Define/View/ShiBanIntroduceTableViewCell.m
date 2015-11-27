//
//  ShiBanIntroduceTableViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "ShiBanIntroduceTableViewCell.h"

@implementation ShiBanIntroduceTableViewCell

- (void)setUpWithIntroduce:(NSString*)introduce{
    self.introduceLabel.text = introduce;
    self.introduceLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    self.titleLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
}
@end
