//
//  ColorManager.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/20.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "ColorManager.h"
#import "UIColor+Art.h"
//用于保存写好的plist文件
//static NSDictionary* dic = nil;
static ColorManager* colorManager = nil;
@implementation ColorManager
- (NSString *)themeStyle{
    //利用userdefault存模式 少女粉 夜间模式
    if (_themeStyle == nil) {
        _themeStyle = [[NSUserDefaults standardUserDefaults] valueForKey:@"themeStyle"];
        if (_themeStyle == nil) {
            _themeStyle = @"少女粉";
        }
    }
    return _themeStyle;
}
- (NSDictionary *)colorDic{
    if (_colorDic == nil) {
        _colorDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"]];
    }
    return _colorDic;
}
//+ (NSDictionary*)shareColorDic{
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        if (dic == nil) {
//            dic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"theme" ofType:@"plist"]];
//            if (dic == nil) {
//                dic = [NSDictionary dictionary];
//            }
//        }
//    });
//    return dic;
//}

/**
 *  str的格式为xx.xx.xx
 */
- (UIColor*)colorWithString:(NSString*)str{
    return [UIColor colorWithHex:[[self.colorDic[self.themeStyle] valueForKeyPath:str] integerValue]];
}

+ (instancetype)shareColorManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        colorManager = [[ColorManager alloc] init];
    });
    return colorManager;
}
@end
