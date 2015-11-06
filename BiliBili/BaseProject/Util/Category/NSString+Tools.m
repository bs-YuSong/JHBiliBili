//
//  NSString+Tools.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/5.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "NSString+Tools.h"

@implementation NSString (Tools)
+ (NSString*)stringWithFormatNum:(NSInteger)num{
    if (num >= 10000) {
        return [NSString stringWithFormat:@"%.1lf万",num * 1.0 / 10000];
    }
    return [NSString stringWithFormat:@"%ld", num];
}
@end
