//
//  recommendModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/21.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseViewModel.h"

@interface RecommendModel : BaseViewModel
@property (nonatomic, strong) NSArray* list;
@end

@interface RecommendDataModel : BaseViewModel
@property (nonatomic, strong)NSString* desc;
@property (nonatomic, strong)NSNumber* mid;
@property (nonatomic, strong)NSString* subtitle;
@property (nonatomic, strong)NSNumber* review;
@property (nonatomic, strong)NSNumber* favorites;
@property (nonatomic, strong)NSString* author;
@property (nonatomic, strong)NSNumber* coins;
@property (nonatomic, strong)NSString* pic;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSNumber* video_review;
@property (nonatomic, strong)NSString* duration;
@property (nonatomic, strong)NSString* create;
@property (nonatomic, strong)NSString* aid;
@property (nonatomic, strong)NSNumber* play;
@end