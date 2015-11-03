//
//  FindViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/31.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "FindViewController.h"

@interface FindViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allSectionSortButtonCon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftImgCon;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *headView;

@end

@implementation FindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.allSectionSortButtonCon.constant = (kWindowW - 30) / 2 / 1.38;
    self.leftImgCon.constant = (kWindowW - 30) / 2 / 1.68;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"fvcell"];
    cell.textLabel.text = @"sdsd";
    UIImageView* imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.height, cell.frame.size.height)];
    [imgView setImage:[UIImage imageNamed:@"home_rank_icon"]];
    cell.accessoryView = imgView;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
