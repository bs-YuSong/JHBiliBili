//
//  MyRefreshHeader.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/11.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "MyRefreshHeader.h"

@implementation MyRefreshHeader

+ (id)myRefreshHead:(void(^)())block{
    MJRefreshNormalHeader* head = [MJRefreshNormalHeader headerWithRefreshingBlock:block];
    head.lastUpdatedTimeLabel.hidden = YES;
    [head setTitle:@"再拉，再拉就刷新给你看" forState:MJRefreshStateIdle];
    [head setTitle:@"够了啦，松开人家嘛" forState:MJRefreshStatePulling];
    [head setTitle:@"刷呀刷，好累啊，喵(＾▽＾)" forState:MJRefreshStateRefreshing];
    return head;
}

@end
