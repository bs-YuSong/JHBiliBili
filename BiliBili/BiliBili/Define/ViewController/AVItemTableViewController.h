//
//  AVItemTableViewController.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/8.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
/**
 *  视频详情页的三个部分 视频详情、相关视频、评论
 */
@class AVInfoViewModel;
@interface AVItemTableViewController : UITableViewController

- (instancetype)initWithVM:(AVInfoViewModel*)vm cellIdentity:(NSString*)cellIdentity storyBoardIndentity:(NSString*)ID parentTableView:(UITableView*)tableView;
@end
