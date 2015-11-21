//
//  RecommendTableViewController.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendTableView.h"

@interface RecommendTableView ()

@end

@implementation RecommendTableView

- (instancetype)init{
    if (self = [super initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH) style:UITableViewStyleGrouped]) {
        UIView* v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowW / 2)];
        self.tableHeaderView = v;
    }
    return self;
}

@end
