//
//  recommendModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"

@interface AVModel : BaseViewModel
@property (nonatomic, strong) NSArray* list;
@end

@interface AVDataModel : BaseViewModel
@property (nonatomic, strong)NSString* desc;
@property (nonatomic, strong)NSNumber* mid;
@property (nonatomic, strong)NSString* subtitle;
//弹幕
@property (nonatomic, assign)NSInteger review;
@property (nonatomic, assign)NSInteger favorites;
@property (nonatomic, strong)NSString* author;
@property (nonatomic, assign)NSInteger coins;
@property (nonatomic, strong)NSString* pic;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, assign)NSInteger video_review;
@property (nonatomic, strong)NSString* duration;
@property (nonatomic, strong)NSString* create;
@property (nonatomic, strong)NSString* aid;
@property (nonatomic, assign)NSInteger play;
@end