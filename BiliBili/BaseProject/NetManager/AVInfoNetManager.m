//
//  ReplyNetManager.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "AVInfoNetManager.h"
#import "NSString+Tools.h"
#import "NSDictionary+Tools.h"

@implementation AVInfoNetManager
//获取回复
+ (id)GetReplyWithParameter:(NSDictionary*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://api.bilibili.com/feedback?type=jsonp&ver=3&callback=jQuery172019889523880556226_1446769749937&mode=arc&aid=3118012&pagesize=20&page=1&_=1446769758188
    
    //aid pagesize page
    NSString*path = [parame appendGetParameterWithBasePath:@"http://api.bilibili.com/feedback?type=jsonp&ver=3&callback=jQuery172019889523880556226_1446769749937&mode=arc&_=1446769758188&"];
    
    return [self downLoad:path parameters:nil completionHandler:^(NSString* responseObj, NSError *error) {
        NSString* str = [NSString stringWithContentsOfFile:responseObj encoding:NSUTF8StringEncoding error:nil];
        //拿到下载之后的文件 做处理 返回字典对象
        NSDictionary* js = [NSJSONSerialization JSONObjectWithData:[[str subStringsWithRegularExpression:@"\\{.*\\}"].firstObject dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
        complete([ReplyModel objectWithKeyValues: js], error);
    }];
}

//获取承包商信息
+ (id)GetInverstorWithParameter:(NSDictionary*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://www.bilibili.com/widget/ajaxGetBP?aid=3168681
    //aid
    NSString* path = [parame appendGetParameterWithBasePath:@"http://www.bilibili.com/widget/ajaxGetBP?"];
    return [self Get:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([InvestorModel objectWithKeyValues:responseObj[@"list"]], error);
    }];
}
//获取推荐视频信息
+ (id)GetSameVideoWithParameter:(NSString*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete{
   // http://comment.bilibili.com/recommend,3163304
    NSString* path = [NSString stringWithFormat:@"http://comment.bilibili.com/recommend,%@",parame];
    return [self Get:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([sameVideoModel objectWithKeyValues:@{@"list":responseObj}], error);
    }];
}

//获取新番详情信息
+ (id)GetShiBanInfoWithParameter:(NSString*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://app.bilibili.com/bangumi/seasoninfo/2725.ver?callback=episodeJsonCallback&_=1446863930820
    NSString* path = [NSString stringWithFormat:@"http://app.bilibili.com/bangumi/seasoninfo/%@.ver?callback=episodeJsonCallback&_=1446863930820",parame];

    return [self downLoad:path parameters:nil completionHandler:^(NSString* responseObj, NSError *error) {
        NSString* str = [NSString stringWithContentsOfFile:responseObj encoding:NSUTF8StringEncoding error:nil];
        //拿到下载之后的文件 做处理 返回字典对象
        NSDictionary* js = [NSJSONSerialization JSONObjectWithData:[[str subStringsWithRegularExpression:@"\\{.*\\}"].firstObject dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers|NSJSONReadingMutableLeaves|NSJSONReadingAllowFragments error:nil];
        complete([ShinBanInfoModel objectWithKeyValues: js], error);
    }];
}
@end
