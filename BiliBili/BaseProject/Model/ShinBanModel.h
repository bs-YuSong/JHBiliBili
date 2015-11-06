//
//  ShinBanModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/10/28.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseModel.h"

//大家都在看
@interface MoreViewShinBanModel : BaseModel
@property (nonatomic, strong)NSArray* list;
@end
//推荐番剧
@interface RecommentShinBanModel : BaseModel
@property (nonatomic, strong)NSArray* list;
@end

@interface RecommentShinBanDataModel : BaseModel
@property (nonatomic, strong)NSNumber* is_finish;
@property (nonatomic, strong)NSString* season_id;
@property (nonatomic, strong)NSNumber* pub_time;
@property (nonatomic, strong)NSString* week;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* newest_ep_index;
@property (nonatomic, strong)NSString* cover;
@property (nonatomic, strong)NSNumber* total_count;
@property (nonatomic, strong)NSString* url;
@end

@interface MoreViewShinBanDataModel : BaseModel
@property (nonatomic, strong)NSNumber* play;
@property (nonatomic, strong)NSNumber* mid;
@property (nonatomic, strong)NSString* desc;
@property (nonatomic, strong)NSString* subtitle;
@property (nonatomic, strong)NSNumber* review;
@property (nonatomic, strong)NSNumber* favorites;
@property (nonatomic, strong)NSString* author;
@property (nonatomic, strong)NSString* pubdate;
@property (nonatomic, strong)NSNumber* coins;
@property (nonatomic, strong)NSString* pic;
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSNumber* credit;
@property (nonatomic, strong)NSNumber* video_review;
@property (nonatomic, strong)NSString* duration;
@property (nonatomic, strong)NSString* create;
@property (nonatomic, strong)NSNumber* aid;
@property (nonatomic, strong)NSNumber* typeID;
@end