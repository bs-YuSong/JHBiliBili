//
//  recommendModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list":[RecommendDataModel class]};
}
@end

@implementation RecommendDataModel

+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"desc": @"description"};
}

@end