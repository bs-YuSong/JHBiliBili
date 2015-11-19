//
//  AVItemTableViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/8.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AVItemTableViewController.h"
#import "AVInfoViewModel.h"
#import "ReViewTableViewCell.h"
#import "SameVideoTableViewCell.h"
#import "InvestorTableViewCell.h"
#import "UIScrollView+Tools.h"
@interface AVItemTableViewController ()
//根据cell的标识符判断初始化的cell类型
@property (nonatomic, strong) NSString* cellIdentity;
@property (nonatomic, strong) AVInfoViewModel* vm;
@property (nonatomic, strong) UITableView* parentTableView;
@end

@implementation AVItemTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* v = [UIView new];
    v.backgroundColor = kRGBColor(242, 242, 242);
    //表尾空白
    self.tableView.tableFooterView = v;
    //设置默认不可滚动
    self.tableView.scrollEnabled = NO;
    self.tableView.estimatedRowHeight = 100;
}

#pragma mark - TableViewController

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //textCell SameVideoTableViewCell ReViewTableViewCell InvestorTableViewCell
    NSInteger i = [@{@"textCell":@2, @"SameVideoTableViewCell": @([self.vm sameVideoCount]),@"InvestorTableViewCell":@([self.vm investorCount]), @"ReViewTableViewCell":@([self.vm replyCount])}[self.cellIdentity] integerValue];
    
    return i;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentity];
    [self setCellContent:cell index:indexPath];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.cellIdentity isEqualToString:@"textCell"]) {
        return UITableViewAutomaticDimension;
    }
    return [tableView fd_heightForCellWithIdentifier:self.cellIdentity configuration:^(id cell) {
       [self setCellContent:cell index:indexPath];
    }];
}


//视频详情页子项高度
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([self.cellIdentity isEqualToString:@"SameVideoTableViewCell"]) {
//        return kWindowW * 0.24;
//    }
//    if([self.cellIdentity isEqualToString:@"InvestorTableViewCell"]){
//        return kWindowW * 0.17;
//    }
//    return 50;
//    //return [self tableView:tableView estimatedHeightForRowAtIndexPath:indexPath];
//}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
//  //  if([self.cellIdentity isEqualToString:@"ReViewTableViewCell"] || [self.cellIdentity isEqualToString:@"textCell"]){
//        return UITableViewAutomaticDimension;
//   // }
//   // return 0;
//}

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
            [cell textLabel].textColor = kGloableColor;
        //简介
        }else{
            [cell textLabel].text = [self.vm infoBrief];
            [cell textLabel].textColor = kRGBColor(164, 164, 164);
            
        }
    }else if([self.cellIdentity isEqualToString:@"InvestorTableViewCell"]){
        
        [cell setRank:[self.vm investorRankForRow:index.row] icon:[self.vm investorIconForRow:index.row] name:[self.vm investorNameForRow:index.row] reply:[self.vm investorMessageForRow:index.row]];
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
    if (scrollView.contentOffset.y <= 5) {
        self.parentTableView.scrollEnabled = YES;
        // 用于临界值的判断 并不是字面上的意思
        scrollView.scrollEnabled = NO;
    }
}
@end
