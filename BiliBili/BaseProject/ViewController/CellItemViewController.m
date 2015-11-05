//
//  CellItemViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "CellItemViewController.h"

@interface CellItemViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyIcon;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;

@end

@implementation CellItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)setViewContentWithModel:(RecommendDataModel*)model{
    [self.imgv setImageWithURL:[NSURL URLWithString:model.pic]];
    [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.imgv.mas_width).multipliedBy(0.63);
    }];
    self.imgv.layer.cornerRadius = 8;
    self.imgv.layer.masksToBounds = YES;
    self.label.text = model.title;
    self.playIcon.tintColor = kRGBColor(182, 182, 182);
    self.playIcon.image = [self.playIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.replyIcon.tintColor = kRGBColor(182, 182, 182);
    self.replyIcon.image = [self.replyIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    NSString* str = model.play.stringValue;
    NSString* str2 = model.review.stringValue;
    if (str.doubleValue >= 10000) {
        str = [NSString stringWithFormat:@"%.1f万",model.play.doubleValue/10000];
    }
    if (str2.doubleValue >= 10000) {
        str2 = [NSString stringWithFormat:@"%.1f万",model.review.doubleValue/10000];
    }
    self.playLabel.text = str;
    self.replyLabel.text = str2;
}
- (IBAction)touchStart:(UIButton *)sender {
    sender.backgroundColor = kRGBColor(100, 100, 100);
}
- (IBAction)touchOver:(UIButton *)sender {
    sender.backgroundColor = [UIColor clearColor];
}

@end
