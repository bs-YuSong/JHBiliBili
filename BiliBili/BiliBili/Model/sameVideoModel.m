//
//  sameVideoModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/6.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "sameVideoModel.h"

@implementation sameVideoModel
+ (NSDictionary *)objectClassInArray{
    return @{@"list":[sameVideoDataModel class]};
}
@end

@implementation sameVideoDataModel
+ (NSDictionary *)replacedKeyFromPropertyName{
    return @{@"id":@"identity", @"description":@"desc", @"typeid":@"typeID"};
}

@end
