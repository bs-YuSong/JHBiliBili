//
//  CellItemViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/23.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "CellItemViewController.h"
#import "AVInfoViewController.h"

@interface CellItemViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgv;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *playIcon;
@property (weak, nonatomic) IBOutlet UILabel *playLabel;
@property (weak, nonatomic) IBOutlet UIImageView *replyIcon;
@property (weak, nonatomic) IBOutlet UILabel *replyLabel;
@property (nonatomic, strong) NSString* section;
@property (nonatomic, assign) NSInteger ind;
//@property (nonatomic, strong) AVDataModel* model;
@end

@implementation CellItemViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}


- (void)setViewContentWithImgURL:(NSURL*)URL playNum:(NSString*)playNum replyNum:(NSString*)replyNum title:(NSString*)title section:(NSString*)section ind:(NSInteger)ind{
    //视频缩略图
    [self.imgv setImageWithURL: URL];
    [self.imgv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(self.imgv.mas_width).multipliedBy(0.63);
    }];
    self.imgv.layer.cornerRadius = 8;
    self.imgv.layer.masksToBounds = YES;
    //视频标题
    self.label.text = title;
    //小图标
    self.playIcon.tintColor = kRGBColor(182, 182, 182);
    self.playIcon.image = [self.playIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.replyIcon.tintColor = kRGBColor(182, 182, 182);
    self.replyIcon.image = [self.replyIcon.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    self.playLabel.text = playNum;
    self.replyLabel.text = replyNum;
    
    self.section = section;
    self.ind = ind;
    
//    self.model = model;
}

- (void)pushAVInfoViewController:(block) b{
    self.returnBlock = b;
}

- (IBAction)touchStart:(UIButton *)sender {
    self.returnBlock();
}


- (IBAction)touchOver:(UIButton *)sender {
  //  sender.backgroundColor = [UIColor clearColor];
}

@end
