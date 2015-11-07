//
//  ShinBanNetManager.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ShinBanNetManager.h"
#import "ShinBanModel.h"
#import "NSDictionary+Tools.h"
@implementation ShinBanNetManager
+ (id)getMoreViewParametersCompletionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://www.bilibili.com/index/ding/13.json
    NSString* basePath = @"http://www.bilibili.com/index/ding/13.json";
    return [self Get:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([MoreViewShinBanModel objectWithKeyValues:responseObj],error);
    }];
    
}

+ (id)getRecommentParameters:(NSDictionary*)params CompletionHandler:(void(^)(id responseObj, NSError *error))complete{
    //http://app.bilibili.com/promo/android3/2448/bangumi.android3.xhdpi.json
    
    //http://www.bilibili.com/api_proxy?app=bangumi&page=1&indexType=0&pagesize=30&action=site_season_index
    
    NSString*basePath = [params appendGetParameterWithBasePath:@"http://www.bilibili.com/api_proxy?app=bangumi&indexType=0&action=site_season_index&"];
    
    
    return [self Get:basePath parameters:nil completionHandler:^(id responseObj, NSError *error) {
        complete([RecommentShinBanModel objectWithKeyValues:responseObj[@"result"]],error);
    }];
}
@end
