//
//  SameVideoTableViewCell.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/6.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "SameVideoTableViewCell.h"
@interface SameVideoTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *videoImgView;
@property (weak, nonatomic) IBOutlet UILabel *videoLabel;
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UIImageView *DanMuIcon;

@end


@implementation SameVideoTableViewCell

- (void)setTitle:(NSString*)title playNum:(NSString*)playNum replyNum:(NSString*)replyNum videoImg:(NSURL*)imgURL{
    [self.videoImgView setImageWithURL:imgURL];
//    [self.videoImgView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.mas_equalTo(self.videoImgView.mas_height).multipliedBy(1.6);
//    }];
    self.playIcon.image = [self.playIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.DanMuIcon.image = [self.DanMuIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.videoLabel.text = title;
    self.playNumLabel.text = playNum;
    self.replyLabel.text = replyNum;
}

@end
