//
//  ShiBanIntroduceTableViewCell.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/25.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShiBanIntroduceTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *introduceLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
- (void)setUpWithIntroduce:(NSString*)introduce;
@end
