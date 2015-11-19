//
//  DanMuModel.h
//  Day09_1_XmlParse
//
//  Created by apple-jd44 on 15/11/12.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DanMuModel : NSObject
@property (nonatomic, strong) NSNumber* sendTime;
@property (nonatomic, strong) NSNumber* style;
@property (nonatomic, strong) NSNumber* fontSize;
@property (nonatomic, assign) NSInteger textColor;
@property (nonatomic, strong) NSString* text;

+ (instancetype)modelWithParameter:(NSString*)parameter text:(NSString*)text;
@end
