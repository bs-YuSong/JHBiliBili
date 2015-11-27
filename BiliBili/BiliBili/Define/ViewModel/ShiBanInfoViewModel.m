//
//  ShiBanInfoModel.m
//  BiliBili
//
//  Created by apple-jd44 on 15/11/24.
//  Copyright © 2015年 JimHuang. All rights reserved.
//

#import "ShiBanInfoViewModel.h"
#import "ShinBanModel.h"
#import "NSString+Tools.h"
@interface ShiBanInfoViewModel ()
@property (nonatomic, strong) RecommentShinBanDataModel* rm;
@property (nonatomic, strong) NSString* videoAid;
@end

@implementation ShiBanInfoViewModel

//- (NSNumber*)currentEpisode{
//    return self.shiBan.episodes[_currentEpisode.intValue];
//}
- (NSInteger)shinBanInfoEpisodeCount{
    return self.shiBan.episodes.count;
}

- (NSArray*)shinBanInfoEpisode{
    return self.shiBan.episodes;
}

- (NSString*)shinBanInfoIntroduce{
    return self.shiBan.evaluate;
}
- (NSString*)shinBanInfoUpdateTime{
    if (self.shiBan.is_finish) {
        return @"已完结";
    }else if(self.shiBan.weekday && ![self.shiBan.weekday isEqualToString:@"-1"]){
        return [NSString stringWithFormat:@"连载中，每%@更新",@{@"1":@"周一",@"2":@"周二",@"3":@"周三",@"4":@"周四",@"5":@"周五",@"6":@"周六",@"0":@"周日"}[self.shiBan.weekday]];
    }
    return nil;
}
- (NSString*)shinBanInfoPlayNum{
    return [NSString stringWithFormatNum: self.shiBan.play_count.integerValue];
}
- (NSString*)shinBanInfodanMuNum{
    return [NSString stringWithFormatNum:self.shiBan.danmaku_count.integerValue];
}
- (NSURL*)shiBanCover{
    return [NSURL URLWithString:self.rm.cover];
}
- (NSString*)shiBanTitle{
    return self.rm.title;
}

- (BOOL)isShiBan{
    return YES;
}

/**
 *  当前集数下标转aid
 *
 */
- (NSString *)videoAid{
    return self.shiBan.episodes[self.currentEpisode.integerValue].av_id;
}

- (NSString *)indexToTitle{
    return self.shiBan.episodes[self.currentEpisode.integerValue].index;
}

- (void)setAVData:(RecommentShinBanDataModel *)shiBanData{
    self.rm = shiBanData;
}

- (void)refreshDataCompleteHandle:(void (^)(NSError *))complete{
    [AVInfoNetManager GetShiBanInfoWithParameter:self.rm.season_id completionHandler:^(ShinBanInfoModel* responseObj, NSError *error) {
        self.shiBan = responseObj.result;
        self.currentEpisode = self.shiBan.episodes==nil?nil:@(0);
        [super refreshDataCompleteHandle:complete];
    }];
}

@end
