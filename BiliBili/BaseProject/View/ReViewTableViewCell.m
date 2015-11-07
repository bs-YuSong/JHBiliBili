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
    [self.imgView setImageWithURL:imgURL];
    self.timeLabel.text = time;
    self.messageLabel.text = message;
    self.goodLabel.text = goodNum;
    self.lvLabel.text = lv;
}

@end
