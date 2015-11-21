//
//  ColorManager.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/20.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ColorManager : NSObject
@property (nonatomic, strong) NSString* themeStyle;
@property (nonatomic, strong) NSDictionary* colorDic;
//+ (NSDictionary*)shareColorDic;
+ (instancetype)shareColorManager;
- (UIColor*)colorWithString:(NSString*)str;
@end
