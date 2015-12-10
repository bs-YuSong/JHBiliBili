//
//  DownLoadTableViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/12/4.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "DownLoadTableViewController.h"
#import "DownLoadTableViewCell.h"
#import "VideoViewController.h"
#import "DownLoadViewModel.h"
#import "BaseNetManager.h"
#import "AVInfoNetManager.h"

@interface DownLoadTableViewController ()
@property (nonatomic, strong) DownLoadViewModel *vm;
@property (nonatomic, strong) NSTimer *timer;
@end

@implementation DownLoadTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    __weak typeof(self)weakSelf = self;
    self.timer = [NSTimer bk_scheduledTimerWithTimeInterval:1 block:^(NSTimer *timer) {
        NSInteger cellsCount = [BaseNetManager sharedAFURLManager].downloadTasks.count;
        for (int i = 0; i < cellsCount; ++i) {
            NSURLSessionDownloadTask *task = [BaseNetManager sharedAFURLManager].downloadTasks[i];
            NSInteger index = [self.vm taskIndexWithAid: task.taskDescription];
            DownLoadTableViewCell*cell =  [self.tableView cellForRowAtIndexPath: [NSIndexPath indexPathForRow: index inSection:0]];
            [cell updateProgress:[[BaseNetManager sharedAFURLManager] downloadProgressForTask: task].fractionCompleted];
        }
        if (cellsCount == 0) {
            [weakSelf.timer invalidate];
        }
    } repeats: YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.timer invalidate];
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.vm taskCount];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DownLoadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[DownLoadTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell" taskIsPause: [self.vm taskIsPauseWithIndex: indexPath.row]];
        //暂停和恢复操作
        __weak typeof(self.vm)weakVM = self.vm;
        __weak typeof(cell)weakCell = cell;
        [cell updateBolock:^{
            //如果点击的是当前正在下载的cell 暂停 否则如果当前没有任务在下载 则开始下载
            if ([weakVM taskIsCurrentTaskWithIndex: indexPath.row]) {
                [weakVM cancelTaskWithIndex: indexPath.row];
                weakCell.suspandButton.selected = !weakCell.suspandButton.isSelected;
            }else if([BaseNetManager sharedAFURLManager].downloadTasks.count == 0){
                [weakVM restartTaskWithIndex: indexPath.row];
                weakCell.suspandButton.selected = !weakCell.suspandButton.isSelected;
            }
        }];
    }
//    cell.suspandButton.selected = [self.vm taskIsPauseWithIndex: indexPath.row];
    cell.textLabel.text = [self.vm taskNameWithIndex:indexPath.row];
    
    //下载完成 状态更新到100%
    //cell.detailTextLabel.text = [self.vm taskStatusWithIndex:indexPath.row];
    //[cell.progressView setProgress: [self.vm taskProgressWithIndex:indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //下载完成点击自动播放
    if ([self.vm taskIsDownLoadOverWithIndex:indexPath.row]) {
        VideoViewController* vc = [[VideoViewController alloc] initWithAid: [self.vm taskAidWithIndex:indexPath.row]];
        [self presentViewController: vc animated:YES completion:nil];
    }
}


- (instancetype)init{
    if (self = [super init]) {
        self.tableView.rowHeight = 50;
        self.tableView.tableFooterView = [UIView new];
        self.tableView.backgroundColor = [[ColorManager shareColorManager] colorWithString:@"backgroundColor"];
    }
    return self;
}

#pragma mark - 懒加载

- (DownLoadViewModel *)vm {
	if(_vm == nil) {
		_vm = [[DownLoadViewModel alloc] init];
	}
	return _vm;
}

@end
