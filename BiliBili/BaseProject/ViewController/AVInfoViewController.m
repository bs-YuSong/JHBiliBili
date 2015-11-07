//
//  AVInfoViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/1.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AVInfoViewController.h"
#import "NSString+Tools.h"
#import "AVModel.h"
#import "WMMenuView.h"

@interface AVInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
//up名
@property (weak, nonatomic) IBOutlet UILabel *UP;
//视频缩略图
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
//播放数
@property (weak, nonatomic) IBOutlet UILabel *playNumLabel;
//弹幕数
@property (weak, nonatomic) IBOutlet UILabel *danMuLabel;
//发布时间
@property (weak, nonatomic) IBOutlet UILabel *publicTimeLabel;
//视频标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@property (nonatomic, assign, getter=isShiBanSection)  BOOL ShiBanSection;

@property (nonatomic, strong) AVDataModel* model;

@end

@implementation AVInfoViewController
//235 147
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.playButton.layer.cornerRadius = 8;
    
    self.headView.frame = CGRectMake(0, 0, kWindowW, kWindowW * 0.4 + 30);
    
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.headView.mas_width).multipliedBy(0.33);
        make.height.mas_equalTo(self.imgView.mas_width).multipliedBy(0.62);
    }];
    
    
    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"UP主："];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString: self.model.author attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:kRGBColor(248, 116, 153)}]];
    [self.UP setAttributedText:str];
    
    self.playNumLabel.text = [NSString stringWithFormat:@"播放：%@", [NSString stringWithFormatNum:self.model.play]];
    self.danMuLabel.text = [NSString stringWithFormat:@"弹幕数：%@", [NSString stringWithFormatNum:self.model.video_review]];
    self.publicTimeLabel.text = [NSString stringWithFormat:@"发布于：%@", self.model.create];
    [self.imgView setImageWithURL: [NSURL URLWithString:self.model.pic]];
    self.titleLabel.text = self.model.title;
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"avInfoCell"];
    //cell.textLabel.text = @"sdsd";
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray* titleArr = nil;
    if (self.isShiBanSection) {
        titleArr = @[@"承包商排行",@"视频详情",@"相关视频",@"评论"];
    }else{
        titleArr = @[@"视频详情",@"相关视频",@"评论"];
    }
    
    WMMenuView* menuView = [[WMMenuView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 30) buttonItems:titleArr backgroundColor:[UIColor whiteColor] norSize:10 selSize:15 norColor:[UIColor blackColor] selColor:kRGBColor(221, 107, 140)];
    menuView.style = WMMenuViewStyleLine;
    return menuView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (void)setWithModel:(AVDataModel*)model withSection:(NSString*)section{
    self.ShiBanSection = [section isEqualToString:@"catalogy/13-3day.json"];
    self.model = model;
}


@end
