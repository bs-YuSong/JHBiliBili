//
//  AVInfoViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/1.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AVInfoViewController.h"

@interface AVInfoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray* buttons;
@property (weak, nonatomic) IBOutlet UILabel *UP;



@end

@implementation AVInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.headView.frame = CGRectMake(0, 0, kWindowW, kWindowH / 2.25);

    NSMutableAttributedString* str = [[NSMutableAttributedString alloc] initWithString:@"UP主："];
    [str appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@"查看所有中奖记录" attributes:@{NSUnderlineStyleAttributeName:@(NSUnderlineStyleSingle),NSForegroundColorAttributeName:kRGBColor(248, 116, 153)}]];
    [self.UP setAttributedText:str];

    
}


- (NSMutableArray *)buttons{
    if (_buttons == nil) {
        _buttons = [NSMutableArray array];
    }
    return _buttons;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 30;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"avInfoCell"];
    
    cell.textLabel.text = @"sdsd";
    return cell;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, 30)];
    view.backgroundColor = [UIColor grayColor];
    NSArray* titleArr = @[@"承包商排行",@"视频详情",@"相关视频",@"评论"];
    //记录最新添加的按钮
    UIButton* latestButton = nil;
    for (int i = 0; i < titleArr.count; ++i) {
        UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setTitle: titleArr[i] forState:UIControlStateNormal];
        [button setTitleColor:kRGBColor(221, 107, 140) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:13];
        [view addSubview: button];
        [self.buttons addObject: button];
        if (latestButton) {
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.width.equalTo(latestButton);
                make.height.equalTo(latestButton);
                make.left.equalTo(latestButton.mas_right).mas_equalTo(10);
            }];
        }else{
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(view);
                make.bottom.equalTo(view);
                make.left.equalTo(view).mas_equalTo(10);
            }];
        }
        
        [button bk_addEventHandler:^(id sender) {
            NSLog(@"%@",button.titleLabel.text);
            [self setSelectedButton: button];
        } forControlEvents:UIControlEventTouchUpInside];
        latestButton = button;
    }
    [latestButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(view.mas_right).mas_equalTo(-10);
    }];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
//把没被选中按钮的选择状态还原
- (void)setSelectedButton:(UIButton*)button{
    [self.buttons enumerateObjectsUsingBlock:^(UIButton*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (button!=obj) {
            [obj setSelected: NO];
        }else{
            [obj setSelected: YES];
        }
    }];
}

@end
