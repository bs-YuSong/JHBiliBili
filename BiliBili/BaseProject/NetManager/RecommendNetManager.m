//
//  RecommendNetManager.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendNetManager.h"
#import "recommendModel.h"
#import "IndexModel.h"
@implementation RecommendNetManager
+ (id)getSection:(NSString *)section completionHandler:(void(^)(id responseObj, NSError *error))complete{
    NSString* path = [@"http://www.bilibili.com/index/" stringByAppendingString:section];
    if ([[section componentsSeparatedByString:@"/"].firstObject isEqualToString:@"catalogy"]) {
        return [self Get:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
            complete([RecommendModel objectWithKeyValues:responseObj[@"hot"]], error);
        }];
    }else{
        return [self Get:path parameters:nil completionHandler:^(id responseObj, NSError *error) {
            complete([IndexModel objectWithKeyValues:responseObj],error);
        }];
    }
}
@end
