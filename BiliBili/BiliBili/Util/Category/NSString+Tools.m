//
//  NSString+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/5.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
+ (NSString*)stringWithFormatNum:(NSInteger)num{
    if (num >= 10000) {
        return [NSString stringWithFormat:@"%.1lf万",num * 1.0 / 10000];
    }
    return [NSString stringWithFormat:@"%ld", (long)num];
}

- (NSArray<NSString *>*)subStringsWithRegularExpression:(NSString*)regularExpression{
    NSRegularExpression* regu = [[NSRegularExpression alloc] initWithPattern:regularExpression options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray* objArr = [regu matchesInString:self options:0 range:NSMakeRange(0, self.length)];
    NSMutableArray* returnArr = [NSMutableArray array];
    for (NSTextCheckingResult* rs in objArr) {
        [returnArr addObject:[self substringWithRange:rs.range]];
    }
    return [returnArr copy];
}

@end
