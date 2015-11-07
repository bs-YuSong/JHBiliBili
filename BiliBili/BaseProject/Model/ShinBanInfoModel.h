//
//  ShinBanInfoModel.h
//  BiliBili
//
//  Created by apple-jd44 on 15/11/7.
//  Copyright © 2015年 Tarena. All rights reserved.
//

#import "BaseModel.h"
/**
 *  番剧详情
 */
@interface ShinBanInfoModel : BaseModel
@property (nonatomic, strong) NSArray* result;
@end

@interface ShinBanInfoDataModel : BaseModel
@property (nonatomic, strong)NSArray* related_seasons;
//别名
@property (nonatomic, strong)NSString* alias;
@property (nonatomic, strong)NSString* watchingCount;
@property (nonatomic, strong)NSNumber* viewRank;
@property (nonatomic, strong)NSString* coins;
@property (nonatomic, strong)NSString* season_title;
@property (nonatomic, strong)NSString* bangumi_id;
//名称
@property (nonatomic, strong)NSString* bangumi_title;
//staff
@property (nonatomic, strong)NSString* staff;
//播放数
@property (nonatomic, strong)NSString* play_count;
@property (nonatomic, strong)NSString* newest_ep_index;
@property (nonatomic, strong)NSString* danmaku_count;
@property (nonatomic, strong)NSString* favorites;
@property (nonatomic, strong)NSString* allow_download;
//更新日期
@property (nonatomic, strong)NSString* weekday;
//封面
@property (nonatomic, strong)NSString* cover;
@property (nonatomic, strong)NSString* area;
//分集
@property (nonatomic, strong)NSArray* episodes;

@property (nonatomic, strong)NSString* evaluate;
@property (nonatomic, strong)NSString* squareCover;
//是否完结 0 1
@property (nonatomic, assign)NSInteger is_finish;
@property (nonatomic, strong)NSString* total_count;
@property (nonatomic, strong)NSString* newest_ep_id;
@property (nonatomic, strong)NSString* pub_time;
@property (nonatomic, strong)NSDictionary* user_season;
//tag
@property (nonatomic, strong)NSArray* tags;

@property (nonatomic, strong)NSNumber* arealimit;
//其它系列
@property (nonatomic, strong)NSArray* seasons;

@property (nonatomic, strong)NSString* season_id;
//当前季名称
@property (nonatomic, strong)NSString* title;
@property (nonatomic, strong)NSString* share_url;
@property (nonatomic, strong)NSArray* actor;
//番剧简介
@property (nonatomic, strong)NSString* brief;
@property (nonatomic, strong)NSArray* tag2s;

@property (nonatomic, strong)NSString* allow_bp;
@end

//分集模型
@interface episodesModel : BaseModel
@property (nonatomic, strong)NSString* index;
@property (nonatomic, strong)NSDictionary* up;
@property (nonatomic, strong)NSString* index_title;
@property (nonatomic, strong)NSString* coins;
@property (nonatomic, strong)NSString* episode_id;
@property (nonatomic, strong)NSString* danmaku;
@property (nonatomic, strong)NSString* cover;
@property (nonatomic, strong)NSString* av_id;
@property (nonatomic, strong)NSString* is_webplay;
@property (nonatomic, strong)NSString* page;
@property (nonatomic, strong)NSString* update_time;
@end

//tag模型
@interface tagModel : BaseModel
@property (nonatomic, strong)NSString* tag_name;
@property (nonatomic, strong)NSString* tag_id;
@property (nonatomic, strong)NSString* style_id;
@property (nonatomic, strong)NSString* cover;
@property (nonatomic, strong)NSString* type;
@property (nonatomic, strong)NSNumber* orderType;
@property (nonatomic, strong)NSString* index;
@end