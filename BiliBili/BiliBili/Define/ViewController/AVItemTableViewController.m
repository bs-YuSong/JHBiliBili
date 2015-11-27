//
//  AVItemTableViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/8.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "AVItemTableViewController.h"
#import "AVInfoViewModel.h"
#import "ShiBanInfoViewModel.h"
#import "ReViewTableViewCell.h"
#import "SameVideoTableViewCell.h"
#import "InvestorTableViewCell.h"
#import "ShiBanEpisodesTableViewCell.h"
#import "ShiBanIntroduceTableViewCell.h"
#import "UIScrollView+Tools.h"
#import "AVInfoViewController.h"
@interface AVItemTableViewController ()
//根据cell的标识符判断初始化的cell类型
@property (nonatomic, strong) NSString* cellIdentity;
@property (nonatomic, strong) id vm;
@property (nonatomic, strong) UITableView* parentTableView;
@end

@implementation AVItemTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* v = [UIView new];
    v.backgroundColor = kRGBColor(242, 242, 242);
    //表尾空白
    self.tableView.tableFooterView = v;
    self.tableView.separatorColor = [[ColorManager shareColorManager] colorWithString:@"separatorColor"];
    //设置默认不可滚动
    self.tableView.scrollEnabled = NO;
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

#pragma mark - TableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //textCell SameVideoTableViewCell ReViewTableViewCell InvestorTableViewCell
    NSInteger i = [@{@"textCell":@2, @"shiBanInfoCell":@(2),@"SameVideoTableViewCell": @([self.vm sameVideoCount]),@"InvestorTableViewCell":@([self.vm investorCount]), @"ReViewTableViewCell":@([self.vm replyCount])}[self.cellIdentity] integerValue];
    
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = nil;
    //判断是否为番剧
    if ([self.cellIdentity isEqualToString:@"shiBanInfoCell"]) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShiBanEpisodesTableViewCell"];
            if (cell == nil) {
                cell = [[ShiBanEpisodesTableViewCell alloc] initWithStyle:0 reuseIdentifier:@"ShiBanEpisodesTableViewCell"];
            }
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"ShiBanIntroduceTableViewCell"];
        }
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentity];
    }
    return [self setCellContent:cell index:indexPath];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 方法

- (id)setCellContent:(id)cell index:(NSIndexPath*)index{
    
    //根据标识类型初始化cell内容
    //相似视频cell
    if ([self.cellIdentity isEqualToString:@"SameVideoTableViewCell"]) {
        [cell setTitle:[self.vm sameVideoTitleForRow:index.row] playNum:[self.vm sameVideoPlayNumForRow:index.row] replyNum:[self.vm sameVideoReplyForRow:index.row] videoImg:[self.vm sameVideoPicForRow:index.row]];
        //评论cell
    }else if([self.cellIdentity isEqualToString:@"ReViewTableViewCell"]){
        [cell setName:[self.vm replyNameForRow:index.row] image:[self.vm replyIconForRow:index.row] time:[self.vm replyTimeForRow:index.row] message:[self.vm replyMessageForRow:index.row] goodNum:[self.vm replyGoodForRow:index.row] lv:[self.vm replyLVForRow:index.row] gender:[self.vm replyGenderForRow:index.row]];
        //视频详情cell
    }else if ([self.cellIdentity isEqualToString:@"textCell"]){
        
        [cell textLabel].font = [UIFont systemFontOfSize: 13];
        [cell textLabel].numberOfLines = 0;
        //tag
        if (index.row == 0) {
            [cell textLabel].attributedText = [self.vm infoTags];
            [cell textLabel].textColor = [[ColorManager shareColorManager] colorWithString:@"AVItemTableViewController.tagColor"];
        //简介
        }else{
            [cell textLabel].text = [self.vm infoBrief];
            [cell textLabel].textColor = [[ColorManager shareColorManager] colorWithString:@"textColor"];
            
        }
    }else if([self.cellIdentity isEqualToString:@"InvestorTableViewCell"]){
        
        [cell setRank:[self.vm investorRankForRow:index.row] icon:[self.vm investorIconForRow:index.row] name:[self.vm investorNameForRow:index.row] reply:[self.vm investorMessageForRow:index.row]];
        //番剧详情
    }else if ([self.cellIdentity isEqualToString:@"shiBanInfoCell"]){
        //分集
        if (index.row == 0) {
            ShiBanEpisodesTableViewCell* c = (ShiBanEpisodesTableViewCell*)cell;
            [c setUpdateReturnBlock:^(NSNumber * num) {
                [self.vm setCurrentEpisode:num];
            }];
            [c setEpisodes: [self.vm shinBanInfoEpisode]];
        //简介
        }else{
            [cell setUpWithIntroduce:[self.vm shinBanInfoIntroduce]];
        }
    }
        return cell;
}

- (instancetype)initWithVM:(AVInfoViewModel*)vm cellIdentity:(NSString*)cellIdentity storyBoardIndentity:(NSString*)ID parentTableView:(UITableView*)tableView{
    if ((self = kStoryboardWithInd(ID))) {
        self.vm = vm;
        self.cellIdentity = cellIdentity;
        self.parentTableView = tableView;
    }
    return self;
}

#pragma mark - UIScrollView
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < 0) {
        self.parentTableView.scrollEnabled = YES;
        scrollView.scrollEnabled = NO;
    }
}
@end
