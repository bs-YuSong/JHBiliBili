//
//  ReViewTableViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/6.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ReViewTableViewCell.h"
@interface ReViewTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIImageView *genderImgView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lvLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ReViewTableViewCell

- (void)setName:(NSString*)name image:(NSURL*)imgURL time:(NSString*)time message:(NSString*)message goodNum:(NSString*)goodNum lv:(NSString*)lv gender:(NSString*)gender{
    self.nameLabel.text = name;
    self.nameLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    [self.imgView setImageWithURL:imgURL];

    self.imgView.layer.cornerRadius = self.imgView.frame.size.width /2 ;
    self.imgView.layer.masksToBounds = YES;
    
    self.timeLabel.text = time;
    
    self.messageLabel.text = message;
    self.messageLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    
    self.goodLabel.text = goodNum;
    self.goodLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    
    self.lvLabel.text = lv;
    self.lvLabel.textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
    
    [self.genderImgView setImage:[UIImage imageNamed: [NSString stringWithFormat:@"ic_user_%@",@{@"男":@"male",@"女":@"female",@"保密":@"sox"}[gender]]]];
}

@end
