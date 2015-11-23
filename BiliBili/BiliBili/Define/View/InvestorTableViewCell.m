//
//  InvestorTableViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/6.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "InvestorTableViewCell.h"
@interface InvestorTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UIImageView *invertorIcon;
@property (weak, nonatomic) IBOutlet UILabel *invertorName;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@end

@implementation InvestorTableViewCell
- (void)setRank:(NSInteger)rank icon:(NSURL*)icon name:(NSString*)name reply:(NSString*)reply{
    self.rankLabel.text = [NSString stringWithFormat:@"%ld",(long)rank];
    [self.invertorIcon setImageWithURL:icon];
    self.invertorIcon.layer.cornerRadius = self.invertorIcon.frame.size.width / 2;
    self.invertorIcon.layer.masksToBounds = YES;
    self.invertorName.text = name;
    self.replyLabel.text = reply;
}


@end
