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

@end


@implementation SameVideoTableViewCell

- (instancetype)init{
    self = [super init];
    [self.videoImgView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.videoImgView.mas_height).multipliedBy(0.63);
    }];
    return self;
}

- (void)serTitle:(NSString*)title playNum:(NSString*)playNum replyNum:(NSString*)replyNum videoImg:(NSURL*)imgURL{
    [self.videoImgView setImageWithURL:imgURL];
    self.videoLabel.text = title;
    self.playNumLabel.text = playNum;
    self.replyLabel.text = replyNum;
}

@end
