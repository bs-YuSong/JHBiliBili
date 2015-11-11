//
//  ReplyNetManager.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseNetManager.h"
#import "sameVideoModel.h"
#import "InvestorModel.h"
#import "ReplyModel.h"
#import "ShinBanInfoModel.h"
//番剧页网络模型
@interface AVInfoNetManager : BaseNetManager
//获取回复信息
+ (id)GetReplyWithParameter:(NSDictionary*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete;
//获取承包商信息
+ (id)GetInverstorWithParameter:(NSDictionary*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete;
//获取推荐视频信息
+ (id)GetSameVideoWithParameter:(NSString*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete;

//获取新番详情信息
+ (id)GetShiBanInfoWithParameter:(NSDictionary*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete;

+ (id)GetTagWithParameter:(NSDictionary*)parame completionHandler:(void(^)(id responseObj, NSError *error))complete;
@end
