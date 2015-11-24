//
//  InvestorTableViewCell.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/6.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvestorTableViewCell : UITableViewCell
- (void)setRank:(NSInteger)rank icon:(NSURL*)icon name:(NSString*)name reply:(NSString*)reply;
@end
