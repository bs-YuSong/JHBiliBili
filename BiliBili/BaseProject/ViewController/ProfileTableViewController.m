//
//  ProfileTableViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/19.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ProfileTableViewController.h"
#import "ProfileTableViewCell.h"
#import "HomePageViewController.h"
#import "ProfileHeadView.h"
@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    ProfileHeadView* headView = [[ProfileHeadView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 0.275 *kWindowH)];
    headView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"ProfileTableViewController.tableHeaderView.backgroundColor"];
    self.tableView.tableHeaderView = headView;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ProfileTableViewCell *cell = nil;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [[ProfileTableViewCell alloc] initWithTitle:@"首页" imgName:@"ic_home_black"];
        }else if(indexPath.row == 1){
            cell = [[ProfileTableViewCell alloc] initWithTitle:@"离线管理" imgName:@"ic_file_download_black"];
        }
    }else{
        if (indexPath.row == 0) {
            cell = [[ProfileTableViewCell alloc] initWithTitle:@"主题选择" imgName:@"ic_color_lens_black"];
        }else if(indexPath.row == 1){
            cell = [[ProfileTableViewCell alloc] initWithTitle:@"设置" imgName:@"ic_settings_black"];
        }
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0 && indexPath.section == 0) {
        HomePageViewController*vc =(HomePageViewController*) self.parentViewController;
        [vc profileViewMoveToOriginal];
    }
    if ([[ColorManager shareColorManager].themeStyle isEqualToString:@"夜间模式"]) {
        [ColorManager shareColorManager].themeStyle = @"少女粉";
    }else{
        [ColorManager shareColorManager].themeStyle = @"夜间模式";
    }
}

- (void)colorSetting{
    self.view.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"ProfileTableViewController.view.backgroundColor"];
    self.tableView.tableHeaderView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"ProfileTableViewController.tableHeaderView.backgroundColor"];
}

@end
