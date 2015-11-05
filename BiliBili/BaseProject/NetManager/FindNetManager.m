//
//  FindNetManager.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/4.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "FindNetManager.h"
@implementation FindNetManager
+ (id)GetRankCompletionHandler:(void(^)(id responseObj, NSError *error))complete{
    NSString* basePath = @"http://app.bilibili.com/api/search_rank.json?_device=android&_hwid=831fc7511fa9aff5&appkey=c1b107428d337928&build=407000&platform=android&ts=1446554579000&sign=e99f5ed257d7c081e5ac901f8b72f331";
    return [self Get:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([FindModel objectWithKeyValues:responseObj],error);
    }];
}
+ (id)GetRankImgCompletionHandler:(void(^)(id responseObj, NSError *error))complete{
    NSString* basePath = @"http://app.bilibili.com/api/search/1954/search.android.xhdpi.android.json";
    return [self Get:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([FindImgModel objectWithKeyValues:responseObj[@"result"]],error);
    }];
}
@end
