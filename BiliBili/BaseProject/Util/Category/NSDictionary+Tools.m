//
//  NSDictionary+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "NSDictionary+Tools.h"

@implementation NSDictionary (Tools)
- (NSString*)appendGetParameterWithBasePath:(NSString*)path{
    NSMutableString* basePath = [[NSMutableString alloc] initWithString:path];
    [self enumerateKeysAndObjectsUsingBlock:^(NSString*  _Nonnull key, NSString*  _Nonnull obj, BOOL * _Nonnull stop) {
        [basePath appendFormat:@"%@=%@&",key,obj];
    }];
    return [basePath copy];
}
@end
